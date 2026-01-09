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
        return AppColors.primary;
      case 'debunked':
      case 'false':
        return AppColors.error;
      case 'mixed':
      case 'partially_true':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        color: const Color(0xFF0D1421),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'History',
                          style: AppTextStyles.bold.copyWith(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${history.length} search${history.length == 1 ? '' : 'es'}',
                          style: AppTextStyles.regular.copyWith(
                            fontSize: 14,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                    if (history.isNotEmpty)
                      IconButton(
                        onPressed: clearAll,
                        icon: const Icon(IconsaxPlusBold.trash),
                        color: AppColors.primary,
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
          Icon(IconsaxPlusBold.info_circle, size: 40, color: AppColors.primary),
          const SizedBox(height: 20),
          Text(
            'No history yet',
            style: AppTextStyles.semiBold.copyWith(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your searches will appear here',
            style: AppTextStyles.regular.copyWith(
              fontSize: 14,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        AnalysisHistory item = history[index];
        Color verdictColor = getVerdictColor(
          item.analysis.verdict.overallVerdict,
        );
        DateFormat dateFormat = DateFormat('MMM d, h:mm a');

        return Dismissible(
          key: Key('history_${item.id}'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => deleteItem(item.id!),
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete_rounded, color: AppColors.error),
          ),
          child:
              GestureDetector(
                onTap: () => openHistoryItem(item),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.white.withValues(alpha: 0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: verdictColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Verdict indicator
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: verdictColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  item.verdictEmoji,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: verdictColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Title
                            Expanded(
                              child: Text(
                                item.displayTitle,
                                style: AppTextStyles.medium.copyWith(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Arrow
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Footer
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 12,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              dateFormat.format(item.createdAt),
                              style: AppTextStyles.regular.copyWith(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: verdictColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.analysis.verdict.overallVerdict
                                    .toUpperCase(),
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 9,
                                  color: verdictColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 300),
                delay: Duration(milliseconds: index * 50),
              ),
        );
      },
    );
  }
}
