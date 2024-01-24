
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class my_input extends StatelessWidget {
  var controler;
  String label;
  my_input({super.key,required this.controler,required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controler,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
      ),

    );
  }
}
class my_inputWithHint extends StatelessWidget {
  var controler;
  String hint;
  my_inputWithHint({super.key,required this.controler,required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controler,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: hint,
        border: InputBorder.none
      ),

    );
  }
}
