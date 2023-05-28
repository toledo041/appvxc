//import 'dart:ffi';

import 'package:fashion_ecommerce_app/screens/form_capture_product.dart';
import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    //print(widget.path);
    loadController();
    () async {
      name = await getNombreUsuario(correo.toString());
      //print("nombre: ${name}");
      setState(() {
        // Update your UI with the desired changes.
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(),
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
                    //print(page);
                  },
                ),
              ),
            ),
            Expanded(
                flex: 7,
                child: CapturaProductsForm(
                  marca: widget.marca,
                  path: widget.path,
                ))
          ],
        ));
  }
}
