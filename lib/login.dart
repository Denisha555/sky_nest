import 'package:flutter/material.dart';
import 'package:flutter_application_1/dashboard.dart';
import 'package:flutter_application_1/services/add_user.dart';
import 'package:flutter_application_1/services/check_user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.1,),
            Image(image: AssetImage('assets/image/logo.png'), width: screenWidth * 0.5, height: screenHeight * 0.2,),
            SizedBox(height: 5,),
            Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            SizedBox(height: 15,),
            
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0, bottom: 30.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      height: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Username", style: TextStyle(fontWeight: FontWeight.bold),),
                                  TextFormField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Masukkan Username",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Username tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 5,),
                                  Text("Password", style: TextStyle(fontWeight: FontWeight.bold),),
                                  TextFormField(
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Masukkan Password",
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                    
                                  ),
                                  SizedBox(height: 15,),
                                 
                                  Center(
                                    child: Container(
                                      width: double.infinity,
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            if (await checkUser(usernameController.text, passwordController.text)) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Login Berhasil!'), backgroundColor: Colors.green,),
                                              );
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => Dashboard(),));
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Login Gagal: Periksa username dan password Anda.'), backgroundColor: Colors.red,),
                                              );
                                            }
                                          }
                                          checkUser(usernameController.text, passwordController.text);
                                        },
                                        
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text("Login", style: TextStyle(color: Colors.white),),
                                      ),
                                                                      ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}