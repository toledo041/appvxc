import 'package:fashion_ecommerce_app/main_wrapper.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/vendedor_page.dart';
import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/home_screen.dart';
import '../screens/signup_screen.dart';
import '../widgets/customized_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/firebase_auth_service.dart';
import '../widgets/customized_button.dart';
import 'forgot_passwor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool vendedor = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_sharp),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("¡Bienvenido de nuevo!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              CustomizedTextfield(
                myController: _emailController,
                hintText: "Introduce tu Email",
                isPassword: false,
              ),
              CustomizedTextfield(
                myController: _passwordController,
                hintText: "Introduce tu  Contraseña",
                isPassword: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()));
                    },
                    child: const Text("Has olvidado tu contraseña?",
                        style: TextStyle(
                          color: Color(0xff6A707C),
                          fontSize: 15,
                        )),
                  ),
                ),
              ),
              CustomizedButton(
                buttonText: "Acceder",
                buttonColor: Colors.black,
                textColor: Colors.white,
                onPressed: () async {
                  //  The else part is not working in the video because we have
                  //  enclosed it in the try catch block. Once we have error in
                  // login the firebase exception is thrown and the codeblock after that
                  // error is skiped and code of catch block is executed.
                  // if we want our else part to be executed we need to get rid from
                  // this try catch or add that code in catch block.

                  try {
                    await FirebaseAuthService().login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        vendedor);
                    vendedor == false;
                        //await getUsuarioVendedor(_emailController.text.trim());

                    if (FirebaseAuth.instance.currentUser != null) {
                      if (!mounted) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => (vendedor == true
                                  ? const VendedorPage()
                                  : const MainWrapper()))); //HomeScreen
                    }

                    //  This code is gone inside the catch block
                    // which is executed only when we have firebaseexception
                    //  else {
                    //   showDialog(
                    //       context: context,
                    //       builder: (context) => AlertDialog(
                    //               title: Text(
                    //                   " Usuario o contraseña invalido. Regístrese de nuevo o asegúrese de que el nombre de usuario y la contraseña sean correctos"),
                    //               actions: [
                    //                 ElevatedButton(
                    //                   child: Text("Registrate Ahora"),
                    //                   onPressed: () {
                    //                     Navigator.push(
                    //                         context,
                    //                         MaterialPageRoute(
                    //                             builder: (context) =>
                    //                                 SignUpScreen()));
                    //                   },
                    //                 )
                    //               ]));

                    // }
                  } on FirebaseException catch (e) {
                    debugPrint("el error es ${e.message}");

                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                                title: const Text(
                                    " Usuario o contraseña invalido. Regístrese de nuevo o asegúrese de que el nombre de usuario y la contraseña sean correctos"),
                                actions: [
                                  ElevatedButton(
                                    child: const Text("Registrate ahora"),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpScreen()));
                                    },
                                  )
                                ]));
                  }

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.height * 0.15,
                      color: Colors.grey,
                    ),
                    const Text("o inicia sesión con "),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.height * 0.18,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.blue,
                          ),
                          onPressed: () {},
                        )),
                    Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.google,
                          // color: Colors.blue,
                        ),
                        onPressed: () async {
                          await FirebaseAuthService().logininwithgoogle();

                          if (FirebaseAuth.instance.currentUser != null) {
                            if (!mounted) return;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          } else {
                            throw Exception("Error");
                          }
                        },
                      ),
                    ),
                    Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.apple,
                            // color: Colors.blue,
                          ),
                          onPressed: () {},
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 140,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(48, 8, 8, 8.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text("No tienes una cuenta?",
                        style: TextStyle(
                          color: Color(0xff1E232C),
                          fontSize: 15,
                        )),
                    Text(" Registrate ahora",
                        style: TextStyle(
                          color: Color(0xff35C2C1),
                          fontSize: 15,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
