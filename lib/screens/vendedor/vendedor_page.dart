//import 'dart:js_util';

import 'package:bottom_bar_matu/components/colors.dart';
import 'package:fashion_ecommerce_app/main_wrapper.dart';
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

enum SampleItem { deudores, liquidados, agenda, comprar, salir }

class VendedorPage extends StatelessWidget {
  const VendedorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, //
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
  List<PagoModel> pagos = [];

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
      pagos = await getPagosUsuarios();

      for (var usuario in itemsOnVendor) {
        usuario.liquidada = false;
        double deuda = 0.0;
        double shipping = 0.0;
        List listaElm = [];
        String marcas = "";
        //DEUDA
        for (var carrito in carritos) {
          if (usuario.correo == carrito["correo"]) {
            deuda += (carrito["cantidad"] * carrito["precio"]);
            listaElm.add(carrito);
            if (!marcas.contains(carrito["marca"])) {
              marcas += carrito["marca"] + " ";
            }
          }

          usuario.deuda = double.parse((deuda).toStringAsFixed(2));

          usuario.carrito = listaElm;
        }
        //Se calcula el envío y se suma a la deuda
        shipping = (deuda + (deuda == 0.0 ? 0.0 : 25.99)) * 0.09;
        shipping = double.parse((shipping).toStringAsFixed(2));
        usuario.deuda = (deuda + shipping);
        //ABONO
        for (var element in pagos) {
          //print("usuario ${usuario.correo} liquidado? ${element.correo}");
          if (usuario.correo == element.correo) {
            print("pago ${element}");
            usuario.liquidada = element.liquidada;
            double pagado = element.abono;
            break;
          }
        }
        print("usuario ${usuario.correo} liquidado? ${usuario.liquidada}");
        usuario.marcas = marcas;
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
                    //Si no ha comprado nada no, muestre el usuario
                    return (current.liquidada || current.deuda == 0.0)
                        ? Container()
                        : FadeInUp(
                            delay: Duration(milliseconds: 100 * index + 80),
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              width: MediaQuery.of(context).size.width,
                              //height: MediaQuery.of(context).size.height * 0.10,
                              color: colorGrey7, // [index % 2]? col,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                        child: Text(current.nombre
                                            .substring(0, 1)
                                            .toString())),
                                    title: Text(current.nombre),
                                    subtitle:
                                        Text('Compro en: ${current.marcas}'),
                                    trailing: Text(
                                      "\u0024 ${current.deuda}",
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetalleVenta(
                                                  modeloVendedor: current,
                                                )),
                                      );
                                    },
                                  ),
                                  const Divider(height: 0)
                                ],
                              ),
                            ));
                  }),
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Agregar',
        child: const Icon(Icons.add),
      ),*/
    );
  }

  PopupMenuButton getMenuItemBar(
      BuildContext context, SampleItem? selectedMenu) {
    return PopupMenuButton<SampleItem>(
      initialValue: selectedMenu,
      // Callback that sets the selected popup menu item.
      onSelected: (SampleItem item) async {
        setState(() {
          switch (item) {
            case SampleItem.salir:
              () async {
                //sale sesión
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                //se va a la pagina de login
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const WelcomeScreen();
                }));
                return;
              }();
              break;
            case SampleItem.deudores:
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetalleVenta()),
              );*/
              break;
            case SampleItem.liquidados:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LiquidadosPage()),
              );
              break;
            case SampleItem.agenda:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AgendaPage(
                          title: "Agenda",
                        )),
              );
              break;
            case SampleItem.comprar:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainWrapper()),
              );
              break;
            default:
          }
        });
        /*if (item.index == 4) {
          //sale sesión
          await FirebaseAuth.instance.signOut();
          if (!mounted) return;
          //se va a la pagina de login
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const WelcomeScreen();
          }));
          return;
        }*/
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          value: SampleItem.deudores,
          child: Row(
            children: [
              Icon(
                Icons.point_of_sale_rounded,
                color: colorGrey1,
              ),
              Text('   Deudores')
            ],
          ),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.liquidados,
          child: Row(
            children: [
              Icon(
                Icons.price_check_rounded,
                color: colorGrey1,
              ),
              Text('   Liquidados')
            ],
          ),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.agenda,
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: colorGrey1,
              ),
              Text('   Agenda')
            ],
          ),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.comprar,
          child: Row(
            children: [
              Icon(
                Icons.shopping_cart_checkout_rounded,
                color: colorGrey1,
              ),
              Text('   Comprar productos')
            ],
          ),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.salir,
          child: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: colorGrey1,
              ),
              Text('   Cerrar sesión')
            ],
          ),
        ),
      ],
    );
  }
}
