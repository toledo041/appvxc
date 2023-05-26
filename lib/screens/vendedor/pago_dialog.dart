import 'package:flutter/material.dart';

class PagoDialog extends Dialog {
  const PagoDialog({super.key, required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Dialog(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        titulo,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Monto',
                        icon: Icon(Icons.account_balance),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
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
                        /*if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                        }*/
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
            ),
          ]),
    );
  }
}
