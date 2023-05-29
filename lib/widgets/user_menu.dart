import 'package:fashion_ecommerce_app/screens/direccion_usuario.dart';
import 'package:fashion_ecommerce_app/screens/tarjeta_usuario.dart';
import 'package:fashion_ecommerce_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListViewUserMenu extends StatefulWidget {
  const ListViewUserMenu({super.key});

  @override
  State<ListViewUserMenu> createState() => _ListViewUserMenuState();
}

class _ListViewUserMenuState extends State<ListViewUserMenu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.black26,
          ),
          child: Column(
            children: [
              Text('Información'),
              CircleAvatar(
                child: Image(
                  image: AssetImage("assets/images/empty.png"),
                  alignment: Alignment.center,
                ),
              )
            ],
          ),
        ),
        /*ListTile(
          title: const Text('Inicio'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
            setState(() {});           
          },
        ),*/
        ListTile(
          title: const Text('Datos de dirección'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            //Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const DireccionPage();
            }));
          },
        ),
        ListTile(
          title: const Text('Datos de tarjeta de crédito'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            //Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const TarjetaPage();
            }));
          },
        ),
        ListTile(
          title: const Text('Cerrar sesión'),
          onTap: () async {
            //sale sesión
            await FirebaseAuth.instance.signOut();
            //se va a la pagina de login
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const WelcomeScreen();
            }));
          },
        ),
      ],
    );
  }
}
