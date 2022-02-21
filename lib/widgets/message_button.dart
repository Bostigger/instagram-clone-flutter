import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageButton extends StatelessWidget {
  final Function()? onpressed;
  const MessageButton({Key? key, this.onpressed}) : super(key: key);

  get backgroundColor => null;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 3),
      child: TextButton(
        onPressed: onpressed,
        child: Container(
          width: 250,
          height: 27,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text("Message",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold ),),
        ),
      ),
    );
  }
}
