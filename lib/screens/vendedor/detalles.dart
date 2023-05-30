import 'package:fashion_ecommerce_app/model/vededor_model.dart';
import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:fashion_ecommerce_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/agenda.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/liquidados_page.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/pago_dialog.dart';
import 'package:fashion_ecommerce_app/model/direccion_model.dart';
import 'package:toast/toast.dart';

enum SampleItem { deudores, liquidados, agenda }

class DetalleVenta extends StatefulWidget {
  final VendedorModel modeloVendedor;
  final VoidCallback onReturn;
  const DetalleVenta(
      {super.key, required this.modeloVendedor, required this.onReturn});
  @override
  State<DetalleVenta> createState() => _DetalleVentaState();
}

class _DetalleVentaState extends State<DetalleVenta> {
  SampleItem? selectedMenu;
  double faltaPago = 0.0;
  double restantePago = 0.0;
  List<ProductoModel> listaClasificada = [];
  DireccionModel direccionUsuario = DireccionModel();

  @override
  void initState() {
    super.initState();
    () async {
      String? correo = await FirebaseAuth.instance.currentUser?.email;
      await getPagoUsuario(correo.toString());
      await getDomicilioUsuario();
      clasificarCarrito();
      setState(() {
        // Update your UI with the desired changes.
      });
    }();
  }

  clasificarCarrito() {
    for (var marca in widget.modeloVendedor.listaMarcas) {
      //print("marca ${marca}");
      int cont = 0;
      for (var producto in widget.modeloVendedor.carrito) {
        //print("Producto: ${producto}");
        if (marca == producto["marca"]) {
          final prod = ProductoModel(
              marca: marca,
              codigo: producto["codigo"],
              precio: producto["precio"].toString(),
              cantidad: producto["cantidad"].toString(),
              tamano: producto["tamano"],
              mostrarMarca: cont == 0 ? true : false);
          listaClasificada.add(prod);
          cont++;
        }
      }
    }
  }

  Future getDomicilioUsuario() async {
    String correoUsr = widget.modeloVendedor.correo;
    //String nombre = await getNombreUsuario(correoUsr.toString());
    List direccion = await getDireccionUsuario(correoUsr);
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
          nombre: widget.modeloVendedor.nombre,
          correo: correoUsr.toString());
      direccionUsuario = modelo;
    }
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    ToastContext().init(context);

    return Scaffold(
      appBar: _getAppBar(context),
      body: Column(children: [
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                    child: Text(widget.modeloVendedor.nombre
                        .substring(0, 1)
                        .toUpperCase())),
                title: Text(widget.modeloVendedor.nombre),
                subtitle: Text('compro en: ${widget.modeloVendedor.marcas}'),
                trailing: Text(
                  "\u0024 ${widget.modeloVendedor.porPagar}",
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Enviar a",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.black87,
                                //fontSize: 18
                              )),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                        "Calle ${direccionUsuario.calle} #${direccionUsuario.numeroExt}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                        " ${direccionUsuario.estado}, ${direccionUsuario.municipio}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.grey, fontSize: 16)),
                    Text(
                        " ${direccionUsuario.nombre}  tel. ${direccionUsuario.telefono}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.grey, fontSize: 16))
                  ],
                ),
              ),
            ],
          ),
        ),
        //PRODUCTOS
        SizedBox(
          width: size.width,
          height: size.height * 0.44,
          child: listaClasificada.isEmpty

              /// List is Empty:
              ? const Column()

              /// List is Not Empty:
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: listaClasificada.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var current = listaClasificada[index];
                    return Container(
                      //color: (index % 2 == 1) ? Colors.white70 : Colors.white,
                      //margin: const EdgeInsets.all(5.0),
                      width: size.width,
                      height: current.mostrarMarca
                          ? size.height * 0.06
                          : size.height * 0.04,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                current.mostrarMarca
                                    ? Text(
                                        "Marca:  ${current.marca}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : const Column(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Código:  ${current.codigo}",
                                        style: textTheme.titleMedium?.copyWith(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "  Cantidad: ${current.cantidad} ",
                                        style: textTheme.titleMedium?.copyWith(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        " Talla/Tamaño:  ${current.tamano}",
                                        style: textTheme.titleMedium?.copyWith(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
        ),
        //FIN PRODUCTOS
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Balance",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black45),
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Text("Abono"), Text("Deuda")],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "\u0024 ${widget.modeloVendedor.abono}",
              style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Text(
              "\u0024 ${widget.modeloVendedor.porPagar}",
              style: const TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            )
          ],
        )
      ]),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        FilledButton(
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Confirmación",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "¿Está seguro de enviar estos productos?",
                            ),
                          ),
                        ),
                        Center(
                          child: Row(
                            children: [
                              const Text("                      "),
                              FilledButton(
                                child: const Text("Cancelar"),
                                onPressed: () {
                                  /*showToast("Introduzca una monto válido.",
                                          duration: 2);*/
                                  /*Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetalleVenta(
                                                modeloVendedor:
                                                    widget.modeloVendedor,
                                                onReturn: () {},
                                              )));*/
                                  Navigator.pop(context);
                                },
                              ),
                              FilledButton(
                                child: const Text("Aceptar"),
                                onPressed: () async {
                                  /*showToast(
                                      "Los productos fueron enviados con éxito.",
                                      duration: 2);
                                  await Future.delayed(
                                          const Duration(seconds: 2))
                                      .then((value) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetalleVenta(
                                                  modeloVendedor:
                                                      widget.modeloVendedor,
                                                  onReturn: () {},
                                                )));
                                  });*/
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }).then((value) {
              setState(() {
                widget.onReturn();
              });
            });
          },
          child: const Text('Enviar producto'),
        ),
        FilledButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PagoDialog(
                      titulo: "Realizar abono",
                      vendedorModel: widget.modeloVendedor,
                    );
                  }).then((value) {
                setState(() {
                  widget.onReturn();
                });
              });
            },
            child: const Text('Abonar')),
      ],
    );
  }

  //Se construye el appbar de la aplicacción
  AppBar _getAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Detalles"),
      actions: [getMenuItemBar(context, selectedMenu)],
    );
  }

  PopupMenuButton getMenuItemBar(
      BuildContext context, SampleItem? selectedMenu) {
    return PopupMenuButton<SampleItem>(
      initialValue: selectedMenu,
      // Callback that sets the selected popup menu item.
      onSelected: (SampleItem item) {
        setState(() {
          selectedMenu = item;
          if (selectedMenu != null) {
            print(selectedMenu?.index);
            if (selectedMenu?.index == 0) {
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DetalleVenta()),
              );*/
            } else if (selectedMenu?.index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LiquidadosPage()),
              );
            } else {
              //print("Pendiente calendario?");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AgendaPage(
                          title: "Agenda",
                        )),
              );
            }
          }
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          value: SampleItem.deudores,
          child: Text('Deudores'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.liquidados,
          child: Text('Liquidados'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.agenda,
          child: Text('Agenda'),
        ),
      ],
    );
  }
}
