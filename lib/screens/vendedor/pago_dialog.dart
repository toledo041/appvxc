import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fashion_ecommerce_app/model/vededor_model.dart';

class PagoDialog extends Dialog {
  final VendedorModel vendedorModel;
  const PagoDialog(
      {super.key, required this.titulo, required this.vendedorModel});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    //final String? correo = FirebaseAuth.instance.currentUser?.email;
    final TextEditingController fechaController = TextEditingController();
    final TextEditingController montoController = TextEditingController();
    final TextEditingController notasController = TextEditingController();

    return StatefulBuilder(builder: (context, setState) {
      return Dialog(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          titulo,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: fechaController,
                        decoration: const InputDecoration(
                          labelText: 'Fecha',
                          icon: Icon(Icons.calendar_month),
                        ),
                        onTap: () async {
                          // Below line stops keyboard from appearing
                          DateTime? date = DateTime(1900);
                          FocusScope.of(context).requestFocus(new FocusNode());
                          date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                            onDatePickerModeChange: (value) {
                              print(value);
                              fechaController.text = value.toString();
                            },
                            //locale: const Locale('es')
                          );

                          if (date == null) date = DateTime.now();

                          var outputFormat = DateFormat('dd/MM/yyyy');
                          var outputDate = outputFormat.format(date);
                          fechaController.text = outputDate;
                          print(outputDate);

                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: montoController,
                        decoration: const InputDecoration(
                          labelText: 'Monto',
                          icon: Icon(Icons.account_balance),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: notasController,
                        decoration: const InputDecoration(
                          labelText: 'Nota',
                          icon: Icon(Icons.description),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton(
                        child: const Text("Aceptar"),
                        onPressed: () {
                          print(fechaController.text);
                          print(montoController.text);
                          print(notasController.text);

                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ]),
      );
    });
  }
}
