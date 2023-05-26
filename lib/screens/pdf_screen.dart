import 'dart:ffi';

import 'package:advance_notification/advance_notification.dart';
import 'package:animate_do/animate_do.dart';
import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:fashion_ecommerce_app/screens/cart.dart';
import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import '../../widget/reuseable_button.dart';
import '../../widget/add_to_cart.dart';
import '../model/base_model.dart';

import 'package:pdfx/pdfx.dart';

class PdfScreen extends StatefulWidget {
  final String path;
  final String marca;

  const PdfScreen({super.key, required this.path, required this.marca});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  late PdfController pdfController;
  final String? correo = FirebaseAuth.instance.currentUser?.email;
  String name = "";

  final codigoController = TextEditingController();
  final tamTallaController = TextEditingController();
  final cantidadController = TextEditingController();
  final precioController = TextEditingController();

  loadController() {
    pdfController = PdfController(document: PdfDocument.openAsset(widget.path));
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.path);
    loadController();
    () async {
      name = await getNombreUsuario(correo.toString());
      print("nombre: ${name}");
      setState(() {
        // Update your UI with the desired changes.
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    String contactNumber;
    String pin;
    int current = 1;

    return Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              padding: const EdgeInsets.all(12),
              alignment: Alignment.center,
              child: Text(
                  pdfController.pagesCount == null
                      ? ''
                      : "pages ${pdfController.pagesCount}",
                  style: const TextStyle() //textStyle(font: poppings),
                  ),
            )
          ],
          title: const Text(
            "Archivo",
            style: const TextStyle(),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Color(0xffFA7267),
              )),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: PdfView(
                  controller: pdfController,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (page) {
                    print(page);
                  },
                ),
              ),
            ),
            Expanded(
                flex: 7,
                child: Form(
                  //key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        //onSaved: (String value){contactNumber=value;},
                        controller: codigoController,
                        keyboardType: TextInputType.text,
                        //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        maxLength: 10,
                        decoration: const InputDecoration(
                            labelText: "Introduzca código de producto",
                            hintText: "Number",
                            icon: Icon(Icons.shopping_bag)),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        validator: (value) {
                          if (!value.isNullOrEmpty()) {}
                        },
                      ),
                      TextFormField(
                        controller: tamTallaController,
                        keyboardType: TextInputType.text,
                        maxLength: 10,
                        decoration: const InputDecoration(
                            labelText: "Introduzca tamaño/talla del producto",
                            hintText: "Number",
                            icon: Icon(Icons.open_in_full_rounded)),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      TextFormField(
                        controller: cantidadController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                          signed: false,
                        ),
                        maxLength: 25,
                        decoration: const InputDecoration(
                            labelText: "Introduzca la cantidad del producto",
                            hintText: "Number",
                            icon: Icon(Icons.numbers)),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      TextFormField(
                        controller: precioController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        maxLength: 10,
                        decoration: const InputDecoration(
                            labelText: "Introduzca el precio del producto",
                            hintText: "Number",
                            icon: Icon(
                              Icons.local_atm_rounded,
                            )),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      //waka

                      FadeInUp(
                        delay: const Duration(milliseconds: 800),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01),
                          child: ReuseableButton(
                            text: "Añadir al carrito",
                            onTap: () async {
                              if (codigoController.text.isEmpty) {
                                const AdvanceSnackBar(
                                  textSize: 14.0,
                                  message: 'Introduzca un código válido.',
                                  mode: Mode.ADVANCE,
                                  duration: Duration(seconds: 5),
                                  icon: Icon(Icons.error),
                                ).show(context);
                              }
                              if (tamTallaController.text.isEmpty) {
                                const AdvanceSnackBar(
                                  textSize: 14.0,
                                  message: 'Introduzca un tamaño/talla válido.',
                                  mode: Mode.ADVANCE,
                                  duration: Duration(seconds: 5),
                                  icon: Icon(Icons.error),
                                ).show(context);
                              }
                              if (cantidadController.text.isEmpty) {
                                const AdvanceSnackBar(
                                  textSize: 14.0,
                                  message: 'Introduzca una cantidad válida.',
                                  mode: Mode.ADVANCE,
                                  duration: Duration(seconds: 5),
                                  icon: Icon(Icons.error),
                                ).show(context);
                              }
                              if (precioController.text.isEmpty) {
                                const AdvanceSnackBar(
                                  textSize: 14.0,
                                  message: 'Introduzca un precio válido.',
                                  mode: Mode.ADVANCE,
                                  duration: Duration(seconds: 5),
                                  icon: Icon(Icons.error),
                                ).show(context);
                              }

                              String? correo = await FirebaseAuth
                                  .instance.currentUser?.email;
                              print(correo.toString());
                              //Se agrega el producto a la base
                              await addCarritoUsuario(
                                  codigoController.text,
                                  tamTallaController.text,
                                  int.parse(cantidadController.text),
                                  double.parse(precioController.text),
                                  correo.toString(),
                                  widget.marca,
                                  name);

                              BaseModel modelo = BaseModel(
                                  id: 1,
                                  imageUrl: "assets/image/sw.jpg",
                                  name: codigoController.text,
                                  price: double.parse(precioController.text),
                                  review: 0.0,
                                  talla: tamTallaController.text,
                                  value: int.parse(cantidadController.text));
                              AddToCart.addToCart(modelo, context);

                              codigoController.text = "";
                              tamTallaController.text = "";
                              cantidadController.text = "";
                              precioController.text = "";

                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
