import 'package:flutter/material.dart';

class Results extends StatefulWidget {
  final String? text;
  final String? url;

  const Results({super.key, this.text, this.url});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
