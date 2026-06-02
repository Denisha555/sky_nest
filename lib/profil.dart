import 'dart:io';
import 'package:flutter_application_1/services/get_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class HalamanProfil extends StatefulWidget {
  const HalamanProfil({super.key});

  @override
  State<HalamanProfil> createState() => _HalamanProfilState();
}

class _HalamanProfilState extends State<HalamanProfil> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  File? fotoProfil;

  bool isEdit = false;
  bool isPasswordVisible = false;
  bool gantiUsername = false;
  bool gantiPassword = false;
  bool gantiFoto = false;
  String fotoUrl = '';

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  // ================= AMBIL DATA =================

  Future<void> getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    usernameController.text = prefs.getString('username') ?? '';

  usernameController.text = await getUsername(prefs.getString('id')!);


    String? fotoPath = prefs.getString('foto_profil');

    if (fotoPath != null && File(fotoPath).existsSync()) {
      setState(() {
        fotoProfil = File(fotoPath);
      });
    }
  }

  // ================= PILIH FOTO =================

  Future<void> pilihFoto() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('foto_profil', image.path);

      setState(() {
        fotoProfil = File(image.path);
      });
    }
  }

  // ================= SIMPAN =================
  Future<void> simpanData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();


      String usernameLama = prefs.getString('username') ?? '';

      print("Username lama: $usernameLama");
      print("Username baru: ${usernameController.text}");

      Map<String, dynamic> dataUpdate = {'username': usernameController.text};

      if (usernameController.text != usernameLama) {
        gantiUsername = true;
      }

      if (fotoProfil != null) {
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();

        await Supabase.instance.client.storage
            .from('foto-profil')
            .upload(fileName, File(fotoProfil!.path));

        final imageUrl = Supabase.instance.client.storage
            .from('foto-profil')
            .getPublicUrl(fileName);

        dataUpdate['foto_profil'] = imageUrl;
        gantiFoto = true;
      }

      if (passwordController.text.trim().isNotEmpty) {
        String passwordHash =
            sha256.convert(utf8.encode(passwordController.text)).toString();

        dataUpdate['password'] = passwordHash;
        gantiPassword = true;
      }

      //     Map<String, dynamic> dataUpdate = {
      //       'username': usernameController.text,
      //     };

      //     if (fotoProfil != null) {
      //   dataUpdate['foto_profil'] = fotoProfil!.path;
      // }

      //     if (passwordController.text.trim().isNotEmpty) {
      //       String passwordHash = sha256
      //           .convert(
      //             utf8.encode(
      //               passwordController.text,
      //             ),
      //           )
      //           .toString();

      //       dataUpdate['password'] = passwordHash;
      //     }

      final result =
          await Supabase.instance.client
              .from('user')
              .update(dataUpdate)
              .eq('username', usernameLama)
              .select();

      print("HASIL UPDATE: $result");

      String pesan = '';

      if (gantiUsername && gantiPassword && gantiFoto) {
        pesan = 'Username, password, dan profil berhasil diperbarui';
      } else if (gantiUsername && gantiPassword) {
        pesan = 'Username dan password berhasil diperbarui';
      } else if (gantiUsername && gantiFoto) {
        pesan = 'Username dan foto profil berhasil diperbarui';
      } else if (gantiPassword && gantiFoto) {
        pesan = 'Password dan foto profil berhasil diperbarui';
      } else if (gantiUsername) {
        pesan = 'Username berhasil diperbarui';
      } else if (gantiPassword) {
        pesan = 'Password berhasil diperbarui';
      } else if (gantiFoto) {
        pesan = 'Foto profil berhasil diperbarui';
      } else {
        pesan = 'Tidak ada perubahan data';
      }

      await prefs.setString('username', usernameController.text);

      setState(() {
        isEdit = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(pesan), backgroundColor: Colors.green),
      );
    } catch (e) {
      print("ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    final userId = prefs.getString('id');

    String passwordHash = "";

    if (passwordController.text.trim().isNotEmpty) {
      passwordHash = sha256
          .convert(
            utf8.encode(
              passwordController.text,
            ),
          )
          .toString();
    }

    final result = await Supabase.instance.client
        .from('user')
        .update({"username": usernameController.text, "password": passwordHash})
        .eq('id', userId!)
        .select();

    print("HASIL UPDATE: $result");

    setState(() {
      isEdit = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Username dan Password berhasil disimpan',
        ),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    print("ERROR: $e");

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Gagal menyimpan data: $e',
        ),
        backgroundColor: Colors.red,
      ),
    );

  }

  //   Future<void> simpanData() async {
  //   try {
  //     SharedPreferences prefs =
  //         await SharedPreferences.getInstance();

  //     String usernameLama =
  //         prefs.getString('username') ?? '';

  //     Map<String, dynamic> dataUpdate = {
  //       'username': usernameController.text,
  //     };

  //     if (passwordController.text.trim().isNotEmpty) {
  //       String passwordHash =
  //           sha256
  //               .convert(
  //                 utf8.encode(
  //                   passwordController.text,
  //                 ),
  //               )
  //               .toString();

  //       dataUpdate['password'] =
  //           passwordHash;
  //     }

  //     await Supabase.instance.client
  //         .from('user')
  //         .update(dataUpdate)
  //         .eq('username', usernameLama);

  //     await prefs.setString(
  //       'username',
  //       usernameController.text,
  //     );

  //     setState(() {
  //       isEdit = false;
  //     });

  //     if (!mounted) return;

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //           'Username dan Password berhasil disimpan',
  //         ),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } catch (e) {
  //     if (!mounted) return;

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           'Gagal menyimpan data: $e',
  //         ),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  // ================= LOGOUT =================

  Future<void> logout() async {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),

          content: const Text("Logout dari akun Anda?"),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Batal"),
            ),

            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                await prefs.clear();

                if (!mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false,
                );
              },


              child: const Text("Keluar", style: TextStyle(color: Colors.red)),

              child: const Text(
                "Keluar",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),

        title: const Text(
          "Profil",

          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isEdit = !isEdit;
              });
            },

            child: Text(
              isEdit ? "Cancel" : "Edit",

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const SizedBox(height: 2),

              // ================= FOTO PROFIL =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    GestureDetector(
                      onTap: isEdit ? pilihFoto : null,

                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.blue.shade100,

                            backgroundImage:
                                fotoProfil != null
                                    ? FileImage(fotoProfil!)
                                    : fotoUrl.isNotEmpty
                                    ? NetworkImage(fotoUrl)
                                    : null,
                                    
                            child:
                                fotoProfil == null
                                    ? Icon(
                                      Icons.person,
                                      size: 55,
                                      color: Colors.blue.shade700,
                                    )
                                    : null,
                          ),

                          if (isEdit)
                            Positioned(
                              bottom: 0,
                              right: 0,

                              child: Container(
                                padding: const EdgeInsets.all(6),

                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),

                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Profil",

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              // ================= FORM =================
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    // ================= USERNAME =================
                    Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        "Username",

                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: usernameController,

                      enabled: isEdit,

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,

                        prefixIcon: const Icon(Icons.person_outline),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),

                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= PASSWORD =================
                    Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        "Password",

                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: passwordController,

                      enabled: isEdit,

                      obscureText: !isPasswordVisible,

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,

                        prefixIcon: const Icon(Icons.lock_outline),

                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),

                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),

                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ================= BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: isEdit ? simpanData : null,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),

                        child: const Text(
                          "Simpan",

                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ================= LOGOUT =================
              GestureDetector(
                onTap: logout,

                child: const Text(
                  "Logout",

                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
