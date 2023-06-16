import 'package:bat_cheet/Auth/connection.dart';
import 'package:bat_cheet/pages/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../Components/rounded_container.dart';
import '../Components/rounded_input.dart';
import '../Components/constant.dart';
import 'login.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final usernameController = TextEditingController();
//   bool isLoading = false;
//   validate() {
//     if (emailController.text.isEmpty && passwordController.text.isEmpty) {
//       print('fill the blanks');
//     } else {
//       signup(emailController.text, passwordController.text);
//     }
//   }

//   void signup(String email, String password) async {
//     UserCredential? credential;
//     try {
//       credential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//     } on FirebaseAuthException catch (e) {
//       print(e.code.toString());
//     }
//   }

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
//                 controller: emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//               ),
//               TextField(
//                   controller: usernameController,
//                   decoration: InputDecoration(labelText: 'Username')),
//               TextField(
//                   controller: passwordController,
//                   decoration: InputDecoration(labelText: 'password')),
//               SizedBox(
//                 height: 10,
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                   onPressed: () {
//                     // signup(emailController.text, passwordController.text);
//                     if (usernameController.text.isNotEmpty &&
//                         emailController.text.isNotEmpty &&
//                         passwordController.text.isNotEmpty) {
//                       setState(() {
//                         isLoading = true;
//                       });
//                       createAccount(emailController.text,
//                               usernameController.text, passwordController.text)
//                           .then((user) {
//                         if (user != null) {
//                           setState(() {
//                             isLoading = false;
//                           });
//                           print("Login Successfully");
//                         }
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => HomeScreen()));
//                       });
//                     } else {
//                       print('Please  enter fields');
//                     }
//                   },
//                   child: Text('Login')),
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 children: [
//                   Text('Already have an account?'),
//                   ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => LoginPage()));
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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  bool isLoading = false;
  validate() {
    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      print('fill the blanks');
    } else {
      signup(emailController.text, passwordController.text);
    }
  }

  void signup(String email, String password) async {
    // ignore: unused_local_variable
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'Welcome',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: 40),
              Image.asset('asset/image/login.webp'),
              SizedBox(height: 30),
              RoundedInput(
                  icon: Icons.person,
                  hint: 'Email',
                  controller: emailController,
                  obscuretext: false),
              SizedBox(
                height: 10,
              ),
              RoundedInput(
                icon: Icons.person,
                hint: 'Username',
                controller: usernameController,
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
                  title: 'SignUp',
                  onTap: () {
                    // signup(emailController.text, passwordController.text);
                    if (usernameController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      createAccount(emailController.text,
                              usernameController.text, passwordController.text)
                          .then((user) {
                        if (user != null) {
                          setState(() {
                            isLoading = false;
                          });
                          print("Login Successfully");
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => HomeScreen()));
                      });
                    } else {
                      print('Please  enter fields');
                    }
                  }),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(color: kPrimaryColor, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
