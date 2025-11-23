import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:verifacts/core/ui/colors.dart';

Widget whiteLoader = const SpinKitCubeGrid(
  color: Colors.white,
  size: 18,
);

Widget primaryLoader = SpinKitCubeGrid(
  color: AppColors.primary,
  size: 18,
);
