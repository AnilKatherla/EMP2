import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:emp/core/theme/app_colors.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'package:emp/core/theme/app_text_styles.dart';
import 'package:emp/data/repositories/visit_repository.dart';
import 'package:emp/core/api_constants.dart';
import 'package:intl/intl.dart';

class VisitDetailScreen extends StatefulWidget {
  final String visitId;
  const VisitDetailScreen({super.key, required this.visitId});

  @override
  State<VisitDetailScreen> createState() => _VisitDetailScreenState();
}

class _VisitDetailScreenState extends State<VisitDetailScreen> {
  Map<String, dynamic>? _visitDetail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final repo = context.read<VisitRepository>();
      final data = await repo.getVisitDetail(widget.visitId);
      setState(() { _visitDetail = data; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _error != null
          ? Center(child: Text('Error: $_error'))
          : _buildDetailView(),
    );
  }

  Widget _buildDetailView() {
    final v = _visitDetail!;
    final date = v['timestamp'] != null ? DateTime.parse(v['timestamp']) : DateTime.now();
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(date);
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Business Info', [
            _DetailRow(label: 'Store Name', value: v['storeName'] ?? 'N/A'),
            _DetailRow(label: 'Owner Name', value: v['ownerName'] ?? 'N/A'),
            _DetailRow(label: 'Mobile', value: v['mobileNumber'] ?? 'N/A'),
          ]),
          SizedBox(height: AppSpacing.gapMD),
          _buildInfoCard('Visit Info', [
            _DetailRow(label: 'Status', value: v['status']?.toString().toUpperCase() ?? 'N/A', isStatus: true),
            _DetailRow(label: 'Type', value: v['visitType']?.toString().toUpperCase() ?? 'N/A'),
            _DetailRow(label: 'Date', value: dateStr),
            _DetailRow(label: 'Address', value: v['address'] ?? 'N/A'),
          ]),
          if (v['notes'] != null && v['notes'].toString().isNotEmpty) ...[
            SizedBox(height: AppSpacing.gapMD),
            _buildInfoCard('Notes', [
              Text(v['notes'], style: AppTextStyles.bodyM),
            ]),
          ],
          if (v['milestones'] != null) ...[
            SizedBox(height: AppSpacing.gapMD),
            _buildInfoCard('Milestones', [
              _MilestoneRow(label: 'Initial Check', checked: v['milestones']['initialCheck'] ?? false),
              _MilestoneRow(label: 'Knowledge Shared', checked: v['milestones']['knowledgeShared'] ?? false),
              _MilestoneRow(label: 'Order Logged', checked: v['milestones']['orderLogged'] ?? false),
            ]),
          ],
          if (v['photos'] != null && (v['photos'] as List).isNotEmpty) ...[
            SizedBox(height: AppSpacing.gapMD),
            _buildPhotoGallery(context, v['photos']),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoGallery(BuildContext context, List<dynamic> photos) {
    return _buildInfoCard('Visit Proof / Photos', [
      SizedBox(
        height: 50,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: photos.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final photo = photos[index];
            return GestureDetector(
              onTap: () => _showFullScreenImage(context, photo),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Image(
                  image: _getImageProvider(photo),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 50,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported_rounded, size: 15),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }

  void _showFullScreenImage(BuildContext context, String photo) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image(
                  image: _getImageProvider(photo),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headingS.copyWith(color: AppColors.primary)),
          const Divider(),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isStatus;
  const _DetailRow({required this.label, required this.value, this.isStatus = false});

  @override
  Widget build(BuildContext context) {
    Color? valueColor = isStatus ? AppColors.success : null;
    if (isStatus && (value.toLowerCase().contains('reject') || value.toLowerCase().contains('not_interested'))) {
      valueColor = AppColors.error;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // Fixed width for labels to align colons
            child: Text(
              label, 
              style: AppTextStyles.labelS.copyWith(
                color: Colors.grey[600], 
                fontSize: 12,
              ),
            ),
          ),
          Text(" :  ", style: AppTextStyles.labelS.copyWith(color: Colors.grey, fontSize: 12)),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.labelS.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.3,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  final String label;
  final bool checked;
  const _MilestoneRow({required this.label, required this.checked});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(checked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, 
             color: checked ? AppColors.success : Colors.grey),
        SizedBox(width: 8),
        Text(label, style: AppTextStyles.bodyM),
      ],
    );
  }
}
