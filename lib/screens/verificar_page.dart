import 'package:animate_do/animate_do.dart';
import 'package:fashion_ecommerce_app/screens/cart.dart';

import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../data/app_data.dart';
import '../../widget/reuseable_row_for_cart.dart';
import '../model/base_model.dart';
import '../../widget/reuseable_button.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
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
  int calculateSubTotalPrice() {
    int subTotal = 0;
    if (itemsOnCart.isEmpty) {
      subTotal = 0;
    } else {
      for (BaseModel data in itemsOnCart) {
        subTotal = subTotal + data.price.round();
        subTotal = (subTotal * 0.15).round(); //subTotal - 160;
      }
    }
    return subTotal < 0 ? 0 : subTotal;
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
      setState(() {
        // Update your UI with the desired changes.
      });
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //var textTheme = Theme.of(context).textTheme;

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
                height: size.height * 0.40,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 12.0),
                  child: Column(
                    children: [
                      //const Divider(color: Colors.black),
                      /*FadeInUp(
                        delay: const Duration(milliseconds: 350),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Promoción/Código de estudiante o vales",
                              style: textTheme.headlineMedium
                                  ?.copyWith(fontSize: 16),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),*/
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
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Divider(),
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        child: ReuseableRowForCart(
                          price: calculateTotalPrice(),
                          text: 'Total',
                        ),
                      ),

                      FadeInUp(
                        delay: const Duration(milliseconds: 550),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Expanded(
                              child: ReuseableButton(
                                  text: "Realizar pedido",
                                  onTap: () {
                                    Navigator.pop(context);
                                    /*Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Cart()));*/
                                  }),
                            )),
                      )
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
