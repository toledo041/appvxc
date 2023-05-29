import 'package:animate_do/animate_do.dart';
import 'package:fashion_ecommerce_app/model/direccion_model.dart';
import 'package:fashion_ecommerce_app/screens/cart.dart';
import 'package:fashion_ecommerce_app/screens/form_check_cart.dart';

import 'package:fashion_ecommerce_app/services/firebase_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../data/app_data.dart';
import '../../widget/reuseable_row_for_cart.dart';
import '../model/base_model.dart';

enum PagoUsuario { tarjeta, aPlazos }

const List<String> listaMetodoPago = <String>[
  'Seleccione una opción',
  'Contado',
  'En abonos'
];
String dropdownPagoValue = listaMetodoPago.first;
String abonoValue = "";

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  DireccionModel direccionUsuario = DireccionModel();
  double totalCompra = 0.0;

  /// Calcular el precio total
  double calculateTotalPrice() {
    double total = 0.0;
    if (itemsOnCart.isEmpty) {
      total = 0;
    } else {
      for (BaseModel data in itemsOnCart) {
        total = total + data.price * data.value;
      }
    }
    total = double.parse((total).toStringAsFixed(2));
    totalCompra = total;
    return total;
  }

  /// Calcular costo de envio
  double calculateShipping() {
    double shipping = 0.0;
    if (itemsOnCart.isEmpty) {
      shipping = 0.0;
      return shipping;
    } else {
      //if (itemsOnCart.length <= 4) {
      shipping = 25.99;
      for (BaseModel data in itemsOnCart) {
        shipping = shipping + data.price.round();
        //subTotal - 160;
      }
      shipping = double.parse((shipping * 0.09).toStringAsFixed(2));
      return shipping;
    }
  }

  /// Calcular el precio subtotal
  double calculateSubTotalPrice() {
    double subTotal = 0.0;
    if (itemsOnCart.isEmpty) {
      subTotal = 0.0;
    } else {
      for (BaseModel data in itemsOnCart) {
        subTotal = subTotal + data.price;
        subTotal += double.parse(
            (subTotal * 0.15).toStringAsFixed(2)); //subTotal - 160;
      }
    }
    return subTotal;
  }

  /// eliminar función para carrito
  void onDelete(BaseModel data) async {
    //Si la cantidad es 0 se borra el elemento
    await borrarElmCarritoUsuario(data.uid);
    setState(() {
      if (itemsOnCart.length == 1) {
        itemsOnCart.clear();
      } else {
        itemsOnCart.removeWhere((element) => element.id == data.id);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    () async {
      await getCart();
      await getDomicilioUsuario();
      String? correo = await FirebaseAuth.instance.currentUser?.email;
      getPagoUsuario(correo.toString());
      setState(() {});
    }();
  }

  Future getCart() async {
    String? correo = await FirebaseAuth.instance.currentUser?.email;
    itemsOnCart = [];
    //Se obtiene el carrito del usuario con su correo
    List carrito = await getCarritoUsuario(correo.toString());
    //Se llena la información obtenida con el modelo de la aplicación
    int index = 0;
    for (var element in carrito) {
      BaseModel model = BaseModel(
          id: index,
          imageUrl: "imageUrl",
          name: element["codigo"],
          price: element["precio"],
          review: 0.0,
          talla: element["tamano"],
          value: element["cantidad"],
          uid: element["uid"]);
      itemsOnCart.add(model);
      index++;
    }
  }

  Future getDomicilioUsuario() async {
    String? correoUsr = await FirebaseAuth.instance.currentUser?.email;
    String nombre = await getNombreUsuario(correoUsr.toString());
    List direccion = await getDireccionUsuario(correoUsr.toString());
    for (var element in direccion) {
      DireccionModel modelo = DireccionModel(
          calle: element["calle"] ?? "",
          colonia: element["colonia"] ?? "",
          descripcion: element["descripcion"] ?? "",
          estado: element["estado"] ?? "",
          municipio: element["municipio"] ?? "",
          numeroExt: element["numero_ext"] ?? "",
          numeroInt: element["numero_int"] ?? "",
          telefono: element["telefono"] ?? "",
          nombre: nombre,
          correo: correoUsr.toString());
      direccionUsuario = modelo;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            /// Bottom Card
            Positioned(
              //bottom: 0,
              child: Container(
                width: size.width,
                height: size.height * 0.9,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 12.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 450),
                        child: ReuseableRowForCart(
                          price: calculateShipping(),
                          text: 'Envío',
                        ),
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        child: ReuseableRowForCart(
                          price: calculateTotalPrice(),
                          text: 'Subtotal',
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Divider(),
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        child: ReuseableRowForCart(
                          price: (calculateTotalPrice() + calculateShipping()),
                          text: 'Total',
                        ),
                      ),

                      //Datos de dirección
                      FadeInUp(
                        delay: const Duration(milliseconds: 550),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Enviar a",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              color: Colors.black87,
                                              //fontSize: 18
                                            )),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                          "Calle ${direccionUsuario.calle} #${direccionUsuario.numeroExt}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                  color: Colors.grey,
                                                  fontSize: 16)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                          " ${direccionUsuario.estado}, ${direccionUsuario.municipio}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                  color: Colors.grey,
                                                  fontSize: 16)),
                                      Text(
                                          " ${direccionUsuario.nombre}  tel. ${direccionUsuario.telefono}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                  color: Colors.grey,
                                                  fontSize: 16))
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                      CheckCartForm(
                          total: (calculateTotalPrice() + calculateShipping()),
                          direccionModel: direccionUsuario),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Orden de compra",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
      ),
      leading: IconButton(
        onPressed: () {
          //Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Cart()));
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            LineIcons.user,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
