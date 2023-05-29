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
                    await addPagoUsuario(
                            widget.total,
                            liquidada,
                            widget.direccionModel.nombre,
                            double.parse(abonoController.text),
                            widget.direccionModel.correo)
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
          )
          /*RawAutocomplete<ProductoModel>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              return listaProductos.where((ProductoModel option) {
                return option.codigo
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            displayStringForOption: (option) {
              return option.codigo;
            },
            fieldViewBuilder: (
              BuildContext context,
              //TextEditingController textEditingController,
              codigoController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              return TextFormField(
                controller: codigoController,
                focusNode: focusNode,
                onFieldSubmitted: (String value) {
                  onFieldSubmitted();
                },
                decoration: const InputDecoration(
                    labelText: "Introduzca código de producto",
                    hintText: "Seleccione una opción",
                    icon: Icon(Icons.shopping_bag)),
                style: const TextStyle(
                  fontSize: 12,
                ),
              );
            },
            optionsViewBuilder: (
              BuildContext context,
              AutocompleteOnSelected<ProductoModel> onSelected,
              Iterable<ProductoModel> options,
            ) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  child: SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ProductoModel option = options.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            //print("seleccionado: ${option.codigo}");
                            onSelected(option);
                            codigoController.text = option.codigo;
                            precioController.text = option.precio;
                            tamTallaController.text = option.tamano;
                            setState(() {});
                          },
                          child: ListTile(
                            title: Text(option.codigo),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          TextFormField(
            controller: precioController,
            keyboardType: TextInputType.none,
            maxLength: 10,
            decoration: const InputDecoration(
                labelText: "Precio del producto",
                hintText: "Numérico",
                icon: Icon(
                  Icons.local_atm_rounded,
                )),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          TextFormField(
            controller: tamTallaController,
            keyboardType: TextInputType.text,
            maxLength: 10,
            decoration: const InputDecoration(
                labelText: "Introduzca tamaño/talla del producto",
                //hintText: "Number",
                icon: Icon(Icons.open_in_full_rounded)),
            style: const TextStyle(
              fontSize: 12,
            ),
            textCapitalization: TextCapitalization.characters,
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
                hintText: "Numérico",
                icon: Icon(Icons.numbers)),
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
                    return;
                  }
                  if (tamTallaController.text.isEmpty) {
                    const AdvanceSnackBar(
                      textSize: 14.0,
                      message: 'Introduzca un tamaño/talla válido.',
                      mode: Mode.ADVANCE,
                      duration: Duration(seconds: 5),
                      icon: Icon(Icons.error),
                    ).show(context);
                    return;
                  }
                  if (cantidadController.text.isEmpty) {
                    const AdvanceSnackBar(
                      textSize: 14.0,
                      message: 'Introduzca una cantidad válida.',
                      mode: Mode.ADVANCE,
                      duration: Duration(seconds: 5),
                      icon: Icon(Icons.error),
                    ).show(context);
                    return;
                  }
                  if (precioController.text.isEmpty) {
                    const AdvanceSnackBar(
                      textSize: 14.0,
                      message: 'Introduzca un precio válido.',
                      mode: Mode.ADVANCE,
                      duration: Duration(seconds: 5),
                      icon: Icon(Icons.error),
                    ).show(context);
                    return;
                  }

                  /*String? correo =
                      await FirebaseAuth.instance.currentUser?.email;*/
                  //print(correo.toString());
                  //Se agrega el producto a la base
                  //print("Codigo al agregar ${codigoController.text}");
                  if (codigoController.text.isEmpty) {
                    const AdvanceSnackBar(
                      textSize: 14.0,
                      bgColor: Colors.red,
                      message: 'Debe seleccionar un código de producto',
                      mode: Mode.ADVANCE,
                      duration: Duration(seconds: 2),
                    ).show(context);
                    return;
                  }

                  if (tamTallaController.text.isEmpty) {
                    const AdvanceSnackBar(
                      textSize: 14.0,
                      bgColor: Colors.red,
                      message: 'Debe introducir un tamaño/talla válido',
                      mode: Mode.ADVANCE,
                      duration: Duration(seconds: 2),
                    ).show(context);
                    return;
                  }

                  if (cantidadController.text.isEmpty) {
                    const AdvanceSnackBar(
                      textSize: 14.0,
                      bgColor: Colors.red,
                      message: 'Debe introducir una cantidad válida',
                      mode: Mode.ADVANCE,
                      duration: Duration(seconds: 2),
                    ).show(context);
                    return;
                  }

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
                  await Future.delayed(const Duration(seconds: 2));
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PdfScreen(
                                marca: widget.marca,
                                path: widget.path,
                              )));
                },
              ),
            ),
          )*/
          ,
        ],
      ),
    );
  }
}
