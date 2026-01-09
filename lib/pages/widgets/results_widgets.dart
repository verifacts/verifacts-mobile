import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verifacts/core/models/analysis.dart';
import 'package:verifacts/core/ui/ui.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.semiBold.copyWith(
        fontSize: FontSizes.bodyLarge(context),
        color: Colors.white.withValues(alpha: 0.6),
        letterSpacing: 0.5,
      ),
    );
  }
}

class InputCard extends StatelessWidget {
  final String? text;
  final String? url;

  const InputCard({super.key, this.text, this.url});

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (text != null && text!.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.text_fields_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Text',
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: FontSizes.bodyMedium(context),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              text!,
              style: AppTextStyles.medium.copyWith(
                fontSize: FontSizes.bodyMedium(context),
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            if (url != null && url!.isNotEmpty) const SizedBox(height: 16),
          ],
          if (url != null && url!.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.link_rounded, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'URL',
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: FontSizes.bodyMedium(context),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchUrl(context, url!),
              child: Text(
                url!,
                style: AppTextStyles.medium.copyWith(
                  fontSize: FontSizes.bodySmall(context),
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SourceIdentityCard extends StatelessWidget {
  final SourceIdentity source;

  const SourceIdentityCard({super.key, required this.source});

  Color getTrustColor(String trustLevel) {
    switch (trustLevel.toLowerCase()) {
      case 'high':
        return AppColors.success;
      case 'medium':
        return Colors.orange;
      case 'low':
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  IconData getTrustIcon(String trustLevel) {
    switch (trustLevel.toLowerCase()) {
      case 'high':
        return IconsaxPlusBold.shield_tick;
      case 'medium':
        return IconsaxPlusBold.shield;
      case 'low':
        return IconsaxPlusBold.shield_cross;
      default:
        return IconsaxPlusBold.shield;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trustColor = getTrustColor(source.trustLevel);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                getTrustIcon(source.trustLevel),
                color: trustColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                source.trustLevel.toUpperCase(),
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: FontSizes.bodySmall(context),
                  color: trustColor,
                ),
              ),
              const Spacer(),
              Text(
                '${source.score.toInt()}',
                style: AppTextStyles.bold.copyWith(
                  fontSize: FontSizes.h3(context),
                  color: Colors.white,
                ),
              ),
              Text(
                '/100',
                style: AppTextStyles.medium.copyWith(
                  fontSize: FontSizes.bodySmall(context),
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            source.summary,
            style: AppTextStyles.regular.copyWith(
              fontSize: FontSizes.bodyMedium(context),
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          if (source.redFlags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: source.redFlags.map((flag) {
                return RedFlagChip(flag: flag);
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class RedFlagChip extends StatelessWidget {
  final String flag;

  const RedFlagChip({super.key, required this.flag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        flag.replaceAll('_', ' '),
        style: AppTextStyles.medium.copyWith(
          fontSize: FontSizes.bodySmall(context),
          color: AppColors.error.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

class OverallVerdictCard extends StatelessWidget {
  final Verdict verdict;

  const OverallVerdictCard({super.key, required this.verdict});

  Color getVerdictColor(String verdict) {
    switch (verdict.toLowerCase()) {
      case 'verified':
        return AppColors.success;
      case 'debunked':
        return AppColors.error;
      case 'unverified':
      case 'mixed':
        return Colors.orange;
      default:
        return AppColors.grey;
    }
  }

  IconData getVerdictIcon(String verdict) {
    switch (verdict.toLowerCase()) {
      case 'verified':
        return IconsaxPlusBold.tick_circle;
      case 'debunked':
        return IconsaxPlusBold.close_circle;
      case 'unverified':
      case 'mixed':
        return IconsaxPlusBold.warning_2;
      default:
        return IconsaxPlusBold.info_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final verdictColor = getVerdictColor(verdict.overallVerdict);
    final verdictIcon = getVerdictIcon(verdict.overallVerdict);

    return Column(
      children: [
        const SizedBox(height: 20),
        Icon(verdictIcon, color: verdictColor, size: 64),
        const SizedBox(height: 16),
        Text(
          verdict.overallVerdict.toUpperCase(),
          style: AppTextStyles.bold.copyWith(
            fontSize: FontSizes.h1(context),
            color: verdictColor,
            letterSpacing: 1,
          ),
        ),
        if (verdict.summary.isNotEmpty &&
            verdict.summary != 'No summary available') ...[
          const SizedBox(height: 12),
          Text(
            verdict.summary,
            textAlign: TextAlign.center,
            style: AppTextStyles.regular.copyWith(
              fontSize: FontSizes.bodyMedium(context),
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
        ],
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatItem(
              value: verdict.totalClaims.toString(),
              label: 'Claims',
              color: Colors.white,
            ),
            Container(
              width: 1,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: Colors.white.withValues(alpha: 0.2),
            ),
            _StatItem(
              value: verdict.verifiedCount.toString(),
              label: 'Verified',
              color: AppColors.success,
            ),
            Container(
              width: 1,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: Colors.white.withValues(alpha: 0.2),
            ),
            _StatItem(
              value: verdict.debunkedCount.toString(),
              label: 'Debunked',
              color: AppColors.error,
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.bold.copyWith(
            fontSize: FontSizes.h2(context),
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.medium.copyWith(
            fontSize: FontSizes.bodySmall(context),
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StatChip({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.medium.copyWith(
              fontSize: FontSizes.bodySmall(context),
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: AppTextStyles.bold.copyWith(
              fontSize: FontSizes.bodySmall(context),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class ClaimCard extends StatelessWidget {
  final Claim claim;

  const ClaimCard({super.key, required this.claim});

  Color getVerdictColor(String verdict) {
    switch (verdict.toLowerCase()) {
      case 'verified':
        return AppColors.success;
      case 'debunked':
        return AppColors.error;
      case 'unverified':
      case 'mixed':
        return Colors.orange;
      default:
        return AppColors.grey;
    }
  }

  IconData getVerdictIcon(String verdict) {
    switch (verdict.toLowerCase()) {
      case 'verified':
        return IconsaxPlusBold.tick_circle;
      case 'debunked':
        return IconsaxPlusBold.close_circle;
      case 'unverified':
      case 'mixed':
        return IconsaxPlusBold.warning_2;
      default:
        return IconsaxPlusBold.info_circle;
    }
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final verdictColor = getVerdictColor(claim.verdict);
    final verdictIcon = getVerdictIcon(claim.verdict);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Icon(verdictIcon, color: verdictColor, size: 22),
          title: Text(
            claim.claim,
            style: AppTextStyles.medium.copyWith(
              fontSize: FontSizes.bodyMedium(context),
              color: Colors.white,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Text(
                  claim.verdict.toUpperCase(),
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: FontSizes.bodySmall(context),
                    color: verdictColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${claim.confidence}%',
                  style: AppTextStyles.medium.copyWith(
                    fontSize: FontSizes.bodySmall(context),
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          children: [
            const SizedBox(height: 8),
            Text(
              claim.explanation,
              style: AppTextStyles.regular.copyWith(
                fontSize: FontSizes.bodyMedium(context),
                color: Colors.white.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
            if (claim.sources.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...claim.sources.map(
                (source) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => _launchUrl(context, source),
                    child: Row(
                      children: [
                        Icon(
                          IconsaxPlusLinear.link_2,
                          color: AppColors.primary.withValues(alpha: 0.8),
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            source,
                            style: AppTextStyles.regular.copyWith(
                              fontSize: FontSizes.bodySmall(context),
                              color: AppColors.primary.withValues(alpha: 0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SearchInsightCard extends StatelessWidget {
  final SearchInsight insight;

  const SearchInsightCard({super.key, required this.insight});

  Color getVerdictColor(String verdict) {
    switch (verdict.toLowerCase()) {
      case 'verified':
        return AppColors.success;
      case 'debunked':
        return AppColors.error;
      case 'unverified':
      case 'mixed':
        return Colors.orange;
      default:
        return AppColors.grey;
    }
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final verdictColor = getVerdictColor(insight.insights.verdict);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  insight.claim,
                  style: AppTextStyles.medium.copyWith(
                    fontSize: FontSizes.bodyMedium(context),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                insight.insights.verdict.toUpperCase(),
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: FontSizes.bodySmall(context),
                  color: verdictColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            insight.insights.llmSummary,
            style: AppTextStyles.regular.copyWith(
              fontSize: FontSizes.bodyMedium(context),
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
          if (insight.insights.keySources.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...insight.insights.keySources.map(
              (source) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: GestureDetector(
                  onTap: () => _launchUrl(context, source.url),
                  child: Row(
                    children: [
                      Icon(
                        IconsaxPlusLinear.document_text,
                        color: AppColors.primary.withValues(alpha: 0.8),
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          source.title,
                          style: AppTextStyles.regular.copyWith(
                            fontSize: FontSizes.bodySmall(context),
                            color: AppColors.primary.withValues(alpha: 0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (insight.insights.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  IconsaxPlusLinear.info_circle,
                  color: Colors.orange.withValues(alpha: 0.8),
                  size: 14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    insight.insights.notes,
                    style: AppTextStyles.regular.copyWith(
                      fontSize: FontSizes.bodySmall(context),
                      color: Colors.orange.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
