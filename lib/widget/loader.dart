import 'package:flutter/material.dart';

class ContentLoading extends StatefulWidget{

  final double diameter;
  const ContentLoading({this.diameter=30,});

  @override
  State createState() {
    return _ContentLoadingState();
  }
}

class _ContentLoadingState extends State<ContentLoading> with SingleTickerProviderStateMixin{

  late AnimationController _cont;
  late Animation<Color?> _anim;

  @override
  void initState() {
    _cont=AnimationController(duration: const Duration(seconds: 1,),vsync: this);
    _cont.addListener(() {
      setState(() {
        //print("val: "+_cont.value.toString());
      });
    });
    ColorTween col=ColorTween(begin: Colors.blue,end:Colors.pink);
    _anim=col.animate(_cont);
    _cont.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _cont.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(width: widget.diameter,height: widget.diameter,
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(_anim.value,),)),
    );
  }
}