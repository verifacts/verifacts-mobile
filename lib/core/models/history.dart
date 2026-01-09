import 'dart:convert';
import 'package:verifacts/core/models/analysis.dart';

class AnalysisHistory {
  final int? id;
  final String? text;
  final String? url;
  final Analysis analysis;
  final DateTime createdAt;

  const AnalysisHistory({
    this.id,
    this.text,
    this.url,
    required this.analysis,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'url': url,
      'analysis': jsonEncode(analysis.toJson()),
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory AnalysisHistory.fromMap(Map<String, dynamic> map) {
    return AnalysisHistory(
      id: map['id'] as int?,
      text: map['text'] as String?,
      url: map['url'] as String?,
      analysis: Analysis.fromJson(
        jsonDecode(map['analysis'] as String) as Map<String, dynamic>,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  String get displayTitle {
    if (text != null && text!.isNotEmpty) {
      return text!.length > 50 ? '${text!.substring(0, 50)}...' : text!;
    }
    if (url != null && url!.isNotEmpty) {
      return url!;
    }
    return 'Unknown query';
  }

  String get verdictEmoji {
    switch (analysis.verdict.overallVerdict.toLowerCase()) {
      case 'verified':
      case 'true':
        return '✓';
      case 'debunked':
      case 'false':
        return '✗';
      case 'mixed':
      case 'partially_true':
        return '◐';
      default:
        return '?';
    }
  }
}
