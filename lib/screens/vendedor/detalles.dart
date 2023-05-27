import 'package:fashion_ecommerce_app/model/vededor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/agenda.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/liquidados_page.dart';
//import 'package:fashion_ecommerce_app/screens/vendedor/vendedor_page.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/pago_dialog.dart';

enum SampleItem { deudores, liquidados, agenda }

class DetalleVenta extends StatefulWidget {
  final VendedorModel modeloVendedor;
  const DetalleVenta({super.key, required this.modeloVendedor});
  @override
  State<DetalleVenta> createState() => _DetalleVentaState();
}

class _DetalleVentaState extends State<DetalleVenta> {
  SampleItem? selectedMenu;
  double faltaPago = 0.0;
  double restantePago = 0.0;

  @override
  void initState() {
    super.initState();
    () async {
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
                  "\u0024 ${widget.modeloVendedor.deuda}",
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DetalleVenta()),
                    );*/
                },
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
          children: [Text("Restante"), Text("Deuda")],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "\u0024 2038.00",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Text(
              "\u0024 2038.00",
              style: TextStyle(
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
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PagoDialog(
                    titulo: "Nuevo pago",
                    vendedorModel: widget.modeloVendedor,
                  );
                });
          },
          child: const Text('Pago'),
        ),
        FilledButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PagoDialog(
                      titulo: "Aumento de deuda",
                      vendedorModel: widget.modeloVendedor,
                    );
                  });
            },
            child: const Text('Aumento')),
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
              print("Pendiente calendario?");
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
