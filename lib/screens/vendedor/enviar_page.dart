import 'package:fashion_ecommerce_app/model/vededor_model.dart';
import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/agenda.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/liquidados_page.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/pago_dialog.dart';

enum SampleItem { deudores, liquidados, agenda }

class EnviarCarritoPage extends StatefulWidget {
  final VendedorModel modeloVendedor;

  const EnviarCarritoPage({super.key, required this.modeloVendedor});
  @override
  State<EnviarCarritoPage> createState() => _EnviarCarritoPageState();
}

class _EnviarCarritoPageState extends State<EnviarCarritoPage> {
  SampleItem? selectedMenu;
  double faltaPago = 0.0;
  double restantePago = 0.0;

  @override
  void initState() {
    super.initState();
    () async {
      String? correo = await FirebaseAuth.instance.currentUser?.email;
      await getPagoUsuario(correo.toString());
      await calcularDeuda();
      setState(() {
        // Update your UI with the desired changes.
      });
    }();
  }

  Future calcularDeuda() async {}

  @override
  Widget build(BuildContext context) {
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
                  return PagoDialog(
                    titulo: "Nuevo pago",
                    vendedorModel: widget.modeloVendedor,
                  );
                }).then((value) {
              setState(() {});
            });
          },
          child: const Text('Fecha pago'),
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
                setState(() {});
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
