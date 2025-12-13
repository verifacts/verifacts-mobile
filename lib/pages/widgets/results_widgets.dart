import 'package:flutter/material.dart';
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
      style: AppTextStyles.bold.copyWith(
        fontSize: FontSizes.h3(context),
        color: Colors.white,
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

  String getTrustLevelEmoji(String trustLevel) {
    switch (trustLevel.toLowerCase()) {
      case 'high':
        return '✅';
      case 'medium':
        return '⚠️';
      case 'low':
        return '❌';
      default:
        return '❓';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      getTrustLevelEmoji(source.trustLevel),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      source.trustLevel.toUpperCase(),
                      style: AppTextStyles.bold.copyWith(
                        fontSize: FontSizes.bodySmall(context),
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${source.score}/100',
                      style: AppTextStyles.bold.copyWith(
                        fontSize: FontSizes.bodyMedium(context),
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            source.summary,
            style: AppTextStyles.medium.copyWith(
              fontSize: FontSizes.bodyMedium(context),
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
          if (source.redFlags.isNotEmpty) ...[
            const SizedBox(height: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag_rounded, color: AppColors.error, size: 14),
          const SizedBox(width: 6),
          Text(
            flag.replaceAll('_', ' '),
            style: AppTextStyles.medium.copyWith(
              fontSize: FontSizes.bodySmall(context),
              color: AppColors.error,
            ),
          ),
        ],
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
        return Icons.check_circle_rounded;
      case 'debunked':
        return Icons.cancel_rounded;
      case 'unverified':
      case 'mixed':
        return Icons.help_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final verdictColor = getVerdictColor(verdict.overallVerdict);
    final verdictIcon = getVerdictIcon(verdict.overallVerdict);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            verdictColor.withValues(alpha: 0.15),
            verdictColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: verdictColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(verdictIcon, color: verdictColor, size: 32),
              const SizedBox(width: 12),
              Text(
                verdict.overallVerdict.toUpperCase(),
                style: AppTextStyles.bold.copyWith(
                  fontSize: FontSizes.h3(context),
                  color: verdictColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (verdict.summary.isNotEmpty &&
              verdict.summary != 'No summary available')
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                verdict.summary,
                style: AppTextStyles.medium.copyWith(
                  fontSize: FontSizes.bodyMedium(context),
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
            ),
          Row(
            children: [
              StatChip(
                label: 'Total',
                value: verdict.totalClaims.toString(),
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              StatChip(
                label: 'Verified',
                value: verdict.verifiedCount.toString(),
                color: AppColors.success,
              ),
              const SizedBox(width: 12),
              StatChip(
                label: 'Debunked',
                value: verdict.debunkedCount.toString(),
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ),
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
        return Icons.check_circle_rounded;
      case 'debunked':
        return Icons.cancel_rounded;
      case 'unverified':
      case 'mixed':
        return Icons.help_rounded;
      default:
        return Icons.info_rounded;
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
        border: Border.all(
          color: verdictColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Icon(verdictIcon, color: verdictColor, size: 24),
          title: Text(
            claim.claim,
            style: AppTextStyles.semiBold.copyWith(
              fontSize: FontSizes.bodyMedium(context),
              color: Colors.white,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: verdictColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    claim.verdict.toUpperCase(),
                    style: AppTextStyles.bold.copyWith(
                      fontSize: FontSizes.bodySmall(context),
                      color: verdictColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.speed_rounded, color: AppColors.primary, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${claim.confidence}% confidence',
                  style: AppTextStyles.medium.copyWith(
                    fontSize: FontSizes.bodySmall(context),
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          children: [
            const SizedBox(height: 12),
            Text(
              claim.explanation,
              style: AppTextStyles.medium.copyWith(
                fontSize: FontSizes.bodyMedium(context),
                color: Colors.white.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            if (claim.sources.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Sources:',
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: FontSizes.bodyMedium(context),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              ...claim.sources.map(
                (source) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => _launchUrl(context, source),
                    child: Row(
                      children: [
                        Icon(
                          Icons.link_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            source,
                            style: AppTextStyles.medium.copyWith(
                              fontSize: FontSizes.bodySmall(context),
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  insight.claim,
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: FontSizes.bodyMedium(context),
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: verdictColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  insight.insights.verdict.toUpperCase(),
                  style: AppTextStyles.bold.copyWith(
                    fontSize: FontSizes.bodySmall(context),
                    color: verdictColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            insight.insights.llmSummary,
            style: AppTextStyles.medium.copyWith(
              fontSize: FontSizes.bodyMedium(context),
              color: Colors.white.withValues(alpha: 0.8),
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
                        Icons.article_rounded,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          source.title,
                          style: AppTextStyles.medium.copyWith(
                            fontSize: FontSizes.bodySmall(context),
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      insight.insights.notes,
                      style: AppTextStyles.medium.copyWith(
                        fontSize: FontSizes.bodySmall(context),
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
