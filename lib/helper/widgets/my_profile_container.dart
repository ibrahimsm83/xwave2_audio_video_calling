
import 'package:flutter/cupertino.dart';

class my_profile_container extends StatelessWidget {
  String img;
  double width,height;
  my_profile_container({super.key,required this.img,this.width=52,this.height=52});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,height: height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,

          image: DecorationImage(image: NetworkImage(img),fit: BoxFit.cover)
      ),

    );
  }

}