class Analysis {
  final String status;
  final SourceIdentity sourceIdentity;
  final List<Claim> claims;
  final Verdict verdict;
  final List<SearchInsight> searchInsights;

  const Analysis({
    required this.status,
    required this.sourceIdentity,
    required this.claims,
    required this.verdict,
    required this.searchInsights,
  });

  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      status: json['status'] as String? ?? '',
      sourceIdentity: SourceIdentity.fromJson(
        json['source_identity'] as Map<String, dynamic>? ?? {},
      ),
      claims:
          (json['claims'] as List<dynamic>?)
              ?.map((e) => Claim.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      verdict: Verdict.fromJson(json['verdict'] as Map<String, dynamic>? ?? {}),
      searchInsights:
          (json['search_insights'] as List<dynamic>?)
              ?.map((e) => SearchInsight.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'source_identity': sourceIdentity.toJson(),
      'claims': claims.map((e) => e.toJson()).toList(),
      'verdict': verdict.toJson(),
      'search_insights': searchInsights.map((e) => e.toJson()).toList(),
    };
  }
}

class SourceIdentity {
  final String trustLevel;
  final double score;
  final List<String> redFlags;
  final String summary;

  const SourceIdentity({
    required this.trustLevel,
    required this.score,
    required this.redFlags,
    required this.summary,
  });

  factory SourceIdentity.fromJson(Map<String, dynamic> json) {
    return SourceIdentity(
      trustLevel: json['trust_level'] as String? ?? '',
      score: json['score'] as double? ?? 0.0,
      redFlags:
          (json['red_flags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      summary: json['summary'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trust_level': trustLevel,
      'score': score,
      'red_flags': redFlags,
      'summary': summary,
    };
  }
}

class Claim {
  final String claim;
  final String verdict;
  final double confidence;
  final String explanation;
  final List<String> sources;

  const Claim({
    required this.claim,
    required this.verdict,
    required this.confidence,
    required this.explanation,
    required this.sources,
  });

  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      claim: json['claim'] as String? ?? '',
      verdict: json['verdict'] as String? ?? '',
      confidence: json['confidence'] as double? ?? 0,
      explanation: json['explanation'] as String? ?? '',
      sources:
          (json['sources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'claim': claim,
      'verdict': verdict,
      'confidence': confidence,
      'explanation': explanation,
      'sources': sources,
    };
  }
}

class Verdict {
  final String overallVerdict;
  final String summary;
  final int totalClaims;
  final int verifiedCount;
  final int debunkedCount;
  final List<String> sources;

  const Verdict({
    required this.overallVerdict,
    required this.summary,
    required this.totalClaims,
    required this.verifiedCount,
    required this.debunkedCount,
    required this.sources,
  });

  factory Verdict.fromJson(Map<String, dynamic> json) {
    return Verdict(
      overallVerdict: json['overall_verdict'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      totalClaims: json['total_claims'] as int? ?? 0,
      verifiedCount: json['verified_count'] as int? ?? 0,
      debunkedCount: json['debunked_count'] as int? ?? 0,
      sources:
          (json['sources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall_verdict': overallVerdict,
      'summary': summary,
      'total_claims': totalClaims,
      'verified_count': verifiedCount,
      'debunked_count': debunkedCount,
      'sources': sources,
    };
  }
}

class SearchInsight {
  final String claim;
  final String status;
  final InsightDetails insights;

  const SearchInsight({
    required this.claim,
    required this.status,
    required this.insights,
  });

  factory SearchInsight.fromJson(Map<String, dynamic> json) {
    return SearchInsight(
      claim: json['claim'] as String? ?? '',
      status: json['status'] as String? ?? '',
      insights: InsightDetails.fromJson(
        json['insights'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'claim': claim, 'status': status, 'insights': insights.toJson()};
  }
}

class InsightDetails {
  final String llmSummary;
  final double confidence;
  final String verdict;
  final List<KeySource> keySources;
  final String notes;

  const InsightDetails({
    required this.llmSummary,
    required this.confidence,
    required this.verdict,
    required this.keySources,
    required this.notes,
  });

  factory InsightDetails.fromJson(Map<String, dynamic> json) {
    return InsightDetails(
      llmSummary: json['llm_summary'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      verdict: json['verdict'] as String? ?? '',
      keySources:
          (json['key_sources'] as List<dynamic>?)
              ?.map((e) => KeySource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'llm_summary': llmSummary,
      'confidence': confidence,
      'verdict': verdict,
      'key_sources': keySources.map((e) => e.toJson()).toList(),
      'notes': notes,
    };
  }
}

class KeySource {
  final String title;
  final String url;

  const KeySource({required this.title, required this.url});

  factory KeySource.fromJson(Map<String, dynamic> json) {
    return KeySource(
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'url': url};
  }
}
