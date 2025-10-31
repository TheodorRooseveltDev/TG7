import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/gradient_orb.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/custom_button.dart';
import '../../providers/app_state.dart';
import '../../models/note.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  void _showAddNoteSheet(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            gradient: AppColors.glassCardGradient,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXL),
            ),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              left: AppSpacing.screenMarginMobile,
              right: AppSpacing.screenMarginMobile,
              top: AppSpacing.xl,
              bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('New Note', style: AppTypography.headingLStyle()),
                    IconButtonCustom(
                      icon: Icons.close,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Title', style: AppTypography.bodyLStyle()),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: titleController,
                  style: AppTypography.bodyLStyle(),
                  decoration: InputDecoration(
                    hintText: 'Enter note title...',
                    hintStyle: AppTypography.bodyLStyle(
                      color: AppColors.textQuaternary,
                    ),
                    filled: true,
                    fillColor: AppColors.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(
                        color: AppColors.electricBluePrimary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Content', style: AppTypography.bodyLStyle()),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: contentController,
                  maxLines: 8,
                  style: AppTypography.bodyLStyle(),
                  decoration: InputDecoration(
                    hintText: 'Write your note here...',
                    hintStyle: AppTypography.bodyLStyle(
                      color: AppColors.textQuaternary,
                    ),
                    filled: true,
                    fillColor: AppColors.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(
                        color: AppColors.electricBluePrimary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                CustomButton(
                  text: 'Save Note',
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        contentController.text.isNotEmpty) {
                      final note = Note(
                        title: titleController.text,
                        content: contentController.text,
                      );
                      context.read<AppState>().addNote(note);
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: GradientOrbBackground(
        child: SafeArea(
          child: Consumer<AppState>(
            builder: (context, state, child) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screenMarginMobile),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('More', style: AppTypography.headingXLStyle()),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Notes, achievements & settings',
                      style: AppTypography.bodyMStyle(
                        color: AppColors.textTertiary,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    // Notes Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Notes',
                          style: AppTypography.headingLStyle(),
                        ),
                        IconButtonCustom(
                          icon: Icons.add,
                          onPressed: () => _showAddNoteSheet(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    if (state.notes.isEmpty)
                      SimpleGlassCard(
                        child: Container(
                          height: 150,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.note_alt_outlined,
                                size: 48,
                                color: AppColors.textQuaternary,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'No notes yet',
                                style: AppTypography.bodyLStyle(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Tap + to create your first note',
                                style: AppTypography.bodyMStyle(
                                  color: AppColors.textQuaternary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...state.notes.reversed.take(5).map((note) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: SimpleGlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        note.title,
                                        style: AppTypography.bodyLStyle(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (note.isPinned)
                                      Icon(
                                        Icons.push_pin,
                                        size: 16,
                                        color: AppColors.electricBluePrimary,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  note.content,
                                  style: AppTypography.bodyMStyle(
                                    color: AppColors.textTertiary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  DateFormat(
                                    'MMM d, y • h:mm a',
                                  ).format(note.createdAt),
                                  style: AppTypography.bodyMStyle(
                                    color: AppColors.textQuaternary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                    const SizedBox(height: AppSpacing.xxl),

                    // Achievements Section
                    Text('Achievements', style: AppTypography.headingLStyle()),
                    const SizedBox(height: AppSpacing.md),

                    SimpleGlassCard(
                      child: Column(
                        children: AchievementsList.all.take(4).map((
                          achievement,
                        ) {
                          final isUnlocked =
                              state.sessions.length >= 1; // Simple logic
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: isUnlocked
                                        ? AppColors.electricBluePrimary
                                              .withOpacity(0.2)
                                        : AppColors.glassBorder,
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusMD,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      achievement.icon,
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: isUnlocked
                                            ? Colors.white
                                            : AppColors.textQuaternary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        achievement.name,
                                        style: AppTypography.bodyLStyle(
                                          color: isUnlocked
                                              ? AppColors.textPrimary
                                              : AppColors.textTertiary,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.xxs),
                                      Text(
                                        achievement.description,
                                        style: AppTypography.bodyMStyle(
                                          color: AppColors.textQuaternary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                if (isUnlocked)
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.successGreen,
                                    size: 20,
                                  )
                                else
                                  Icon(
                                    Icons.lock_outline,
                                    color: AppColors.textQuaternary,
                                    size: 20,
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    // Settings Section
                    Text('Settings', style: AppTypography.headingLStyle()),
                    const SizedBox(height: AppSpacing.md),

                    SimpleGlassCard(
                      child: Column(
                        children: [
                          _buildSettingsItem(
                            icon: Icons.palette_outlined,
                            title: 'Appearance',
                            subtitle: 'Dark mode enabled',
                            onTap: () {},
                          ),
                          _buildSettingsItem(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            subtitle: 'Manage your alerts',
                            onTap: () {},
                          ),
                          _buildSettingsItem(
                            icon: Icons.security_outlined,
                            title: 'Privacy & Security',
                            subtitle: 'Data stays on device',
                            onTap: () {},
                          ),
                          _buildSettingsItem(
                            icon: Icons.download_outlined,
                            title: 'Export Data',
                            subtitle: 'Download as CSV or JSON',
                            onTap: () {},
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    // About Section
                    SimpleGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryButtonGradient,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMD,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    '🎲',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Casino Companion',
                                    style: AppTypography.bodyLStyle(),
                                  ),
                                  const SizedBox(height: AppSpacing.xxs),
                                  Text(
                                    'Version 1.0.0',
                                    style: AppTypography.bodyMStyle(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Know your game. Play smarter.',
                            style: AppTypography.bodyMStyle(
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.electricBluePrimary.withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusSM,
                              ),
                              border: Border.all(
                                color: AppColors.electricBluePrimary
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 20,
                                  color: AppColors.electricBluePrimary,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    'Responsible Gaming: This app is for tracking only. No real-money gambling.',
                                    style: AppTypography.bodyMStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Row(
              children: [
                Icon(icon, size: 24, color: AppColors.electricBluePrimary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.bodyLStyle()),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle,
                        style: AppTypography.bodyMStyle(
                          color: AppColors.textQuaternary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.textQuaternary,
                ),
              ],
            ),
          ),
        ),
        if (showDivider) Divider(height: 1, color: AppColors.glassBorder),
      ],
    );
  }
}
