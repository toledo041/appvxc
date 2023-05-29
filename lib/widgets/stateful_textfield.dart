import 'package:flutter/material.dart';

class StatefulTextfield extends StatefulWidget {
  final TextEditingController myController;
  final String? hintText;
  final bool? isMultiline;
  final ValueSetter<String> onCambioItem;
  const StatefulTextfield(
      {Key? key,
      required this.myController,
      this.hintText,
      this.isMultiline,
      required this.onCambioItem})
      : super(key: key);

  @override
  State<StatefulTextfield> createState() => _StatefulTextfieldState();
}

class _StatefulTextfieldState extends State<StatefulTextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: false,
        ),
        controller: widget.myController,
        /*decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1),
              borderRadius: BorderRadius.circular(10)),
          fillColor: const Color(0xffE8ECF4),
          filled: true,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),*/
        onChanged: (value) {
          widget.onCambioItem(value);
        },
      ),
    );
  }
}
