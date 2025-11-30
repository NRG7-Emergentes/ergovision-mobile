import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ergovision/shared/bloc/user/user_bloc.dart';
import 'package:ergovision/shared/bloc/user/user_event.dart';
import 'package:ergovision/shared/bloc/user/user_state.dart';
import 'package:ergovision/shared/models/update_user_request.dart';
import 'package:ergovision/shared/models/user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  bool isEditing = false;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    // Fetch user profile on init
    context.read<UserBloc>().add(FetchUserProfileEvent());
  }

  @override
  void dispose() {
    emailController.dispose();
    imageUrlController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  void _loadUserDataIntoControllers(User user) {
    emailController.text = user.email;
    imageUrlController.text = user.imageUrl;
    ageController.text = user.age.toString();
    heightController.text = user.height.toString();
    weightController.text = user.weight.toString();
    currentUser = user;
  }

  void _saveProfile() {
    if (currentUser == null) return;

    final updateRequest = UpdateUserRequest(
      email: emailController.text.trim().isEmpty ? currentUser!.email : emailController.text.trim(),
      imageUrl: imageUrlController.text.trim().isEmpty ? currentUser!.imageUrl : imageUrlController.text.trim(),
      age: int.tryParse(ageController.text.trim()) ?? currentUser!.age,
      height: int.tryParse(heightController.text.trim()) ?? currentUser!.height,
      weight: double.tryParse(weightController.text.trim()) ?? currentUser!.weight,
    );

    context.read<UserBloc>().add(UpdateUserProfileEvent(updateRequest));
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false;
      if (currentUser != null) {
        _loadUserDataIntoControllers(currentUser!);
      }
    });
  }

  Widget _infoRow(String label, String value) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: const Color(0xFF1A2332),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFF2A3A4A),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121720),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            _loadUserDataIntoControllers(state.user);
            setState(() {
              isEditing = false;
            });
          } else if (state is UserUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is UserFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
            // Reload user data on failure
            if (currentUser != null) {
              _loadUserDataIntoControllers(currentUser!);
            }
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4A90E2),
              ),
            );
          }

          final bool isUpdating = state is UserUpdating;
          final User? user = state is UserLoaded
              ? state.user
              : state is UserUpdating
                  ? state.currentUser
                  : currentUser;

          if (user == null) {
            return const Center(
              child: Text(
                'No user data available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Profile',
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: user.imageUrl.isNotEmpty
                          ? Image.network(
                              user.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person, size: 80, color: Colors.white);
                              },
                            )
                          : const Icon(Icons.person, size: 80, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Modo lectura
                if (!isEditing)
                  Column(
                    children: [
                      _infoRow('Username', user.username),
                      const SizedBox(height: 12),
                      _infoRow('Email', user.email),
                      const SizedBox(height: 12),
                      _infoRow('Age', '${user.age} years old'),
                      const SizedBox(height: 12),
                      _infoRow('Height', '${user.height} cm'),
                      const SizedBox(height: 12),
                      _infoRow('Weight', '${user.weight} kg'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: isUpdating
                            ? null
                            : () {
                                setState(() {
                                  _loadUserDataIntoControllers(user);
                                  isEditing = true;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Edit', style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ],
                  )
                else
                  // Modo edición
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                            prefixIcon: Icon(Icons.email, color: Color(0xFFA8B0B8)),
                            filled: true,
                            fillColor: Color(0xFF1A2332),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: imageUrlController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Profile Image URL',
                            labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                            prefixIcon: Icon(Icons.image, color: Color(0xFFA8B0B8)),
                            filled: true,
                            fillColor: Color(0xFF1A2332),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: ageController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                            prefixIcon: Icon(Icons.date_range, color: Color(0xFFA8B0B8)),
                            filled: true,
                            fillColor: Color(0xFF1A2332),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: heightController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Height (cm)',
                            labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                            prefixIcon: Icon(Icons.accessibility_new_rounded, color: Color(0xFFA8B0B8)),
                            filled: true,
                            fillColor: Color(0xFF1A2332),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: weightController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                            labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                            prefixIcon: Icon(Icons.accessibility_new_rounded, color: Color(0xFFA8B0B8)),
                            filled: true,
                            fillColor: Color(0xFF1A2332),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isUpdating ? null : _saveProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A90E2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: isUpdating
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Save', style: TextStyle(color: Colors.white, fontSize: 20)),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isUpdating ? null : _cancelEdit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF232D3A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Cancel', style: TextStyle(color: Colors.white, fontSize: 20)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );

  }
}
