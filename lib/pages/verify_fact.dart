import 'package:flutter/material.dart';
import 'package:share_handler/share_handler.dart';
import 'package:verifacts/core/ui/ui.dart';

class VerifyFact extends StatefulWidget {
  const VerifyFact({super.key});

  @override
  State<VerifyFact> createState() => _VerifyFactState();
}

class _VerifyFactState extends State<VerifyFact> {
  final TextEditingController controller = TextEditingController();

  SharedMedia? media;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    ShareHandlerPlatform handler = ShareHandlerPlatform.instance;
    media = await handler.getInitialSharedMedia();

    handler.sharedMediaStream.listen((media) {
      if (!mounted) return;
      this.media = media;
      setState(() {});
    });

    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Paddings.hLg(context),
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
