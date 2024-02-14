

import 'package:flutter/material.dart';

class ShimmerWidget extends StatelessWidget {

  final double width;
  final double height;

  ShimmerWidget.rectangular({
    this.width=double.infinity,
    required this.height,
});

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    color: Colors.grey,
  );
}
