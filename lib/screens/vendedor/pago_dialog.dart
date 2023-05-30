import 'package:advance_notification/advance_notification.dart';
import 'package:fashion_ecommerce_app/services/firebase_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fashion_ecommerce_app/model/vededor_model.dart';
import 'package:toast/toast.dart';

class PagoDialog extends Dialog {
  final VendedorModel vendedorModel;
  const PagoDialog(
      {super.key, required this.titulo, required this.vendedorModel});

  final String titulo;
  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
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
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                          signed: false,
                        ),
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
                        onPressed: () async {
                          print(fechaController.text);
                          print(montoController.text);
                          print(notasController.text);
                          print(vendedorModel.uid);
                          if (fechaController.text.isEmpty) {
                            showToast("Introduzca una fecha.", duration: 2);

                            return;
                          }
                          if (montoController.text.isEmpty) {
                            showToast("Introduzca una monto válido.",
                                duration: 2);

                            return;
                          }
                          if (vendedorModel.deuda <
                              (double.parse(montoController.text) +
                                  vendedorModel.abono)) {
                            showToast(
                                "La cantidad abonada no debe ser mayor a la deuda.",
                                duration: 2);
                            return;
                          }
                          if (0.0 > double.parse(montoController.text)) {
                            showToast(
                                "La cantidad abonada no debe ser menor a cero.",
                                duration: 2);
                            return;
                          }
                          bool liquidada = false;
                          //Si lo ya abonado mas el abono actual es igual a la deuda esta liquidada
                          if (vendedorModel.deuda ==
                              (double.parse(montoController.text) +
                                  vendedorModel.abono)) {
                            liquidada = true;
                          }
                          vendedorModel.abono = vendedorModel.abono +
                              double.parse(montoController.text);
                          vendedorModel.porPagar = double.parse(
                              (vendedorModel.deuda - vendedorModel.abono)
                                  .toStringAsFixed(2));
                          vendedorModel.liquidada = liquidada;
                          print("nota ${notasController.text}");
                          print(
                              "deuda: ${vendedorModel.deuda} abono ant: ${vendedorModel.abono} abono act: ${montoController.text} liquidada: ${liquidada}");
                          await updatePago(
                                  vendedorModel.uid,
                                  double.parse(montoController.text),
                                  fechaController.text,
                                  liquidada,
                                  notasController.text.isEmpty
                                      ? ""
                                      : notasController.text)
                              .then((value) {
                            Navigator.of(context).pop();
                          });
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
