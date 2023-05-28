// Define un widget de formulario personalizado
import 'package:advance_notification/advance_notification.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fashion_ecommerce_app/model/base_model.dart';
import 'package:fashion_ecommerce_app/model/vededor_model.dart';
import 'package:fashion_ecommerce_app/screens/cart.dart';
import 'package:fashion_ecommerce_app/screens/pdf_screen.dart';
import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:fashion_ecommerce_app/widget/add_to_cart.dart';
import 'package:fashion_ecommerce_app/widget/reuseable_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///Forma con la información de captura que se usara para capturar los productos
class CapturaProductsForm extends StatefulWidget {
  final String marca;
  final String path;
  const CapturaProductsForm(
      {super.key, required this.marca, required this.path});
  @override
  State<CapturaProductsForm> createState() => CapturaProductsFormState();
}

// Define una clase de estado correspondiente. Esta clase contendrá los datos
// relacionados con el formulario.
class CapturaProductsFormState extends State<CapturaProductsForm> {
  final _formKey = GlobalKey<FormState>();

  final String? correo = FirebaseAuth.instance.currentUser?.email;
  String name = "";
  List<ProductoModel> listaProductos = [];

  final codigoController = TextEditingController();
  final tamTallaController = TextEditingController();
  final cantidadController = TextEditingController();
  final precioController = TextEditingController();
  String marcaCatalogo = "";

  //static String _displayStringForOption(ProductoModel option) => option.codigo;

  @override
  void initState() {
    super.initState();

    () async {
      await getCatalogo();
      setState(() {
        // Update your UI with the desired changes.
      });
    }();
  }

  Future getCatalogo() async {
    String? correo = await FirebaseAuth.instance.currentUser?.email;
    name = await getNombreUsuario(correo.toString());

    //arreglo para defirnir la marca en el catelogo de productos
    switch (widget.marca) {
      case "Avon":
        marcaCatalogo = "avon";
        break;
      case "Betterware":
        marcaCatalogo = "betterware";
        break;
      case "Jafra":
        marcaCatalogo = "jafra";
        break;
      case "MaryKay":
        marcaCatalogo = "marykay";
        break;
      case "Sheló":
        marcaCatalogo = "shelo";
        break;
      case "Andrea":
        marcaCatalogo = "andrea";
        break;
      case "Concord":
        marcaCatalogo = "concord";
        break;
      default:
    }

    listaProductos = await getCatalogoProductos(marcaCatalogo);
  }

  @override
  Widget build(BuildContext context) {
    // Cree un widget Form usando el _formKey que creamos anteriormente
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          RawAutocomplete<ProductoModel>(
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
                            print("seleccionado: ${option.codigo}");
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
          ),
        ],
      ),
    );
  }
}
