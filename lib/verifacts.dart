import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:verifacts/core/ui/themes.dart';
import 'package:verifacts/core/utils/responsive.dart';
import 'package:verifacts/pages/verify_fact.dart';

class Verifacts extends StatefulWidget {
  const Verifacts({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  State<Verifacts> createState() => _VerifactsState();
}

class _VerifactsState extends State<Verifacts> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Verifacts",
      navigatorKey: Verifacts.navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: themeData,
      builder: (context, child) {
        child = DevicePreview.appBuilder(context, child);
        return ResponsiveBreakpoints.builder(
          child: child,
          breakpoints: [
            const Breakpoint(
              start: 0,
              end: 374,
              name: AppBreakPoints.smallMobile,
            ),
            const Breakpoint(
              start: 375,
              end: 480,
              name: AppBreakPoints.normalMobile,
            ),
            const Breakpoint(
              start: 481,
              end: 767,
              name: AppBreakPoints.largeMobile,
            ),
            const Breakpoint(
              start: 768,
              end: 1023,
              name: AppBreakPoints.portraitTablet,
            ),
            const Breakpoint(
              start: 1024,
              end: double.infinity,
              name: AppBreakPoints.landscapeTablet,
            ),
          ],
        );
      },
      home: const VerifyFact(),
    );
  }
}
