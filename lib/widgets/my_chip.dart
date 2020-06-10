import 'package:flutter/material.dart';

class MyChip extends StatelessWidget {
  final String labelText;
  final Color textColor, backgroundColor;
  MyChip({Key key, this.labelText, this.textColor, this.backgroundColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      label: FittedBox(child: Text(labelText)),
      labelStyle: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
    );
  }
}
