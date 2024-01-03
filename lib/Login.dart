import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'loginregister.dart';
import 'checkout.dart';
import 'order.dart';

class Login extends StatefulWidget {
  final double finalPrice;
  Login({required this.finalPrice});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passToggle = true;

  Future<void> loginUser(double finalPrice) async {
    final response = await http.post(
      Uri.parse("https://sherinemobile.000webhostapp.com/login.php"),
      body: {
        "email": emailController.text,
        "password": passController.text,
      },
    );
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      if (data['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Order(finalPrice: finalPrice),
          ),
        );
      } else {
        print("Login failed: ${data['message']}");
      }
    } else {
      print("Server error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset(
          "assets/logo.png",
          width: 200,
        ),
        elevation: 8.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),

        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width:190,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: 20),
          SizedBox(
            height: 50,
            width:190,
            child:
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: passController,
                obscureText: passToggle,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        passToggle = !passToggle;
                      });
                    },
                    child: Icon(
                      passToggle ? Icons.visibility : Icons.visibility_off,
                      color: passToggle ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your password";
                  } else if (passController.text.length < 6) {
                    return "Password length should be more than 6 characters";
                  }
                  return null;
                },
              ),
          ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  loginUser(widget.finalPrice);
                },
                child: Container(
                  height: 50,
                  width :120,// Set a smaller height
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),


              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You can register now for free",
                    style: TextStyle(fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Register(),
                      ));
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Color.fromARGB(255, 11, 11, 11),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
