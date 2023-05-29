import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:fashion_ecommerce_app/widgets/customized_textfield.dart';
import 'package:fashion_ecommerce_app/widgets/user_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fashion_ecommerce_app/widgets/customized_button.dart';
import 'package:flutter/material.dart';

class DireccionPage extends StatefulWidget {
  const DireccionPage({Key? key}) : super(key: key);

  @override
  State<DireccionPage> createState() => _DireccionPageState();
}

class _DireccionPageState extends State<DireccionPage> {
  final String? userName = FirebaseAuth.instance.currentUser?.displayName;
  final TextEditingController calleController = TextEditingController();
  final TextEditingController coloniaController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController municipioController = TextEditingController();
  final TextEditingController numIntController = TextEditingController();
  final TextEditingController numExtController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  bool direccionPpal = true;

  @override
  void initState() {
    super.initState();

    () async {
      await getDireccion();
      setState(() {
        // Update your UI with the desired changes.
      });
    }();
  }

  Future getDireccion() async {
    String? correo = await FirebaseAuth.instance.currentUser?.email;

    List datos = await getDireccionUsuario(correo.toString());
    //print("Datos ${datos}");
    for (var element in datos) {
      calleController.text = element["calle"] ?? "";
      coloniaController.text = element["colonia"] ?? "";
      descripcionController.text = element["descripcion"] ?? "";
      direccionPpal = element["dirppal"] ?? true;
      estadoController.text = element["estado"] ?? "";
      municipioController.text = element["municipio"] ?? "";
      numExtController.text = element["numero_ext"] ?? "";
      numIntController.text = element["numero_int"] ?? "";
      telefonoController.text = element["telefono"] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Dirección del usuario"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomizedTextfield(
                myController: estadoController,
                hintText: "Estado",
                isPassword: false,
              ),
              CustomizedTextfield(
                myController: municipioController,
                hintText: "Municipio",
                isPassword: false,
              ),
              CustomizedTextfield(
                myController: coloniaController,
                hintText: "Colonia",
                isPassword: false,
              ),
              CustomizedTextfield(
                myController: calleController,
                hintText: "Calle",
                isPassword: false,
              ),
              CustomizedTextfield(
                myController: numIntController,
                hintText: "Número interior",
                isPassword: false,
              ),
              CustomizedTextfield(
                myController: numExtController,
                hintText: "Número exterior",
                isPassword: false,
              ),
              CustomizedTextfield(
                myController: telefonoController,
                hintText: "Telefono",
                isPassword: false,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 3, // Set this
                  maxLines: 6,
                  //obscureText: true,
                  controller: descripcionController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: const Color(0xffE8ECF4),
                    filled: true,
                    hintText: "Descripción de domicilio",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              CustomizedButton(
                buttonText: "Guardar información",
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
                    String? correo =
                        await FirebaseAuth.instance.currentUser?.email;
                    //Se guarda la dirección
                    await addDireccionUsuario(
                        correo.toString(),
                        estadoController.text.trim(),
                        municipioController.text.trim(),
                        coloniaController.text.trim(),
                        calleController.text.trim(),
                        numIntController.text.trim(),
                        numExtController.text.trim(),
                        direccionPpal,
                        descripcionController.text.trim(),
                        telefonoController.text.trim());

                    Navigator.pop(context);
                    /*await FirebaseAuthService().login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        vendedor);
                    vendedor =
                        await getUsuarioVendedor(_emailController.text.trim());

                    if (FirebaseAuth.instance.currentUser != null) {
                      if (!mounted) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => (vendedor == true
                                  ? const VendedorPage()
                                  : const MainWrapper()))); //HomeScreen
                                  
                    }*/

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
                                      /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpScreen()));*/
                                    },
                                  )
                                ]));
                  }

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
              ),
              const SizedBox(
                height: 140,
              ),
            ],
          ),
        ),
      ),
      drawer: const Drawer(child: ListViewUserMenu()),
    );
  }
}
