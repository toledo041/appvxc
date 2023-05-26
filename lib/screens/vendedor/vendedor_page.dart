import 'package:fashion_ecommerce_app/model/vededor_model.dart';
import 'package:fashion_ecommerce_app/screens/welcome_screen.dart';
import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/agenda.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/detalles.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/deudor_dialog.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/liquidados_page.dart';

enum SampleItem { deudores, liquidados, agenda, salir }

class VendedorPage extends StatelessWidget {
  const VendedorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePageVendedor(title: 'Vendedor'),
    );
  }
}

class HomePageVendedor extends StatefulWidget {
  const HomePageVendedor({super.key, required this.title});

  final String title;

  @override
  State<HomePageVendedor> createState() => _HomePageVendedorState();
}

class _HomePageVendedorState extends State<HomePageVendedor> {
  List<VendedorModel> itemsOnVendor = [];
  List carritos = [];

  void _incrementCounter() {
    setState(() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DeudorDialog();
          });
    });
  }

  @override
  void initState() {
    super.initState();

    () async {
      await getVentas();
      await getCarritoAll();

      for (var usuario in itemsOnVendor) {
        double deuda = 0.0;
        List listaElm = [];
        for (var carrito in carritos) {
          if (usuario.correo == carrito["correo"]) {
            deuda += (carrito["cantidad"] * carrito["precio"]);
            listaElm.add(carrito);
          }
          usuario.deuda = double.parse((deuda).toStringAsFixed(2));
          usuario.carrito = listaElm;
        }
      }

      setState(() {
        // Update your UI with the desired changes.
      });
    }();
  }

  Future getVentas() async {
    //<List<VendedorModel>>
    itemsOnVendor = await getUsuariosVenta();
    print("============== ventas: ${itemsOnVendor}");
    //return ventas;
  }

  Future getCarritoAll() async {
    carritos = await getTotalCarritoUsuario();
    print("============== carritos: ${carritos}");
  }

  @override
  Widget build(BuildContext context) {
    SampleItem? selectedMenu;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          getMenuItemBar(context, selectedMenu),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: itemsOnVendor.isEmpty
              ? Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    /*FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: const Image(
                    image: AssetImage("assets/images/empty.png"),
                    fit: BoxFit.fill,
                    height: size.height * 0.23,
                  ),
                ),*/
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    FadeInUp(
                      delay: const Duration(milliseconds: 250),
                      child: const Text(
                        "Su carrito está vacío en este momento",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: IconButton(
                        onPressed: () {
                          /*Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MainWrapper()));*/
                        },
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: itemsOnVendor.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var current = itemsOnVendor[index];
                    return FadeInUp(
                        delay: Duration(milliseconds: 100 * index + 80),
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: ListTile(
                            leading: CircleAvatar(
                                child: Text(
                                    current.nombre.substring(0, 1).toString())),
                            title: Text(current.nombre),
                            subtitle: const Text('Supporting text'),
                            trailing: Text(
                              "\u0024 ${current.deuda}",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetalleVenta()),
                              );
                            },
                          ),
                        ));
                  }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Agregar',
        child: const Icon(Icons.add),
      ),
    );
  }

  PopupMenuButton getMenuItemBar(
      BuildContext context, SampleItem? selectedMenu) {
    return PopupMenuButton<SampleItem>(
      initialValue: selectedMenu,
      // Callback that sets the selected popup menu item.
      onSelected: (SampleItem item) async {
        //opcion salir
        if (item.index == 2) {
          //sale sesión
          await FirebaseAuth.instance.signOut();
          if (!mounted) return;
          //se va a la pagina de login
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const WelcomeScreen();
          }));
          return;
        }
        setState(() {
          selectedMenu = item;
          if (selectedMenu != null) {
            if (selectedMenu?.index == 0) {
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  DetalleVenta()),
              );*/
            } else if (selectedMenu?.index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LiquidadosPage()),
              );
            } else if (selectedMenu?.index == 2) {
              //nada
            } else {
              print("Pendiente calendario?");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AgendaPage(
                          title: "Agenda",
                        )),
              );
            }
          }
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          value: SampleItem.deudores,
          child: Text('Deudores'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.liquidados,
          child: Text('Liquidados'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.agenda,
          child: Text('Agenda'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.agenda,
          child: Text('Cerrar sesión'),
        ),
      ],
    );
  }
}
