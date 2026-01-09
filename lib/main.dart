import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:share_handler/share_handler.dart';
import 'package:verifacts/core/network/configuration.dart';
import 'package:verifacts/core/utils/functions.dart';
import 'package:verifacts/pages/results.dart';
import 'package:verifacts/verifacts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeNetworkConfigurations();

  ShareHandlerPlatform handler = ShareHandlerPlatform.instance;
  SharedMedia? media = await handler.getInitialSharedMedia();

  handler.sharedMediaStream.listen((media) {
    Verifacts.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) {
          final (url, text) = handleIncomingMedia(media);
          return Results(url: url, text: text);
        },
      ),
    );
  });

  runApp(
    DevicePreview(
      enabled: false, // kDebugMode,
      builder: (_) {
        if (media != null) {
          final (url, text) = handleIncomingMedia(media);
          return Results(url: url, text: text);
        }

        return const Verifacts();
      },
    ),
  );
}

(String, String) handleIncomingMedia(SharedMedia? media) {
  String url = extractUrl(media?.content ?? "") ?? "";
  String text = removeUrl(media?.content ?? "");

  return (url, text);
}
