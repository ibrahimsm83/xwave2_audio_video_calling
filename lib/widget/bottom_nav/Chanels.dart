import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chanels extends StatefulWidget {
  const Chanels({super.key});

  @override
  State<Chanels> createState() => _ChanelsState();
}

class _ChanelsState extends State<Chanels> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Channel"),),
    );
  }
}
