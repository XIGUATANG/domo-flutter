import 'package:flutter/material.dart';

class LineButton extends StatelessWidget {
  LineButton({Key key, this.text, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: 48.0,
      height: 24.0,
      child: new GestureDetector(
          onTap: onPressed,
          child: new Container(
            width: 48.0,
            height: 24.0,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  text,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.red[300]),
                )
              ],
            ),
            decoration: new BoxDecoration(
              // color: Colors.red[300],
              border: Border.all(color: Colors.red[300]),
              borderRadius: new BorderRadius.all(
                const Radius.circular(2.0),
              ),
            ),
          )),
    );
  }
}
