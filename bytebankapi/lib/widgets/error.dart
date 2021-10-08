import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView(this._message);

  final String _message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(_message),
    );
  }
}
