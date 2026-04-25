import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:emp/core/theme/app_colors.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'package:emp/core/theme/app_text_styles.dart';
import 'package:emp/viewmodel/history/history_viewmodel.dart';
import 'package:emp/view/visit_detail_screen.dart';
import 'package:emp/core/api_constants.dart';
import 'package:intl/intl.dart';

class VisitHistoryScreen extends StatefulWidget {
  const VisitHistoryScreen({super.key});

  @override
  State<VisitHistoryScreen> createState() => _VisitHistoryScreenState();
}

class _VisitHistoryScreenState extends State<VisitHistoryScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VisitHistoryViewModel>().fetchVisits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Consumer<VisitHistoryViewModel>(
        builder: (context, vm, child) {
          return CustomScrollView(
            slivers: [
              // ── Pinned App Bar ────────────────────────────────────
              SliverAppBar(
                pinned: true,
                floating: false,
                elevation: 0,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                title: Text('My Visits', style: AppTextStyles.headingS.copyWith(color: Colors.white)),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () => vm.fetchVisits(),
                    icon: const Icon(Icons.sync_rounded),
                  ),
                ],
              ),

              // ── Search Section ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: vm.setSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Search stores or locations...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),

              // ── Loading / Error / Empty States ────────────────────────────
              if (vm.isLoading && vm.visits.isEmpty)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else if (vm.errorMessage != null && vm.visits.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 64, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text(vm.errorMessage!),
                        TextButton(onPressed: vm.fetchVisits, child: const Text('Try Again')),
                      ],
                    ),
                  ),
                )
              else if (vm.visits.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_rounded, size: 80, color: theme.disabledColor.withOpacity(0.2)),
                        const SizedBox(height: 16),
                        Text('No visits found', style: AppTextStyles.labelL),
                      ],
                    ),
                  ),
                )
              else
                // ── Visits List ─────────────────────────────────────────────
                SliverPadding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final visit = vm.visits[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.gapMD),
                          child: _VisitHistoryCard(visit: visit),
                        );
                      },
                      childCount: vm.visits.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}

class _VisitHistoryCard extends StatelessWidget {
  final dynamic visit;
  const _VisitHistoryCard({required this.visit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('EEE, dd MMM · hh:mm a').format(visit.timestamp);
    
    Color statusColor;
    String statusText = visit.status.toUpperCase();
    switch (visit.status.toLowerCase()) {
      case 'completed': 
        statusColor = AppColors.success;
        statusText = 'COMPLETED';
        break;
      case 'partially_completed': 
        statusColor = AppColors.warning;
        statusText = 'PARTIAL';
        break;
      case 'follow_up': 
      case 'need_follow_up':
        statusColor = AppColors.info;
        statusText = 'FOLLOW-UP';
        break;
      case 'rejected': 
      case 'not_interested':
        statusColor = AppColors.error;
        statusText = 'REJECTED';
        break;
      default: 
        statusColor = AppColors.secondary;
        statusText = visit.status.toUpperCase();
    }

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VisitDetailScreen(visitId: visit.id)),
      ),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Thumbnail with image or icon fallback
                _buildThumbnail(visit),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visit.storeName,
                        style: AppTextStyles.headingS.copyWith(fontSize: 16, height: 1.2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 12, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              dateStr, 
                              style: AppTextStyles.caption.copyWith(fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: _StatusBadge(status: statusText, color: statusColor),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                Icon(Icons.location_on_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    visit.address ?? visit.city ?? 'Location not specified',
                    style: AppTextStyles.caption.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(dynamic visit) {
    final String? firstPhoto = visit.photos.isNotEmpty ? visit.photos.first : null;
    
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        image: firstPhoto != null
          ? DecorationImage(
              image: _getImageProvider(firstPhoto),
              fit: BoxFit.cover,
            )
          : null,
      ),
      child: firstPhoto == null
        ? Icon(
            visit.visitType == 'supplier' ? Icons.factory_rounded : Icons.store_rounded,
            color: AppColors.primary,
          )
        : null,
    );
  }

  ImageProvider _getImageProvider(String photo) {
    if (photo.startsWith('data:image')) {
      try {
        final base64String = photo.split(',').last;
        return MemoryImage(base64Decode(base64String));
      } catch (e) {
        return const AssetImage('assets/images/placeholder.png'); // Fallback
      }
    } else {
      return NetworkImage('${ApiConstants.baseUrl}/uploads/$photo');
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;
  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.labelS.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          fontSize: 10,
        ),
      ),
    );
  }
}
