import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:verifacts/core/models/history.dart';
import 'package:verifacts/core/ui/ui.dart';
import 'package:verifacts/pages/results.dart';
import 'package:verifacts/services/database_service.dart';

class HistoryDrawer extends StatefulWidget {
  const HistoryDrawer({super.key});

  @override
  State<HistoryDrawer> createState() => _HistoryDrawerState();
}

class _HistoryDrawerState extends State<HistoryDrawer> {
  List<AnalysisHistory> history = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final results = await DatabaseService.getHistory();
    setState(() {
      history = results;
      loading = false;
    });
  }

  Future<void> deleteItem(int id) async {
    await DatabaseService.deleteHistory(id);
    await loadHistory();
  }

  Future<void> clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1B1F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear History',
          style: AppTextStyles.bold.copyWith(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to clear all history? This cannot be undone.',
          style: AppTextStyles.regular.copyWith(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTextStyles.medium.copyWith(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Clear',
              style: AppTextStyles.medium.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseService.clearHistory();
      await loadHistory();
    }
  }

  void openHistoryItem(AnalysisHistory item) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Results(
          text: item.text,
          url: item.url,
          cachedAnalysis: item.analysis,
        ),
      ),
    );
  }

  Color getVerdictColor(String verdict) {
    switch (verdict.toLowerCase()) {
      case 'verified':
      case 'true':
        return AppColors.success;
      case 'debunked':
      case 'false':
        return AppColors.error;
      case 'mixed':
      case 'partially_true':
        return Colors.orange;
      default:
        return AppColors.grey;
    }
  }

  IconData getVerdictIcon(String verdict) {
    switch (verdict.toLowerCase()) {
      case 'verified':
      case 'true':
        return IconsaxPlusBold.tick_circle;
      case 'debunked':
      case 'false':
        return IconsaxPlusBold.close_circle;
      case 'mixed':
      case 'partially_true':
        return IconsaxPlusBold.warning_2;
      default:
        return IconsaxPlusBold.info_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        color: AppColors.background,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
                child: Row(
                  children: [
                    Text(
                      'History',
                      style: AppTextStyles.bold.copyWith(
                        fontSize: FontSizes.h2(context),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${history.length}',
                      style: AppTextStyles.medium.copyWith(
                        fontSize: FontSizes.bodyMedium(context),
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                    const Spacer(),
                    if (history.isNotEmpty)
                      IconButton(
                        onPressed: clearAll,
                        icon: const Icon(IconsaxPlusLinear.trash),
                        color: Colors.white.withValues(alpha: 0.4),
                        iconSize: 20,
                      ),
                  ],
                ),
              ),
              Expanded(
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      )
                    : history.isEmpty
                        ? _buildEmptyState()
                        : _buildHistoryList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconsaxPlusLinear.clock,
            size: 48,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No history yet',
            style: AppTextStyles.medium.copyWith(
              fontSize: FontSizes.bodyLarge(context),
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your searches will appear here',
            style: AppTextStyles.regular.copyWith(
              fontSize: FontSizes.bodySmall(context),
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: history.length,
      itemBuilder: (context, index) {
        AnalysisHistory item = history[index];
        Color verdictColor = getVerdictColor(
          item.analysis.verdict.overallVerdict,
        );
        IconData verdictIcon = getVerdictIcon(
          item.analysis.verdict.overallVerdict,
        );
        DateFormat dateFormat = DateFormat('MMM d');

        return Dismissible(
          key: Key('history_${item.id}'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => deleteItem(item.id!),
          background: Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              IconsaxPlusLinear.trash,
              color: AppColors.error.withValues(alpha: 0.8),
              size: 20,
            ),
          ),
          child: GestureDetector(
            onTap: () => openHistoryItem(item),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(verdictIcon, color: verdictColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.displayTitle,
                          style: AppTextStyles.medium.copyWith(
                            fontSize: FontSizes.bodyMedium(context),
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              item.analysis.verdict.overallVerdict.toUpperCase(),
                              style: AppTextStyles.semiBold.copyWith(
                                fontSize: FontSizes.bodySmall(context) - 1,
                                color: verdictColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              dateFormat.format(item.createdAt),
                              style: AppTextStyles.regular.copyWith(
                                fontSize: FontSizes.bodySmall(context) - 1,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    IconsaxPlusLinear.arrow_right_3,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(
                duration: 300.ms,
                delay: (index * 40).ms,
              ),
        );
      },
    );
  }
}
