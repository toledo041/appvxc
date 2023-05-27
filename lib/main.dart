import '../firebase_options.dart';
import '../screens/home_screen.dart';
import '../screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ComerceApp());
}

class ComerceApp extends StatefulWidget {
  const ComerceApp({Key? key}) : super(key: key);

  @override
  State<ComerceApp> createState() => _ComerceAppPageState();
}

class _ComerceAppPageState extends State<ComerceApp> {
  bool vendedor = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.urbanistTextTheme(),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          //future: Future<bool> getUsuarioVendedor(correo),
          builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          //print(snapshot.data?.email);
          if (snapshot.data?.email != null) {
            //String? email = snapshot.data?.email;
            //bool vendedor = await getUsuarioVendedor(email);
          }

          return const HomeScreen();
        } else {
          return const WelcomeScreen();
        }
      }),

      /*StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot snapshot) as{
          if (snapshot.hasData) {
            print(snapshot.data?.email);
            if(snapshot.data?.email != null){
              String? email = snapshot.data?.email;
              bool vendedor = await getUsuarioVendedor(email);
            }
            
            return const Home();
          } else {
            return const WelcomeScreen();
          }
        },
      ),*/
    );
  }
}
