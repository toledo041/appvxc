import 'package:fashion_ecommerce_app/widgets/customized_button.dart';
import 'package:flutter/material.dart';
import 'package:fashion_ecommerce_app/widgets/customized_textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
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
              child: Text("Has olvidado tu contraseña?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  "No te preocupes.Te enviaremos un enlace para restablecer tu contraseña.",
                  style: TextStyle(
                    color: Color(0xff8391A1),
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  )),
            ),
            CustomizedTextfield(
              myController: _emailController,
              hintText: "Introduce tu Email",
              isPassword: false,
            ),
            CustomizedButton(
              buttonText: "Enviar codigo",
              buttonColor: Colors.black,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(
              flex: 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(68, 8, 8, 8.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Recordar contraseña?",
                      style: TextStyle(
                        color: Color(0xff1E232C),
                        fontSize: 15,
                      )),
                  InkWell(
                    onTap: () {},
                    child: const Text("  Acceder",
                        style: TextStyle(
                          color: Color(0xff35C2C1),
                          fontSize: 15,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
