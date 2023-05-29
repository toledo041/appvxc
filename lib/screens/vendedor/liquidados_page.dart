import 'package:animate_do/animate_do.dart';
import 'package:fashion_ecommerce_app/model/vededor_model.dart';
import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:flutter/material.dart';

enum SampleItem { deudores, liquidados, otros }

class LiquidadosPage extends StatefulWidget {
  const LiquidadosPage({super.key});

  @override
  State<LiquidadosPage> createState() => _LiquidadosPageState();
}

class _LiquidadosPageState extends State<LiquidadosPage> {
  List<PagoModel> listaPagos = [];

  @override
  void initState() {
    () async {
      await getPagos();

      setState(() {
        // Update your UI with the desired changes.
      });
    }();
    super.initState();
  }

  Future getPagos() async {
    List<PagoModel> listaTmp = [];
    listaTmp = await getPagosUsuarios();
    for (var pago in listaTmp) {
      print("pago ${pago.liquidada}");
      if (pago.liquidada) {
        listaPagos.add(pago);
      }
    }
    print("lista pagos ${listaPagos}");
  }

  @override
  Widget build(BuildContext context) {
    SampleItem? selectedMenu;
    return Scaffold(
      appBar: AppBar(
        title: Text("Liquidados"),
        actions: [
          getMenuItemBar(context, selectedMenu),
        ],
      ),
      body: Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: listaPagos.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: listaPagos.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var current = listaPagos[index];
                      //Si no ha comprado nada no, muestre el usuario
                      return FadeInUp(
                        delay: Duration(milliseconds: 100 * index + 80),
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width,
                          //height: MediaQuery.of(context).size.height * 0.10,
                          //color: colorGrey7, // [index % 2]? col,
                          child: Column(
                            children: [
                              ListTile(
                                leading: const CircleAvatar(child: Text('D')),
                                title: Text(current.nombre),
                                subtitle: const Text('Finalizó su deuda.'),
                                trailing: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onTap: () {
                                  /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const DetalleVenta()),
                                        );*/
                                },
                              ),
                              const Divider(height: 1),
                            ],
                          ),
                        ),
                      );
                    })),
      ),
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
              print("Liquidados!!");
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DetalleVenta()),
              );*/
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
          value: SampleItem.otros,
          child: Text('Otros'),
        ),
      ],
    );
  }
}
