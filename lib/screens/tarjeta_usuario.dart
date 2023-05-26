import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:fashion_ecommerce_app/widgets/customized_textfield.dart';
import 'package:fashion_ecommerce_app/widgets/user_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/welcome_screen.dart';
import '../../widgets/customized_button.dart';
import 'package:flutter/material.dart';

class TarjetaPage extends StatefulWidget {
  const TarjetaPage({Key? key}) : super(key: key);

  @override
  State<TarjetaPage> createState() => _TarjetaPageState();
}

class _TarjetaPageState extends State<TarjetaPage> {
  final String? userName = FirebaseAuth.instance.currentUser?.displayName;
  final TextEditingController tarjetaController = TextEditingController();
  //bool direccionPpal = true;

  @override
  void initState() {
    super.initState();

    () async {
      await getTarjeta();
      setState(() {
        // Update your UI with the desired changes.
      });
    }();
  }

  Future getTarjeta() async {
    String? correo = await FirebaseAuth.instance.currentUser?.email;

    List datos = await getTarjetaUsuario(correo.toString());
    datos.forEach((element) {
      tarjetaController.text = element["tarjeta"];
    });
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
                myController: tarjetaController,
                hintText: "N° de tarjeta",
                isPassword: false,
              ),
              CustomizedButton(
                buttonText: "Guardar información",
                buttonColor: Colors.black,
                textColor: Colors.white,
                onPressed: () async {
                  try {
                    String? correo =
                        await FirebaseAuth.instance.currentUser?.email;
                    //Se guarda la dirección
                    await addTarjetaUsuario(
                        correo.toString(), tarjetaController.text.trim());

                    Navigator.pop(context);
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
