import 'package:flutter/material.dart';
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentBy;
  const MessageTile({Key? key,required this.message,required this.isSentBy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isSentBy?Text(message,style: TextStyle(color: Colors.white),):Text(message,style: TextStyle(color: Colors.white),),
    );
  }
}
