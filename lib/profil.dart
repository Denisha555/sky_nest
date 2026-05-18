import 'dart:io';

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

  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final ImagePicker picker = ImagePicker();

  File? fotoProfil;

  bool isEdit = false;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  // ================= AMBIL DATA =================

  Future<void> getDataUser() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    usernameController.text =
        prefs.getString('username') ?? '';

    passwordController.text =
        prefs.getString('password') ?? '';
  }

  // ================= PILIH FOTO =================

  Future<void> pilihFoto() async {

    final XFile? image =
        await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {

      setState(() {
        fotoProfil = File(image.path);
      });
    }
  }

  // ================= SIMPAN =================

  Future<void> simpanData() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'username',
      usernameController.text,
    );

    await prefs.setString(
      'password',
      passwordController.text,
    );

    setState(() {
      isEdit = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(
        content: Text(
          'Profil berhasil disimpan',
        ),
      ),
    );
  }

  // ================= LOGOUT =================

  Future<void> logout() async {

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text(
            "Logout",
          ),

          content: const Text(
            "Logout dari akun Anda?",
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                "Batal",
              ),
            ),

            TextButton(
              onPressed: () async {

                SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                await prefs.remove('username');
                await prefs.remove('password');
                await prefs.remove('isLogin');

                if (!mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const Login(),
                  ),
                  (route) => false,
                );
              },

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

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),

        title: const Text(
          "Profil",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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

        onTap: isEdit
            ? pilihFoto
            : null,

        child: Stack(

          children: [

            CircleAvatar(
              radius: 50,
              backgroundColor:
                  Colors.blue.shade100,

              backgroundImage:
                  fotoProfil != null
                      ? FileImage(fotoProfil!)
                      : null,

              child: fotoProfil == null
                  ? Icon(
                      Icons.person,
                      size: 55,
                      color:
                          Colors.blue.shade700,
                    )
                  : null,
            ),

            if (isEdit)

              Positioned(
                bottom: 0,
                right: 0,

                child: Container(
                  padding:
                      const EdgeInsets.all(6),

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
                      alignment:
                          Alignment.centerLeft,

                      child: Text(
                        "Username",

                        style: TextStyle(
                          fontSize: 14,
                          color:
                              Colors.grey.shade700,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(

                      controller:
                          usernameController,

                      enabled: isEdit,

                      decoration:
                          InputDecoration(

                        filled: true,
                        fillColor:
                            Colors.grey.shade100,

                        prefixIcon:
                            const Icon(
                          Icons.person_outline,
                        ),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  15),

                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= PASSWORD =================

                    Align(
                      alignment:
                          Alignment.centerLeft,

                      child: Text(
                        "Password",

                        style: TextStyle(
                          fontSize: 14,
                          color:
                              Colors.grey.shade700,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(

                      controller:
                          passwordController,

                      enabled: isEdit,

                      obscureText:
                          !isPasswordVisible,

                      decoration:
                          InputDecoration(

                        filled: true,
                        fillColor:
                            Colors.grey.shade100,

                        prefixIcon:
                            const Icon(
                          Icons.lock_outline,
                        ),

                        suffixIcon:
                            IconButton(

                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons
                                    .visibility_off,
                          ),

                          onPressed: () {

                            setState(() {
                              isPasswordVisible =
                                  !isPasswordVisible;
                            });
                          },
                        ),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  15),

                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ================= BUTTON =================

                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(

                        onPressed:
                            isEdit
                                ? simpanData
                                : null,

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              Colors.blue,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    15),
                          ),
                        ),

                        child: const Text(

                          "Simpan",

                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
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
            ],
          ),
        ),
      ),
    );
  }
}











// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'login.dart';

// class HalamanProfil extends StatefulWidget {
//   const HalamanProfil({super.key});

//   @override
//   State<HalamanProfil> createState() => _HalamanProfilState();
// }

// class _HalamanProfilState extends State<HalamanProfil> {

//   final TextEditingController usernameController =
//       TextEditingController();

//   final TextEditingController passwordController =
//       TextEditingController();

//   bool isEdit = false;
//   bool isPasswordVisible = false;

//   @override
//   void initState() {
//     super.initState();
//     getDataUser();
//   }

//   Future<void> getDataUser() async {

//     SharedPreferences prefs =
//         await SharedPreferences.getInstance();

//     usernameController.text =
//         prefs.getString('username') ?? '';

//     passwordController.text =
//         prefs.getString('password') ?? '';
//   }

//   Future<void> simpanData() async {

//     SharedPreferences prefs =
//         await SharedPreferences.getInstance();

//     await prefs.setString(
//       'username',
//       usernameController.text,
//     );

//     await prefs.setString(
//       'password',
//       passwordController.text,
//     );

//     setState(() {
//       isEdit = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(

//       const SnackBar(
//         content: Text(
//           'Profil berhasil disimpan',
//         ),
//       ),
//     );
//   }

//   Future<void> logout() async {

//     showDialog(
//       context: context,
//       builder: (context) {

//         return AlertDialog(

//           content: const Text(
//             "Logout dari akun Anda?"
//           ),

//           actions: [

//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Batal"),
//             ),

//             TextButton(
//               onPressed: () async {

//                 SharedPreferences prefs =
//                     await SharedPreferences.getInstance();

//                 await prefs.remove('username');
//                 await prefs.remove('password');
//                 await prefs.remove('isLogin');

//                 if (!mounted) return;

//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         const Login(),
//                   ),
//                   (route) => false,
//                 );
//               },

//               child: const Text(
//                 "Keluar",
//                 style: TextStyle(
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       backgroundColor: const Color(0xffF5F5F5),

//       appBar: AppBar(

//         backgroundColor: Colors.blue,
//         elevation: 0,

//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },

//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//         ),

//         actions: [

//           TextButton(
//             onPressed: () {

//               setState(() {
//                 isEdit = !isEdit;
//               });
//             },

//             child: Text(
//               isEdit ? "Cancel" : "Edit",

//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),

//       body: SingleChildScrollView(

//         child: Padding(
//           padding: const EdgeInsets.all(20),

//           child: Column(

//             children: [

//               const SizedBox(height: 10),

//               Container(

//                 padding: const EdgeInsets.all(20),

//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),

//                   boxShadow: [

//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                     ),
//                   ],
//                 ),

//                 child: Column(

//                   children: [

//                     CircleAvatar(
//                       radius: 45,
//                       backgroundColor: Colors.blue.shade100,

//                       child: Icon(
//                         Icons.person,
//                         size: 50,
//                         color: Colors.blue.shade700,
//                       ),
//                     ),

//                     const SizedBox(height: 15),

//                     const Text(
//                       "Profil",

//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 25),

//               Container(

//                 padding: const EdgeInsets.all(20),

//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),

//                   boxShadow: [

//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                     ),
//                   ],
//                 ),

//                 child: Column(

//                   children: [

//                     Align(
//                       alignment: Alignment.centerLeft,

//                       child: Text(
//                         "Username",

//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade700,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     TextField(

//                       controller: usernameController,
//                       enabled: isEdit,

//                       decoration: InputDecoration(

//                         filled: true,
//                         fillColor: Colors.grey.shade100,

//                         prefixIcon: const Icon(
//                           Icons.person_outline,
//                         ),

//                         border: OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.circular(15),

//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     Align(
//                       alignment: Alignment.centerLeft,

//                       child: Text(
//                         "Password",

//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade700,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     TextField(

//   controller: passwordController,
//   enabled: isEdit,
//   obscureText: !isPasswordVisible,

//   decoration: InputDecoration(

//     filled: true,
//     fillColor: Colors.grey.shade100,

//     prefixIcon: const Icon(
//       Icons.lock_outline,
//     ),

//     suffixIcon: IconButton(
//       icon: Icon(
//         isPasswordVisible
//             ? Icons.visibility
//             : Icons.visibility_off,
//       ),
//       onPressed: () {
//         setState(() {
//           isPasswordVisible =
//               !isPasswordVisible;
//         });
//       },
//     ),

//     border: OutlineInputBorder(
//       borderRadius:
//           BorderRadius.circular(15),

//       borderSide: BorderSide.none,
//     ),
//   ),
// ),

//                     const SizedBox(height: 25),

//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,

//                       child: ElevatedButton(

//                         onPressed:
//                             isEdit ? simpanData : null,

//                         style: ElevatedButton.styleFrom(

//                           backgroundColor: Colors.blue,

//                           shape: RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.circular(15),
//                           ),
//                         ),

//                         child: const Text(

//                           "Simpan",

//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 40),

//               GestureDetector(

//                 onTap: logout,

//                 child: const Text(

//                   "Logout",

//                   style: TextStyle(
//                     color: Colors.red,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class HalamanProfil extends StatefulWidget {
//   const HalamanProfil({super.key});

//   @override
//   State<HalamanProfil> createState() => _HalamanProfilState();
// }

// class _HalamanProfilState extends State<HalamanProfil> {

//   final TextEditingController usernameController =
//       TextEditingController();

//   final TextEditingController passwordController =
//       TextEditingController();

//   final ImagePicker picker = ImagePicker();

//   File? fotoProfil;

//   bool isEdit = false;

//   // ================= FOTO =================

//   Future<void> ambilFotoKamera() async {

//     final XFile? image = await picker.pickImage(
//       source: ImageSource.camera,
//     );

//     if (image != null) {

//       setState(() {
//         fotoProfil = File(image.path);
//       });
//     }

//     if (mounted) {
//       Navigator.pop(context);
//     }
//   }

//   Future<void> pilihFotoGaleri() async {

//     final XFile? image = await picker.pickImage(
//       source: ImageSource.gallery,
//     );

//     if (image != null) {

//       setState(() {
//         fotoProfil = File(image.path);
//       });
//     }

//     if (mounted) {
//       Navigator.pop(context);
//     }
//   }

//   void hapusFoto() {

//     Navigator.pop(context);

//     showDialog(
//       context: context,

//       builder: (context) {

//         return AlertDialog(

//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),

//           title: const Text(
//             "Hapus Foto",
//           ),

//           content: const Text(
//             "Apakah Anda yakin ingin menghapus foto profil?",
//           ),

//           actions: [

//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },

//               child: const Text(
//                 "Batal",
//               ),
//             ),

//             TextButton(
//               onPressed: () {

//                 setState(() {
//                   fotoProfil = null;
//                 });

//                 Navigator.pop(context);
//               },

//               child: const Text(
//                 "Hapus",

//                 style: TextStyle(
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void editFotoProfil() {

//     showModalBottomSheet(
//       context: context,

//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(25),
//         ),
//       ),

//       builder: (context) {

//         return Container(
//           padding: const EdgeInsets.all(20),

//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [

//               Container(
//                 width: 50,
//                 height: 5,

//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade400,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),

//               const SizedBox(height: 25),

//               ListTile(
//                 leading: const Icon(
//                   Icons.camera_alt,
//                   color: Colors.blue,
//                 ),

//                 title: const Text(
//                   "Ambil Foto",
//                 ),

//                 onTap: ambilFotoKamera,
//               ),

//               ListTile(
//                 leading: const Icon(
//                   Icons.photo,
//                   color: Colors.green,
//                 ),

//                 title: const Text(
//                   "Pilih dari Galeri",
//                 ),

//                 onTap: pilihFotoGaleri,
//               ),

//               ListTile(
//                 leading: const Icon(
//                   Icons.delete,
//                   color: Colors.red,
//                 ),

//                 title: const Text(
//                   "Hapus Foto",

//                   style: TextStyle(
//                     color: Colors.red,
//                   ),
//                 ),

//                 onTap: hapusFoto,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ================= SAVE =================

//   void simpanData() {

//     setState(() {
//       isEdit = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(

//       SnackBar(
//         backgroundColor: Colors.green,

//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),

//         behavior: SnackBarBehavior.floating,

//         content: const Text(
//           "Profil berhasil disimpan",
//         ),
//       ),
//     );
//   }

//   // ================= LOGOUT =================

//   void logout() {

//     showDialog(
//       context: context,

//       builder: (context) {

//         return AlertDialog(

//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),

//           title: const Text(
//             "Logout",
//           ),

//           content: const Text(
//             "Apakah Anda yakin ingin keluar?",
//           ),

//           actions: [

//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },

//               child: const Text(
//                 "Batal",
//               ),
//             ),

//             TextButton(
//               onPressed: () {

//                 Navigator.pop(context);

//                 ScaffoldMessenger.of(context).showSnackBar(

//                   SnackBar(
//                     backgroundColor: Colors.red,

//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),

//                     behavior: SnackBarBehavior.floating,

//                     content: const Text(
//                       "Berhasil logout",
//                     ),
//                   ),
//                 );
//               },

//               child: const Text(
//                 "Keluar",

//                 style: TextStyle(
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ================= UI =================

//   @override
//   Widget build(BuildContext context) {

//     return SafeArea(

//       child: Scaffold(
//         backgroundColor: const Color(0xffF5F6FA),

//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           elevation: 0,

//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },

//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             ),
//           ),

//           title: const Text(
//             "Profil",

//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),

//           centerTitle: true,

//           actions: [

//             TextButton(
//               onPressed: () {

//                 setState(() {
//                   isEdit = !isEdit;
//                 });
//               },

//               child: Text(
//                 isEdit ? "Cancel" : "Edit",

//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),

//         body: SingleChildScrollView(

//           child: Padding(
//             padding: const EdgeInsets.all(20),

//             child: Column(

//               children: [

//                 const SizedBox(height: 10),

//                 GestureDetector(
//                   onTap: isEdit
//                       ? editFotoProfil
//                       : null,

//                   child: Stack(

//                     children: [

//                       Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,

//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.15),
//                               blurRadius: 10,
//                               offset: const Offset(0, 5),
//                             ),
//                           ],
//                         ),

//                         child: CircleAvatar(
//                           radius: 55,
//                           backgroundColor: Colors.white,

//                           backgroundImage:
//                               fotoProfil != null
//                                   ? FileImage(fotoProfil!)
//                                   : null,

//                           child: fotoProfil == null
//                               ? const Icon(
//                                   Icons.person,
//                                   size: 70,
//                                   color: Colors.blue,
//                                 )
//                               : null,
//                         ),
//                       ),

//                       if (isEdit)

//                         Positioned(
//                           right: 0,
//                           bottom: 0,

//                           child: Container(
//                             padding: const EdgeInsets.all(8),

//                             decoration: BoxDecoration(
//                               color: Colors.blue,
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Colors.white,
//                                 width: 2,
//                               ),
//                             ),

//                             child: const Icon(
//                               Icons.edit,
//                               size: 18,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 15),

//                 const Text(
//                   "Profil",

//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 buildInput(
//                   title: "Username",
//                   controller: usernameController,
//                   enabled: isEdit,
//                   icon: Icons.person_outline,
//                 ),

//                 const SizedBox(height: 20),

//                 buildInput(
//                   title: "Password",
//                   controller: passwordController,
//                   enabled: isEdit,
//                   obscureText: true,
//                   icon: Icons.lock_outline,
//                 ),

//                 const SizedBox(height: 35),

//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,

//                   child: ElevatedButton(
//                     onPressed:
//                         isEdit ? simpanData : null,

//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,

//                       disabledBackgroundColor:
//                           Colors.grey.shade400,

//                       shape: RoundedRectangleBorder(
//                         borderRadius:
//                             BorderRadius.circular(15),
//                       ),
//                     ),

//                     child: const Text(
//                       "Simpan",

//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 GestureDetector(
//                   onTap: logout,

//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 14,
//                     ),

//                     decoration: BoxDecoration(
//                       color: Colors.red.shade50,

//                       borderRadius:
//                           BorderRadius.circular(15),

//                       border: Border.all(
//                         color: Colors.red.shade200,
//                       ),
//                     ),

//                     child: const Center(
//                       child: Text(
//                         "Logout",

//                         style: TextStyle(
//                           color: Colors.red,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildInput({
//     required String title,
//     required TextEditingController controller,
//     required bool enabled,
//     required IconData icon,
//     bool obscureText = false,
//   }) {

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,

//       children: [

//         Text(
//           title,

//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey.shade700,
//           ),
//         ),

//         const SizedBox(height: 8),

//         TextField(
//           controller: controller,
//           enabled: enabled,
//           obscureText: obscureText,

//           decoration: InputDecoration(

//             prefixIcon: Icon(
//               icon,
//               color: Colors.blue,
//             ),

//             filled: true,
//             fillColor: Colors.white,

//             contentPadding:
//                 const EdgeInsets.symmetric(
//               vertical: 16,
//             ),

//             border: OutlineInputBorder(
//               borderRadius:
//                   BorderRadius.circular(15),

//               borderSide: BorderSide.none,
//             ),

//             enabledBorder: OutlineInputBorder(
//               borderRadius:
//                   BorderRadius.circular(15),

//               borderSide: BorderSide(
//                 color: Colors.grey.shade300,
//               ),
//             ),

//             focusedBorder: OutlineInputBorder(
//               borderRadius:
//                   BorderRadius.circular(15),

//               borderSide: const BorderSide(
//                 color: Colors.blue,
//                 width: 1.5,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }