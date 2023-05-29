import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<String> listaOpciones;
  final ValueSetter<String> onCambioItem;
  const CustomDropdownButton(
      {super.key, required this.listaOpciones, required this.onCambioItem});

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String dropdownValue = "";

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.listaOpciones.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.black87, fontSize: 18),
      underline: Container(
        height: 2,
        width: MediaQuery.of(context).size.width * 0.8,
        color: Colors.blue,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          widget.onCambioItem(dropdownValue);
        });
      },
      items: widget.listaOpciones.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
