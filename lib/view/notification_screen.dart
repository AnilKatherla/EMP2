import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emp/core/theme/app_colors.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'package:emp/core/theme/app_text_styles.dart';
import 'package:emp/viewmodel/notification/notification_viewmodel.dart';

// ─────────────────────────────────────────────
// NOTIFICATION SCREEN
// ─────────────────────────────────────────────
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatelessWidget {
  const _NotificationView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context, vm),
      body: vm.items.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: EdgeInsets.all(AppSpacing.lg),
              itemCount: vm.items.length,
              separatorBuilder: (_, __) => SizedBox(height: AppSpacing.gapMD),
              itemBuilder: (context, index) {
                return _NotificationTile(notification: vm.items[index], vm: vm);
              },
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, NotificationViewModel vm) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(AppSpacing.appBarHeightLarge),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Notifications',
                style: AppTextStyles.headingS.copyWith(color: Colors.white),
              ),
              Text(
                'Latest updates and alerts',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withAlpha((0.8 * 255).round()),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: vm.markAllAsRead,
              child: Text(
                'Mark all as read',
                style: AppTextStyles.labelM.copyWith(color: Colors.white),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 64, color: AppColors.textMutedLight),
          SizedBox(height: AppSpacing.md),
          Text('No new notifications', style: AppTextStyles.headingS),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NOTIFICATION TILE
// ─────────────────────────────────────────────
class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final NotificationViewModel vm;

  const _NotificationTile({required this.notification, required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs    = theme.colorScheme;
    final (icon, color, tint) = _getNotificationStyle();

    return GestureDetector(
      onTap: () => vm.markAsRead(notification.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: notification.isRead ? theme.colorScheme.surface : theme.colorScheme.surfaceVariant.withAlpha((0.4 * 255).round()),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: notification.isRead ? AppColors.borderLight : AppColors.primaryAlpha(0.2),
            width: notification.isRead ? 1 : 1.5,
          ),
          boxShadow: notification.isRead
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primaryAlpha(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color, size: AppSpacing.iconSM),
            ),
            SizedBox(width: AppSpacing.md),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification.title,
                        style: AppTextStyles.labelL.copyWith(
                          fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                          color: notification.isRead ? cs.onSurface : AppColors.primary,
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(
                    notification.body,
                    style: AppTextStyles.bodyS.copyWith(
                      color: notification.isRead ? cs.onSurfaceVariant : cs.onSurface,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: AppTextStyles.caption.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color, Color) _getNotificationStyle() {
    return switch (notification.type) {
      NotificationType.task    => (Icons.assignment_rounded, AppColors.primary, AppColors.primaryContainer),
      NotificationType.message => (Icons.chat_bubble_rounded, AppColors.secondary, AppColors.secondaryContainer),
      NotificationType.target  => (Icons.trending_up_rounded, AppColors.success, AppColors.successContainer),
      NotificationType.reminder=> (Icons.timer_rounded, AppColors.warning, AppColors.warningContainer),
      NotificationType.alert   => (Icons.error_outline_rounded, AppColors.error, AppColors.errorContainer),
    };
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
