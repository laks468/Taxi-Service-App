import 'package:flutter/material.dart';

import '../brand_colors.dart';

class AvailabilityButton extends StatelessWidget {

  final String title;
  final Color color;
  final Function onPressed;

  const AvailabilityButton({this.title, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
      ),
      color: color,
      textColor: Colors.white,
      child: Container(
        height: 50,
        width: 200,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
          ),
        ),
      ),
    );
  }
}

