import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../models/session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_button.dart' as custom;

/// Filter bottom sheet for sessions
class SessionFilterBar extends StatefulWidget {
  final String? selectedGame;
  final bool showWinsOnly;
  final bool showLossesOnly;
  final Function(String?) onGameSelected;
  final Function(bool) onWinsOnlyChanged;
  final Function(bool) onLossesOnlyChanged;

  const SessionFilterBar({
    Key? key,
    this.selectedGame,
    required this.showWinsOnly,
    required this.showLossesOnly,
    required this.onGameSelected,
    required this.onWinsOnlyChanged,
    required this.onLossesOnlyChanged,
  }) : super(key: key);

  @override
  State<SessionFilterBar> createState() => _SessionFilterBarState();
}

class _SessionFilterBarState extends State<SessionFilterBar> {
  late String? _selectedGame;
  late bool _showWinsOnly;
  late bool _showLossesOnly;

  @override
  void initState() {
    super.initState();
    _selectedGame = widget.selectedGame;
    _showWinsOnly = widget.showWinsOnly;
    _showLossesOnly = widget.showLossesOnly;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXL),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXL),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.glassBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Sessions',
                          style: AppTypography.headingLStyle(),
                        ),
                        custom.IconButtonCustom(
                          icon: Icons.close_rounded,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Game type filter
                    Text('Game Type', style: AppTypography.headingSStyle()),
                    const SizedBox(height: AppSpacing.md),

                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        _buildGameChip(null, 'All Games'),
                        ...GameType.all.map(
                          (game) => _buildGameChip(game, game),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Result filter
                    Text('Results', style: AppTypography.headingSStyle()),
                    const SizedBox(height: AppSpacing.md),

                    _buildCheckboxTile(
                      title: 'Wins Only',
                      value: _showWinsOnly,
                      onChanged: (value) {
                        setState(() {
                          _showWinsOnly = value ?? false;
                          if (_showWinsOnly) _showLossesOnly = false;
                        });
                      },
                    ),

                    _buildCheckboxTile(
                      title: 'Losses Only',
                      value: _showLossesOnly,
                      onChanged: (value) {
                        setState(() {
                          _showLossesOnly = value ?? false;
                          if (_showLossesOnly) _showWinsOnly = false;
                        });
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: custom.CustomButton(
                            text: 'Clear All',
                            style: custom.ButtonStyle.outline,
                            onPressed: () {
                              setState(() {
                                _selectedGame = null;
                                _showWinsOnly = false;
                                _showLossesOnly = false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: custom.CustomButton(
                            text: 'Apply',
                            style: custom.ButtonStyle.primary,
                            onPressed: () {
                              widget.onGameSelected(_selectedGame);
                              widget.onWinsOnlyChanged(_showWinsOnly);
                              widget.onLossesOnlyChanged(_showLossesOnly);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameChip(String? game, String label) {
    final isSelected = _selectedGame == game;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGame = game;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.electricBluePrimary
              : AppColors.glassBorder,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          border: isSelected
              ? null
              : Border.all(color: AppColors.glassBorder, width: 1),
        ),
        child: Text(
          label,
          style: AppTypography.bodyMStyle(
            color: isSelected ? AppColors.textPrimary : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: value
              ? AppColors.electricBluePrimary.withOpacity(0.15)
              : AppColors.glassBorder,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          border: Border.all(
            color: value
                ? AppColors.electricBluePrimary.withOpacity(0.3)
                : AppColors.glassBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: value
                    ? AppColors.electricBluePrimary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value
                      ? AppColors.electricBluePrimary
                      : AppColors.textQuaternary,
                  width: 2,
                ),
              ),
              child: value
                  ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: AppColors.textPrimary,
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              title,
              style: AppTypography.bodyLStyle(
                color: value
                    ? AppColors.electricBluePrimary
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
