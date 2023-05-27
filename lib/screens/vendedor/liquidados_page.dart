import 'package:flutter/material.dart';

enum SampleItem { deudores, liquidados, otros }

class LiquidadosPage extends StatefulWidget {
  const LiquidadosPage({super.key});

  @override
  State<LiquidadosPage> createState() => _LiquidadosPageState();
}

class _LiquidadosPageState extends State<LiquidadosPage> {
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
        child: Expanded(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: const CircleAvatar(child: Text('D')),
                title: const Text('Dalia Torres'),
                subtitle: const Text('Realizó el pago en tiempo.'),
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
              ListTile(
                leading: const CircleAvatar(child: Text('K')),
                title: const Text('Karen Gomez'),
                subtitle: const Text('Realizó el pago en tiempo.'),
                trailing: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                onTap: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetalleVenta()),
                  );*/
                },
              ),
              const Divider(height: 0),
            ],
          ),
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: ,
        tooltip: 'Agregar',
        child: const Icon(Icons.add),
      ),*/
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
