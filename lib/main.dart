import 'package:flutter/material.dart';
import 'package:share_handler/share_handler.dart';
import 'package:verifacts/core/network/configuration.dart';
import 'package:verifacts/verifacts.dart';

SharedMedia? media;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeNetworkConfigurations();

  ShareHandlerPlatform handler = ShareHandlerPlatform.instance;
  media = await handler.getInitialSharedMedia();

  runApp(const Verifacts());
}
