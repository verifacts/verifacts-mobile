import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:verifacts/core/models/analysis.dart';
import 'package:verifacts/core/ui/ui.dart';
import 'package:verifacts/pages/widgets/results_widgets.dart';
import 'package:verifacts/services/analysis_service.dart';

class Results extends StatefulWidget {
  final String? text;
  final String? url;

  const Results({super.key, this.text, this.url});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  bool loading = true;
  Analysis? analysis;

  Analysis mockAnalysis = Analysis(
    status: 'success',
    sourceIdentity: SourceIdentity(
      trustLevel: 'high',
      score: 92,
      redFlags: ['uses_mixed_content'],
      summary: 'This is a placeholder summary for the skeleton loader.',
    ),
    claims: List.generate(
      2,
      (index) => Claim(
        claim: 'This is a placeholder claim for skeleton loading',
        verdict: 'verified',
        confidence: 100,
        explanation:
            'This is a placeholder explanation for the skeleton loader.',
        sources: ['https://example.com'],
      ),
    ),
    verdict: Verdict(
      overallVerdict: 'verified',
      summary: 'Placeholder summary',
      totalClaims: 2,
      verifiedCount: 2,
      debunkedCount: 0,
      sources: [],
    ),
    searchInsights: [],
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkAnalysis());
  }

  Future<void> checkAnalysis() async {
    analysis = await AnalysisService.analyze(
      url: widget.url,
      selection: widget.text,
    );

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final displayAnalysis = loading ? mockAnalysis : (analysis ?? mockAnalysis);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Skeletonizer(
          enabled: loading,
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: AppColors.background,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  'Analysis Results',
                  style: AppTextStyles.bold.copyWith(
                    fontSize: FontSizes.h3(context),
                    color: Colors.white,
                  ),
                ),
              ),

              // Content
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Input Summary
                    if (widget.text != null || widget.url != null) ...[
                      const SectionTitle(title: 'Input'),
                      const SizedBox(height: 12),
                      InputCard(text: widget.text, url: widget.url),
                      const SizedBox(height: 24),
                    ],

                    // Source Identity
                    const SectionTitle(title: 'Source Trustworthiness'),
                    const SizedBox(height: 12),
                    SourceIdentityCard(source: displayAnalysis.sourceIdentity),
                    const SizedBox(height: 24),

                    // Overall Verdict
                    const SectionTitle(title: 'Overall Verdict'),
                    const SizedBox(height: 12),
                    OverallVerdictCard(verdict: displayAnalysis.verdict),
                    const SizedBox(height: 24),

                    // Claims
                    if (displayAnalysis.claims.isNotEmpty) ...[
                      SectionTitle(
                        title:
                            'Claims Analysis (${displayAnalysis.claims.length})',
                      ),
                      const SizedBox(height: 12),
                      ...displayAnalysis.claims.map(
                        (claim) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ClaimCard(claim: claim),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Search Insights
                    if (displayAnalysis.searchInsights.isNotEmpty) ...[
                      const SectionTitle(title: 'Search Insights'),
                      const SizedBox(height: 12),
                      ...displayAnalysis.searchInsights.map(
                        (insight) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SearchInsightCard(insight: insight),
                        ),
                      ),
                    ],

                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
