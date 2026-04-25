import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodel/employee/follow_up_viewmodel.dart';
import '../../data/repositories/visit_repository.dart';

class FollowUpScreen extends StatelessWidget {
  const FollowUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => FollowUpViewModel(
        repository: ctx.read<VisitRepository>(),
      )..fetchFollowUps(),
      child: const _FollowUpView(),
    );
  }
}

class _FollowUpView extends StatelessWidget {
  const _FollowUpView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FollowUpViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Follow-ups', style: AppTextStyles.headingS.copyWith(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${vm.errorMessage}'),
                      ElevatedButton(
                        onPressed: () => vm.fetchFollowUps(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : vm.followUps.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_note_rounded, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No follow-ups scheduled',
                            style: AppTextStyles.bodyM.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => vm.fetchFollowUps(),
                      child: ListView.separated(
                        padding: EdgeInsets.all(AppSpacing.md),
                        itemCount: vm.followUps.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final followUp = vm.followUps[index];
                          return _FollowUpCard(followUp: followUp);
                        },
                      ),
                    ),
    );
  }
}

class _FollowUpCard extends StatelessWidget {
  final dynamic followUp;
  const _FollowUpCard({required this.followUp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('EEE, dd MMM yyyy').format(followUp.nextFollowUpDate);
    
    Color priorityColor;
    switch (followUp.priority.toLowerCase()) {
      case 'critical': 
      case 'high': 
        priorityColor = AppColors.error; 
        break;
      case 'medium': 
        priorityColor = AppColors.warning; 
        break;
      case 'low':
        priorityColor = AppColors.success;
        break;
      default: 
        priorityColor = AppColors.secondary;
    }

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  followUp.storeName,
                  style: AppTextStyles.headingS.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: priorityColor.withOpacity(0.2)),
                ),
                child: Text(
                  followUp.priority.toUpperCase(),
                  style: AppTextStyles.labelS.copyWith(
                    color: priorityColor, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_rounded, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(followUp.ownerName, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                const Icon(Icons.event_rounded, size: 20, color: AppColors.primary),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Next Visit Date', style: AppTextStyles.caption.copyWith(fontSize: 10)),
                    Text(dateStr, style: AppTextStyles.labelM.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          if (followUp.reason.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Reason: ${followUp.reason}',
              style: AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to visit or follow up action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              child: const Text('Start Follow-up Visit'),
            ),
          ),
        ],
      ),
    );
  }
}

// These classes might be missing in some contexts, ensure they are available
class AppRadius {
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
}
