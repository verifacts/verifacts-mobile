import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:verifacts/core/models/analysis.dart';
import 'package:verifacts/core/ui/ui.dart';
import 'package:verifacts/pages/widgets/results_widgets.dart';
import 'package:verifacts/services/analysis_service.dart';
import 'package:verifacts/services/database_service.dart';

class Results extends StatefulWidget {
  final String? text;
  final String? url;
  final Analysis? cachedAnalysis;

  const Results({super.key, this.text, this.url, this.cachedAnalysis});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  bool loading = true;
  bool hasError = false;
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
    setState(() {
      loading = true;
      hasError = false;
    });

    if (widget.cachedAnalysis != null) {
      analysis = widget.cachedAnalysis;
      loading = false;
      setState(() {});
      return;
    }

    final existing = await DatabaseService.findExistingAnalysis(
      text: widget.text,
      url: widget.url,
    );

    if (existing != null) {
      analysis = existing.analysis;
      loading = false;
      setState(() {});
      return;
    }

    analysis = await AnalysisService.analyze(
      url: widget.url,
      selection: widget.text,
    );

    if (analysis != null) {
      await DatabaseService.saveAnalysis(
        text: widget.text,
        url: widget.url,
        analysis: analysis!,
      );
    } else {
      hasError = true;
    }

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final displayAnalysis = loading ? mockAnalysis : (analysis ?? mockAnalysis);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 16),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    IconsaxPlusBroken.arrow_left,
                    color: Colors.white,
                    size: 26,
                  ),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
              ),
            ),
            const SizedBox(height: 8),
            // Content
            Expanded(
              child: hasError
                  ? _buildErrorScreen()
                  : Skeletonizer(
                      enabled: loading,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          // Overall Verdict - Hero section
                          OverallVerdictCard(verdict: displayAnalysis.verdict)
                              .animate()
                              .fadeIn(duration: 500.ms, delay: 100.ms)
                              .slideY(begin: 0.1),
                          const SizedBox(height: 24),

                          // Input section
                          if (widget.text != null || widget.url != null) ...[
                            const SectionTitle(title: 'Input')
                                .animate()
                                .fadeIn(duration: 400.ms, delay: 500.ms),
                            const SizedBox(height: 12),
                            InputCard(text: widget.text, url: widget.url)
                                .animate()
                                .fadeIn(duration: 500.ms, delay: 550.ms)
                                .slideY(begin: 0.05),
                            const SizedBox(height: 40),
                          ],

                          // Source Trustworthiness
                          const SectionTitle(title: 'Source')
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 200.ms),
                          const SizedBox(height: 12),
                          SourceIdentityCard(
                                  source: displayAnalysis.sourceIdentity)
                              .animate()
                              .fadeIn(duration: 500.ms, delay: 250.ms)
                              .slideY(begin: 0.05),
                          const SizedBox(height: 24),

                          // Claims
                          if (displayAnalysis.claims.isNotEmpty) ...[
                            SectionTitle(
                              title:
                                  'Claims (${displayAnalysis.claims.length})',
                            ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                            const SizedBox(height: 12),
                            ...displayAnalysis.claims.asMap().entries.map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ClaimCard(claim: entry.value)
                                        .animate()
                                        .fadeIn(
                                          duration: 500.ms,
                                          delay: (350 + entry.key * 50).ms,
                                        )
                                        .slideY(begin: 0.05),
                                  ),
                                ),
                            const SizedBox(height: 16),
                          ],

                          // Search Insights
                          if (displayAnalysis.searchInsights.isNotEmpty) ...[
                            const SectionTitle(title: 'Insights')
                                .animate()
                                .fadeIn(duration: 400.ms, delay: 400.ms),
                            const SizedBox(height: 12),
                            ...displayAnalysis.searchInsights
                                .asMap()
                                .entries
                                .map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: SearchInsightCard(
                                            insight: entry.value)
                                        .animate()
                                        .fadeIn(
                                          duration: 500.ms,
                                          delay: (450 + entry.key * 50).ms,
                                        )
                                        .slideY(begin: 0.05),
                                  ),
                                ),
                          ],
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconsaxPlusLinear.warning_2,
              size: 64,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 24),
            Text(
              'Analysis Failed',
              style: AppTextStyles.bold.copyWith(
                fontSize: FontSizes.h2(context),
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Something went wrong while analyzing.\nPlease check your connection and try again.',
              textAlign: TextAlign.center,
              style: AppTextStyles.regular.copyWith(
                fontSize: FontSizes.bodyMedium(context),
                color: Colors.white.withValues(alpha: 0.5),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: checkAnalysis,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      IconsaxPlusLinear.refresh,
                      color: AppColors.background,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Retry',
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: FontSizes.bodyMedium(context),
                        color: AppColors.background,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
      ),
    );
  }
}
