import 'package:flutter/material.dart';

import 'loader.dart';

class LoadingOverlay extends StatefulWidget {
  final bool loading;
  final Widget child;

  const LoadingOverlay({super.key, required this.loading, required this.child});

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(child: primaryLoader),
        ),
      );
    }

    return widget.child;
  }
}
