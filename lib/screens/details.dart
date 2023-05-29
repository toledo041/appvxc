import 'package:advance_notification/advance_notification.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fashion_ecommerce_app/model/base_model.dart';
import 'package:fashion_ecommerce_app/utils/constants.dart';
import 'package:fashion_ecommerce_app/widget/add_to_cart.dart';
import 'package:fashion_ecommerce_app/widget/reuseable_text.dart';
import 'package:fashion_ecommerce_app/widget/reuseable_button.dart';

class Details extends StatefulWidget {
  const Details({
    required this.data,
    super.key,
    required this.isCameFromMostPopularPart,
  });

  final BaseModel data;
  final bool isCameFromMostPopularPart;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int selectedSize = 3;
  int selectedColor = 0;
  String usuario = "";
  final cantidadController = TextEditingController();

  @override
  void initState() {
    super.initState();

    () async {
      await getUsuario();
      setState(() {});
    }();
  }

  Future getUsuario() async {
    String? correo = await FirebaseAuth.instance.currentUser?.email;
    usuario = await getNombreUsuario(correo.toString());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;

    BaseModel current = widget.data;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: SizedBox(
        width: size.width,
        height: size.height * .9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Top Image
            SizedBox(
              width: size.width,
              height: size.height * 0.4,
              child: Stack(
                children: [
                  Hero(
                    tag: widget.isCameFromMostPopularPart
                        ? current.imageUrl
                        : current.id,
                    child: Container(
                      width: size.width,
                      height: size.height * 0.4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(current.imageUrl),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: size.width,
                      height: size.height * 0.10,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: gradient),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// info
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            current.name,
                            style:
                                textTheme.headlineSmall?.copyWith(fontSize: 20),
                          ),
                          ReuseableText(
                            price: current.price,
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.006,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Select size
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 18.0, bottom: 10.0),
                child: Text(
                  "Seleccionar Talla ",
                  style: textTheme.headlineSmall,
                ),
              ),
            ),

            ///Sizes
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: SizedBox(
                // color: Colors.red,
                width: size.width * 0.9,
                height: size.height * 0.08,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: sizes.length,
                    itemBuilder: (ctx, index) {
                      var current = sizes[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSize = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AnimatedContainer(
                            width: size.width * 0.12,
                            decoration: BoxDecoration(
                              color: selectedSize == index
                                  ? primaryColor
                                  : Colors.transparent,
                              border: Border.all(color: primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            duration: const Duration(milliseconds: 200),
                            child: Center(
                              child: Text(
                                current,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: selectedSize == index
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 18.0, bottom: 10.0),
                child: Text(
                  "Seleccionar Cantidad ",
                  style: textTheme.headlineSmall,
                ),
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
                  //labelText: "",
                  hintText: "Cantidad de producto",
                  icon: Icon(Icons.numbers)),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            /// Add To Cart Button
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.03),
                child: ReuseableButton(
                  text: "Añadir al carrito",
                  onTap: () async {
                    //Se valida la
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

                    String? correo =
                        await FirebaseAuth.instance.currentUser?.email;

                    await addCarritoUsuario(
                        widget.data.codigo,
                        sizes[selectedSize],
                        int.parse(cantidadController.text),
                        widget.data.price,
                        correo.toString(),
                        widget.data.marca,
                        usuario);
                    AddToCart.addToCart(current, context);

                    await Future.delayed(const Duration(seconds: 2));
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
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
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.favorite_border,
            color: Colors.white,
          ),
        ),
      ],
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
