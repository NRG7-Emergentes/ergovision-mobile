import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();


  String currentName = 'John';
  String currentSurname = 'Doe';
  String currentAge = '30';
  String currentHeight = '180';
  String currentWeight = '75';

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController.text = currentName;
    surnameController.text = currentSurname;
    ageController.text = currentAge;
    heightController.text = currentHeight;
    weightController.text = currentWeight;
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
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
    String imgUrl = 'https://miro.medium.com/v2/resize:fit:1400/0*NZhcAbZxN52eFavp.jpg';

    return Scaffold(
      backgroundColor: const Color(0xFF121720),
      body: Column(
        children: [
          const SizedBox(
              width: double.infinity,
              child: Text(
                'Profile',
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              )
          ),
          SizedBox(height: 10),
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
                child: imgUrl.isNotEmpty
                    ? Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, size: 80, color: Colors.white);
                  },
                )
                    : const Icon(Icons.person, size: 80, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Modo lectura
          if (!isEditing)
            Column(
              children: [
                _infoRow('Name', currentName),
                SizedBox(height: 12),
                _infoRow('Surname', currentSurname),
                SizedBox(height: 12),
                _infoRow('Age', currentAge),
                SizedBox(height: 12),
                _infoRow('Height (cm)', currentHeight),
                SizedBox(height: 12),
                _infoRow('Weight (kg)', currentWeight),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      nameController.text = currentName;
                      surnameController.text = currentSurname;
                      ageController.text = currentAge;
                      heightController.text = currentHeight;
                      weightController.text = currentWeight;
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
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: const TextStyle(color: Color(0xFFA8B0B8)),
                      prefixIcon: const Icon(Icons.person, color: Color(0xFFA8B0B8)),
                      filled: true,
                      fillColor: const Color(0xFF1A2332),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: surnameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Surname',
                      labelStyle: const TextStyle(color: Color(0xFFA8B0B8)),
                      prefixIcon: const Icon(Icons.person, color: Color(0xFFA8B0B8)),
                      filled: true,
                      fillColor: const Color(0xFF1A2332),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: ageController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Age',
                      labelStyle: const TextStyle(color: Color(0xFFA8B0B8)),
                      prefixIcon: const Icon(Icons.date_range, color: Color(0xFFA8B0B8)),
                      filled: true,
                      fillColor: const Color(0xFF1A2332),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: heightController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Height (cm)',
                      labelStyle: const TextStyle(color: Color(0xFFA8B0B8)),
                      prefixIcon: const Icon(Icons.accessibility_new_rounded, color: Color(0xFFA8B0B8)),
                      filled: true,
                      fillColor: const Color(0xFF1A2332),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: weightController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      labelStyle: const TextStyle(color: Color(0xFFA8B0B8)),
                      prefixIcon: const Icon(Icons.accessibility_new_rounded, color: Color(0xFFA8B0B8)),
                      filled: true,
                      fillColor: const Color(0xFF1A2332),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Guardar cambios: actualizar valores actuales y salir de edición
                            setState(() {
                              currentName = nameController.text.trim().isEmpty ? currentName : nameController.text.trim();
                              currentSurname = surnameController.text.trim().isEmpty ? currentSurname : surnameController.text.trim();
                              currentAge = ageController.text.trim().isEmpty ? currentAge : ageController.text.trim();
                              currentHeight = heightController.text.trim().isEmpty ? currentHeight : heightController.text.trim();
                              currentWeight = weightController.text.trim().isEmpty ? currentWeight : weightController.text.trim();
                              isEditing = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A90E2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Cancelar: restaurar controllers y salir de edición
                            setState(() {
                              nameController.text = currentName;
                              surnameController.text = currentSurname;
                              ageController.text = currentAge;
                              heightController.text = currentHeight;
                              weightController.text = currentWeight;
                              isEditing = false;
                            });
                          },
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

  }
}
