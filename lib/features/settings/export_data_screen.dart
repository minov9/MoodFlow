import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_theme.dart';
import '../../core/data/mood_repository.dart';
import '../../core/constants/mood_types.dart';

/// 导出数据页
class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({super.key});

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final stats = MoodRepository.getStats();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        middle: Text(
          '导出数据',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            CupertinoIcons.back,
            color: AppColors.primary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 数据概览
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppShadows.colored(AppColors.primary),
            ),
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.doc_text_fill,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  '${stats.totalDays} 条心情记录',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '可以导出为 JSON 格式',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 导出选项
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppShadows.small,
            ),
            child: Column(
              children: [
                _ExportOption(
                  icon: CupertinoIcons.doc_plaintext,
                  title: '导出为 JSON',
                  subtitle: '包含所有心情记录的详细数据',
                  onTap: stats.totalDays > 0 ? () => _exportAsJson() : null,
                ),
                Divider(height: 0.5, indent: 70, color: AppColors.divider),
                _ExportOption(
                  icon: CupertinoIcons.table,
                  title: '导出为 CSV',
                  subtitle: '可用 Excel 打开的表格格式',
                  onTap: stats.totalDays > 0 ? () => _exportAsCsv() : null,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          if (stats.totalDays == 0)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.info_circle_fill,
                    color: Color(0xFFFF9800),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '暂无数据可导出，开始记录你的心情吧！',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFE65100),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '导出的数据文件可通过分享功能发送到其他应用或保存到云盘。',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _exportAsJson() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    try {
      final entries = MoodRepository.getAllEntries();
      final data = entries.map((e) => {
        'id': e.id,
        'date': e.date.toIso8601String(),
        'mood': e.moodType.label,
        'moodValue': e.moodValue,
        'note': e.note,
        'createdAt': e.createdAt.toIso8601String(),
      }).toList();

      final jsonString = const JsonEncoder.withIndent('  ').convert({
        'exportedAt': DateTime.now().toIso8601String(),
        'totalEntries': entries.length,
        'entries': data,
      });

      await Share.share(
        jsonString,
        subject: 'MoodFlow 心情记录导出',
      );
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportAsCsv() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    try {
      final entries = MoodRepository.getAllEntries();
      final buffer = StringBuffer();

      // CSV 头
      buffer.writeln('日期,心情,心情值,备注');

      // 数据行
      for (final entry in entries) {
        final date = '${entry.date.year}-${entry.date.month.toString().padLeft(2, '0')}-${entry.date.day.toString().padLeft(2, '0')}';
        final note = entry.note?.replaceAll(',', '，') ?? '';
        buffer.writeln('$date,${entry.moodType.label},${entry.moodValue},$note');
      }

      await Share.share(
        buffer.toString(),
        subject: 'MoodFlow 心情记录导出',
      );
    } finally {
      setState(() => _isExporting = false);
    }
  }
}

class _ExportOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ExportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap != null ? 1.0 : 0.5,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.share,
                color: AppColors.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
