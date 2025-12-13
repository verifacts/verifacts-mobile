import 'package:verifacts/core/models/analysis.dart';
import 'package:verifacts/core/network/configuration.dart';

class AnalysisService {
  static Future<Analysis?> analyze({String? url, String? selection}) async {
    try {
      Map<String, dynamic> payload = {
        if (url != null) "url": url,
        if (selection != null) "selection": selection,
        "force_selection": false,
      };

      Response response = await dio.post("/api/v1/analyze", data: payload);
      return Analysis.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
