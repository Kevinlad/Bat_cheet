import 'package:bat_cheet/Auth/connection.dart';
import 'package:bat_cheet/pages/Sigup.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Components/rounded_container.dart';
import '../Components/rounded_input.dart';
import '../Components/constant.dart';
import 'homePage.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool isLoading = false;

//   // void login(String email, String password) async {
//   //   UserCredential? credential;

//   //   try {
//   //     credential = await FirebaseAuth.instance
//   //         .signInWithEmailAndPassword(email: email, password: password);
//   //   } on FirebaseAuthException catch (e) {
//   //     print(e.code.toString());
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 30),
//         child: Center(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 50,
//               ),
//               Text(
//                 'ChatApp',
//                 style: TextStyle(fontSize: 20),
//               ),
//               TextField(
//                 // obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                 ),
//                 controller: emailController,
//               ),
//               TextField(
//                 // obscureText: true,s
//                 decoration: InputDecoration(
//                   labelText: 'password',
//                 ),
//                 controller: passwordController,
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                   onPressed: () {
//                     if (emailController.text.isNotEmpty &&
//                         passwordController.text.isNotEmpty) {
//                       setState(() {
//                         isLoading = true;
//                       });
//                       login(emailController.text, passwordController.text)
//                           .then((user) {
//                         if (user != null) {
//                           print("Login successfully");

//                           setState(() {
//                             isLoading = false;
//                           });
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: ((_) => HomeScreen())));
//                         }
//                       });
//                     } else {
//                       print('please a field');
//                     }
//                   },
//                   child: Text('Login')),
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 children: [
//                   Text('Dont have an account?'),
//                   ElevatedButton(
//                       onPressed: () {
//                         // Navigator.push(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //         builder: (context) => SignUpPag;e()))
//                       },
//                       child: Text('Sign Up'))
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Welcome Back',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Image.asset('asset/image/login.webp'),
                SizedBox(height: 20),
                RoundedInput(
                  icon: Icons.mail,
                  hint: 'Username',
                  controller: emailController,
                  obscuretext: false,
                ),
                SizedBox(
                  height: 10,
                ),
                RoundedInput(
                  icon: Icons.password,
                  hint: 'Password',
                  controller: passwordController,
                  obscuretext: true,
                ),
                SizedBox(
                  height: 10,
                ),
                RoundedButton(
                  title: 'LOGIN',
                  onTap: () {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      login(emailController.text, passwordController.text)
                          .then((user) {
                        if (user != null) {
                          print("Login successfully");

                          setState(() {
                            isLoading = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((_) => HomeScreen())));
                        }
                      });
                    } else {
                      print('please a field');
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Text(
                    "Forget Password",
                    style: TextStyle(color: kPrimaryColor, fontSize: 18),
                  ),
                  onTap: () {},
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: kPrimaryColor, fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
