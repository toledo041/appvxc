// Define un widget de formulario personalizado
import 'package:advance_notification/advance_notification.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fashion_ecommerce_app/model/direccion_model.dart';
import 'package:fashion_ecommerce_app/model/vededor_model.dart';
import 'package:fashion_ecommerce_app/services/firebase_service.dart';

import 'package:fashion_ecommerce_app/widget/reuseable_button.dart';
import 'package:fashion_ecommerce_app/widgets/custom_drop_down.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const List<String> listaMetodoPago = <String>[
  'Seleccione una opción',
  'Contado',
  'En abonos'
];
String dropdownPagoValue = 'Seleccione una opción';
String abonoValue = "";

///Forma con la información de captura que se usara para capturar los productos
class CheckCartForm extends StatefulWidget {
  final double total;
  final DireccionModel direccionModel;

  const CheckCartForm(
      {super.key, required this.total, required this.direccionModel});
  @override
  State<CheckCartForm> createState() => CapturaProductsFormState();
}

// Define una clase de estado correspondiente. Esta clase contendrá los datos
// relacionados con el formulario.
class CapturaProductsFormState extends State<CheckCartForm> {
  final _formKey = GlobalKey<FormState>();

  final String? correo = FirebaseAuth.instance.currentUser?.email;
  String name = "";
  List<ProductoModel> listaProductos = [];
  final abonoController = TextEditingController();

  //static String _displayStringForOption(ProductoModel option) => option.codigo;

  @override
  void initState() {
    super.initState();

    /*() async {
      await getCatalogo();
      setState(() {
        // Update your UI with the desired changes.
      });
    }();*/
  }

  @override
  Widget build(BuildContext context) {
    // Cree un widget Form usando el _formKey que creamos anteriormente
    //var size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          FadeInUp(
            delay: const Duration(milliseconds: 550),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Row(
                children: [
                  Text("Su pago se realizará:  ",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.grey, fontSize: 16)),
                  Expanded(
                    child: CustomDropdownButton(
                      listaOpciones: listaMetodoPago,
                      onCambioItem: (value) {
                        print("valor seleccionado ${value}");
                        dropdownPagoValue = value;

                        setState(() {
                          if (value == "Contado") {
                            abonoController.text = widget.total.toString();
                          } else {
                            abonoController.text = "";
                          }
                        });
                        print("abono: ${abonoController.text}");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          FadeInUp(
            delay: const Duration(milliseconds: 550),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Row(
                children: [
                  Text("Cantidad del abono:  ",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.grey, fontSize: 16)),
                  Expanded(
                    child: TextFormField(
                      controller: abonoController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      maxLength: 10,
                      decoration: const InputDecoration(
                        hintText: "Numérico",
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      /*onChanged: (value) {
                        abonoController.text = value;
                        print("cambio ${value}");

                        setState(() {
                          if (widget.total < double.parse(value)) {
                            const AdvanceSnackBar(
                              textSize: 14.0,
                              message:
                                  'La cantidad abonada no debe ser mayor al total.',
                              mode: Mode.ADVANCE,
                              duration: Duration(seconds: 4),
                              icon: Icon(Icons.error),
                            ).show(context);
                          }
                          if (0.0 > double.parse(value)) {
                            const AdvanceSnackBar(
                              textSize: 14.0,
                              message:
                                  'La cantidad abonada no debe ser menor a cero.',
                              mode: Mode.ADVANCE,
                              duration: Duration(seconds: 4),
                              icon: Icon(Icons.error),
                            ).show(context);
                          }
                        });
                      },*/
                    ),
                  ),
                ],
              ),
            ),
          ),
          FadeInUp(
            delay: const Duration(milliseconds: 550),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: ReuseableButton(
                  text: "Realizar pedido",
                  onTap: () async {
                    print(
                        "valor drop ${dropdownPagoValue} abono ${abonoController.text}");
                    if (dropdownPagoValue == "Seleccione una opción") {
                      const AdvanceSnackBar(
                        textSize: 14.0,
                        message: 'Seleccione como se realizará su pago.',
                        mode: Mode.ADVANCE,
                        duration: Duration(seconds: 4),
                        icon: Icon(Icons.error),
                      ).show(context);
                      return;
                    }

                    if (abonoController.text.isEmpty) {
                      const AdvanceSnackBar(
                        textSize: 14.0,
                        message: 'Introduzca una cantidad de abono válida.',
                        mode: Mode.ADVANCE,
                        duration: Duration(seconds: 4),
                        icon: Icon(Icons.error),
                      ).show(context);
                      return;
                    }
                    if (widget.total < double.parse(abonoController.text)) {
                      const AdvanceSnackBar(
                        textSize: 14.0,
                        message:
                            'La cantidad abonada no debe ser mayor al total.',
                        mode: Mode.ADVANCE,
                        duration: Duration(seconds: 4),
                        icon: Icon(Icons.error),
                      ).show(context);
                    }
                    if (0.0 > double.parse(abonoController.text)) {
                      const AdvanceSnackBar(
                        textSize: 14.0,
                        message:
                            'La cantidad abonada no debe ser menor a cero.',
                        mode: Mode.ADVANCE,
                        duration: Duration(seconds: 4),
                        icon: Icon(Icons.error),
                      ).show(context);
                    }
                    bool liquidada = false;
                    if (widget.total == double.parse(abonoController.text)) {
                      liquidada = true;
                    }

                    var formatoFecha = DateFormat('dd/MM/yyyy');
                    var fechaStr = formatoFecha.format(DateTime.now());
                    await addPagoUsuario(
                            widget.total,
                            liquidada,
                            widget.direccionModel.nombre,
                            double.parse(abonoController.text),
                            widget.direccionModel.correo,
                            fechaStr,
                            "")
                        .then((value) async {
                      const AdvanceSnackBar(
                        textSize: 14.0,
                        bgColor: Colors.green,
                        message: 'Se ha realizado el pago con éxito',
                        mode: Mode.ADVANCE,
                        duration: Duration(seconds: 1),
                      ).show(context);

                      await Future.delayed(const Duration(seconds: 2));
                      Navigator.pop(context);
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
