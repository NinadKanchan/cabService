import 'package:flutter/material.dart';
import 'constants.dart';

class EntryBox extends StatefulWidget {
  @override
  final TextInputType inputType;
  String valueName;
  final String placeHolder;
  final String title;
  EntryBox({
    this.inputType,
    this.valueName,
    this.placeHolder,
    this.title});

  @override
  _EntryBoxState createState() => _EntryBoxState();
}

class _EntryBoxState extends State<EntryBox> {
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 85,
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: TextField(
              keyboardType: widget.inputType,
              obscureText: widget.title == 'Password:' ? true : false,
              textAlign: TextAlign.center,
              onChanged: (value) {
                setState(() {
                  widget.valueName = value;
                  print(value);
                  print(widget.valueName);
                });
                //Do something with the user input.

              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: widget.placeHolder,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
