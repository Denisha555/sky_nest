import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  

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
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Masukkan Username",
                              
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text("Password", style: TextStyle(fontWeight: FontWeight.bold),),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Masukkan Password",
                              ),
                            ),
                            SizedBox(height: 10,),
                           
                            Center(
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Implement login logic here
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