import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/glass_card.dart';

/// List item widget for displaying a session
class SessionListItem extends StatelessWidget {
  final Session session;
  final VoidCallback onTap;

  const SessionListItem({Key? key, required this.session, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return GlassCard(
      enableHoverEffect: true,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.listItemPaddingVertical),
      child: Column(
        children: [
          Row(
            children: [
              // Game icon
              Container(
                width: AppSpacing.assetIconMD,
                height: AppSpacing.assetIconMD,
                decoration: BoxDecoration(
                  gradient: AppColors.getGameGradient(session.game),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                ),
                child: Center(
                  child: Text(
                    _getGameEmoji(session.game),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Session info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.game, style: AppTypography.headingSStyle()),
                    const SizedBox(height: AppSpacing.xxxs),
                    Text(
                      session.location,
                      style: AppTypography.bodyMStyle(
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Net profit
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat.format(session.netProfit),
                    style: AppTypography.headingSStyle(
                      color: AppColors.getStatusColor(session.isWin),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxs),
                  Text(
                    session.formattedDuration,
                    style: AppTypography.bodyXSStyle(
                      color: AppColors.textQuaternary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Date and tags
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 12,
                color: AppColors.textQuaternary,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${dateFormat.format(session.startTime)} at ${timeFormat.format(session.startTime)}',
                style: AppTypography.bodyXSStyle(
                  color: AppColors.textQuaternary,
                ),
              ),
              if (session.tags.isNotEmpty) ...[
                const Spacer(),
                ...session.tags
                    .take(2)
                    .map(
                      (tag) => Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.xxs),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: AppSpacing.xxxs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.electricBluePrimary.withOpacity(
                              0.15,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusXS,
                            ),
                          ),
                          child: Text(
                            '#$tag',
                            style: AppTypography.bodyXXSStyle(
                              color: AppColors.electricBluePrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
              ],
            ],
          ),

          // Notes preview if available
          if (session.notes != null && session.notes!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.glassBorder,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.note_outlined,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      session.notes!,
                      style: AppTypography.bodyXSStyle(
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  String _getGameEmoji(String game) {
    switch (game) {
      case 'Slots':
        return '🎰';
      case 'Blackjack':
        return '🃏';
      case 'Poker':
        return '♠️';
      case 'Roulette':
        return '🎡';
      case 'Craps':
        return '🎲';
      default:
        return '🎮';
    }
  }
}
