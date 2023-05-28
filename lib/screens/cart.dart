//import 'dart:ffi';

import 'package:animate_do/animate_do.dart';
import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../data/app_data.dart';
import '../../widget/reuseable_row_for_cart.dart';
import '../../main_wrapper.dart';
import '../model/base_model.dart';
import '../../utils/constants.dart';
import '../../widget/reuseable_button.dart';
import 'verificar_page.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
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
    } /*else {
      shipping = 88.99;
      return shipping;
    }*/
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
      //print("Codigo ${element["codigo"]}");
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
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            SizedBox(
              width: size.width,
              height: size.height * 0.5,
              child: itemsOnCart.isEmpty

                  /// List is Empty:
                  ? Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        SizedBox(
                          height: size.height * 0.01,
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
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainWrapper()));
                            },
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    )

                  /// List is Not Empty:
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: itemsOnCart.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var current = itemsOnCart[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: 100 * index + 80),
                          child: Container(
                            color: (index % 2 == 1)
                                ? Colors.white70
                                : Colors.white,
                            margin: const EdgeInsets.all(5.0),
                            width: size.width,
                            height: size.height * 0.3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /*SizedBox(
                                  height: size.height * 0.01,
                                ),*/
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: size.width * 0.9,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Código:  ${current.name}",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    onDelete(current);
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.grey,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                      RichText(
                                          text: TextSpan(
                                              text:
                                                  "${String.fromCharCode(36)} ",
                                              style: textTheme.titleSmall
                                                  ?.copyWith(
                                                fontSize: 18,
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: [
                                            TextSpan(
                                              text: current.price.toString(),
                                              style: textTheme.titleSmall
                                                  ?.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          ])),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      Text(
                                        "Talla/Tamaño:  ${current.talla.isEmpty ? sizes[3] : current.talla}", //sizes[3]
                                        style: textTheme.titleMedium?.copyWith(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: size.height * 0.02,
                                        ),
                                        width: size.width * 0.4,
                                        height: size.height * 0.04,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(4.0),
                                              width: size.width * 0.065,
                                              //height: size.height * 0.04,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                onTap: () async {
                                                  setState(() {
                                                    if (current.value > 1) {
                                                      current.value--;
                                                    } else {
                                                      onDelete(current);
                                                      current.value = 1;
                                                    }
                                                  });

                                                  await actualizaCantCarritoUsuario(
                                                      current.uid,
                                                      current.value);
                                                },
                                                child: const Icon(
                                                  Icons.remove,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.width * 0.02),
                                              child: Text(
                                                current.value.toString(),
                                                style: textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(4.0),
                                              width: size.width * 0.065,
                                              height: 20, //size.height * 0.045,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                onTap: () async {
                                                  setState(() {
                                                    current.value >= 0
                                                        ? current.value++
                                                        : null;
                                                  });

                                                  await actualizaCantCarritoUsuario(
                                                      current.uid,
                                                      current.value);
                                                },
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
            ),

            /// Bottom Card
            Positioned(
              bottom: 0, //posiciona hasta abajo
              child: Container(
                width: size.width,
                height: size.height * 0.40,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 0.0),
                  child: Column(
                    children: [
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
                      const Divider(
                        color: Colors.black38,
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 450),
                        child: ReuseableRowForCart(
                          price: calculateShipping(),
                          text: 'Envio',
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
                                  text: "Realizar la compra",
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CheckPage()));
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
        "Mi Carrito",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
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
