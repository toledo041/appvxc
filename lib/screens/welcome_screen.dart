import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../widgets/customized_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/fondo.jpg"))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(
              height: 250,
              width: 250,
              child: Image(
                  image: AssetImage("assets/vclog.jpg"), fit: BoxFit.cover),
            ),
            const SizedBox(height: 40),
            CustomizedButton(
              buttonText: "Acceder",
              buttonColor: Colors.black,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
            ),
            CustomizedButton(
              buttonText: "Registrarse",
              buttonColor: Colors.white,
              textColor: Colors.black,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()));
              },
            ),
            const SizedBox(height: 20),
            //Se quito lo de continuar como invitado
            /*const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Continuar como invitado",
                style: TextStyle(color: Color(0xff35C2C1), fontSize: 25),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
