import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  const Progress({
    Key? key,
    this.message = 'Loading',
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}

class ProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Processing'),
      ),
      body: Progress(
        message: 'Sending...',
      ),
    );
  }
}
