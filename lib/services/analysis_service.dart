import 'dart:developer';

import 'package:verifacts/core/models/analysis.dart';
import 'package:verifacts/core/network/configuration.dart';

class AnalysisService {
  static Future<(Analysis?, String?)> analyze({String? url, String? selection}) async {
    String? error;

    try {
      Map<String, dynamic> payload = {
        if (url != null) "url": url,
        if (selection != null) "selection": selection,
        "force_selection": false,
      };

      Response response = await dio.post("/api/v1/analyze", data: payload);
      return (Analysis.fromJson(response.data), error);
    } on DioException catch(e) {
      error = determineDioError(e);
    } catch (e) {
      error = e.toString();
    }

    return (null, error);
  }
}
