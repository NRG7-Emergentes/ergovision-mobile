import 'dart:convert';
import 'package:ergovision/history/model/session_detail.dart';
import 'package:ergovision/history/model/session_response.dart';
import 'package:ergovision/history/model/session_summary.dart';
import 'package:ergovision/shared/client/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String _localKey = 'local_sessions_queue_v1';

  /// Get all sessions for the current authenticated user using /monitoringSession/me
  Future<List<SessionSummary>> listSessions() async {
    try {
      print('[HistoryService] Fetching sessions via /monitoringSession/me');
      final response = await ApiClient.get('monitoringSession/me');
      print('[HistoryService] Response status: ${response.statusCode}');

      List<SessionResponse> remote = [];
      if (response.statusCode == 200) {
        final body = response.body.trim();
        if (body.isNotEmpty) {
          final List<dynamic> jsonList = jsonDecode(body);
          remote = jsonList.map((e) => SessionResponse.fromJson(e)).toList();
          print('[HistoryService] Remote sessions count: ${remote.length}');
        }
      } else {
        print('[HistoryService] Remote fetch failed status=${response.statusCode} body=${response.body}');
      }

      final local = await _getLocalSessions();
      print('[HistoryService] Local queued sessions count: ${local.length}');

      // Combine remote first then local (local = unsynced / negative ids)
      final combined = [...remote, ...local];
      final summaries = combined.map(_mapToSummary).toList();
      print('[HistoryService] Returning ${summaries.length} summaries');
      return summaries;
    } catch (e) {
      print('[HistoryService] Exception fetching sessions: $e');
      final local = await _getLocalSessions();
      return local.map(_mapToSummary).toList();
    }
  }

  /// Refresh convenience (same as listSessions for now)
  Future<List<SessionSummary>> refreshSessions() => listSessions();

  /// Get detailed information about a specific session – first try remote if id > 0
  Future<SessionDetail?> getSession(String id) async {
    try {
      final numericId = int.tryParse(id);
      if (numericId == null) {
        print('[HistoryService] Invalid session ID: $id');
        return null;
      }

      if (numericId < 0) {
        // Local unsynced session
        final localSessions = await _getLocalSessions();
        final local = localSessions.where((s) => s.id == numericId).toList();
        if (local.isNotEmpty) {
          return _mapToDetail(local.first);
        }
        print('[HistoryService] Local session not found for $id');
        return null;
      }

      final response = await ApiClient.get('monitoringSession/$id');
      print('[HistoryService] GET /monitoringSession/$id status=${response.statusCode}');
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final session = SessionResponse.fromJson(json);
        return _mapToDetail(session);
      }

      // Fallback to local if remote fails
      final localSessions = await _getLocalSessions();
      final fallback = localSessions.where((s) => s.id == numericId).toList();
      if (fallback.isNotEmpty) {
        return _mapToDetail(fallback.first);
      }
      return null;
    } catch (e) {
      print('[HistoryService] Error getSession($id): $e');
      return null;
    }
  }

  /// Save a session locally in SharedPreferences
  Future<SessionResponse> _saveLocalSession(SessionResponse sessionData) async {
    final local = await _getLocalSessions();
    final id = -DateTime.now().millisecondsSinceEpoch; // negative id

    final entry = SessionResponse(
      id: id,
      startDate: sessionData.startDate,
      endDate: sessionData.endDate,
      score: sessionData.score,
      goodScore: sessionData.goodScore,
      badScore: sessionData.badScore,
      goodPostureTime: sessionData.goodPostureTime,
      badPostureTime: sessionData.badPostureTime,
      duration: sessionData.duration,
      numberOfPauses: sessionData.numberOfPauses,
      averagePauseDuration: sessionData.averagePauseDuration,
    );

    local.insert(0, entry);

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = local.map((s) => s.toJson()).toList();
      await prefs.setString(_localKey, jsonEncode(jsonList));
    } catch (e) {
      print('[HistoryService] Failed to persist local session queue: $e');
    }

    return entry;
  }

  /// Read queued local sessions from SharedPreferences
  Future<List<SessionResponse>> _getLocalSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_localKey);

      if (raw == null || raw.isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(raw);
      return jsonList.map((json) => SessionResponse.fromJson(json)).toList();
    } catch (e) {
      print('[HistoryService] Failed to read local session queue: $e');
      return [];
    }
  }

  /// Map API response to SessionSummary for list display
  SessionSummary _mapToSummary(SessionResponse session) {
    print('[HistoryService] Mapping session to summary: ${session.id}');
    return SessionSummary(
      id: session.id.toString(),
      date: _formatDate(session.startDate),
      duration: _secondsToHms(session.duration),
    );
  }

  /// Map API response to SessionDetail for detail display
  SessionDetail _mapToDetail(SessionResponse session) {
    final totalTime = session.duration;
    final goodTime = session.goodPostureTime;
    final badTime = session.badPostureTime;

    // Calculate percentages
    final activeTime = goodTime + badTime; // total active time (excluding pauses)
    final goodPercent = activeTime > 0 ? ((goodTime / activeTime) * 100).round() : 0;
    final badPercent = activeTime > 0 ? ((badTime / activeTime) * 100).round() : 0;

    // Calculate total pause time
    final totalPauseTime = session.numberOfPauses * session.averagePauseDuration;

    return SessionDetail(
      id: session.id.toString(),
      date: _formatDate(session.startDate),
      duration: _secondsToHms(totalTime),
      posture: PostureData(
        goodPercent: goodPercent,
        badPercent: badPercent,
        goodTime: _secondsToHms(goodTime),
        badTime: _secondsToHms(badTime),
      ),
      pauses: PauseData(
        count: session.numberOfPauses,
        avgTime: _secondsToHms(session.averagePauseDuration),
        totalTime: _secondsToHms(totalPauseTime),
      ),
    );
  }

  /// Format date string to readable format (YYYY-MM-DD)
  String _formatDate(String dateString) {
    try {
      if (dateString.isEmpty) return 'N/A';

      // Already YYYY-MM-DD
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateString)) {
        return dateString;
      }

      // ISO 8601 with timezone from backend e.g. 2025-12-02T02:01:37.080+00:00
      try {
        final parsedIso = DateTime.parse(dateString);
        return parsedIso.toLocal().toIso8601String().split('T')[0];
      } catch (_) {
        // continue to other formats
      }

      // Legacy backend format DD-MM-YYYY HH:mm:ss
      final legacy = RegExp(r'^(\d{2})-(\d{2})-(\d{4})\s+(\d{2}):(\d{2}):(\d{2})$');
      final match = legacy.firstMatch(dateString);
      if (match != null) {
        final day = match.group(1)!;
        final month = match.group(2)!;
        final year = match.group(3)!;
        return '$year-$month-$day';
      }

      // Fallback generic parse
      final generic = DateTime.tryParse(dateString);
      if (generic != null) {
        return generic.toLocal().toIso8601String().split('T')[0];
      }

      print('[HistoryService] Unrecognized date format: $dateString');
      return 'Invalid Date';
    } catch (e) {
      print('[HistoryService] Error formatting date: $dateString $e');
      return 'Invalid Date';
    }
  }

  /// Convert seconds to HH:MM:SS format
  String _secondsToHms(double seconds) {
    final hours = (seconds / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    final secs = (seconds % 60).floor();

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
