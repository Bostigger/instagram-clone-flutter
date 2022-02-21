import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



showSnack(String message, BuildContext context) {
  ScaffoldMessenger
      .of(context)
      .showSnackBar(
      SnackBar(content: Text(message)));
      }