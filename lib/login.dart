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
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0, bottom: 20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/image/logo.png'), width: screenWidth * 0.5, height: screenHeight * 0.3,),
              SizedBox(height: 5,),
              Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Container(
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                width: double.infinity,
                height: 225,
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
                            SizedBox(height: 10,),
                           
                            Center(
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (await checkUser(usernameController.text, passwordController.text)) {
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => Dashboard(),));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Login Gagal: Periksa username dan password Anda.')),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}