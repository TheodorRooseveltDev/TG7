import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_orb.dart';

/// Home/Dashboard screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: GradientOrbBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenMarginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting header
                Text('Welcome back!', style: AppTypography.headingXLStyle()),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Here\'s your casino activity',
                  style: AppTypography.bodyMStyle(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Balance card
                GlassCard(
                  enableHoverEffect: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Profit',
                        style: AppTypography.bodySStyle(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$',
                            style: AppTypography.displayLStyle().copyWith(
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Text('1,245', style: AppTypography.displayXLStyle()),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '.80',
                            style: AppTypography.displayLStyle().copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.getStatusBackground(true),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusXS,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_upward_rounded,
                              size: 12,
                              color: AppColors.successGreen,
                            ),
                            const SizedBox(width: AppSpacing.xxxs),
                            Text(
                              '+12.5%',
                              style: AppTypography.badgeStyle(
                                color: AppColors.successGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // KPIs section
                Text('Last 30 Days', style: AppTypography.headingSStyle()),
                const SizedBox(height: AppSpacing.md),

                Row(
                  children: [
                    Expanded(
                      child: _KPICard(
                        title: 'Sessions',
                        value: '24',
                        icon: Icons.casino_rounded,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _KPICard(
                        title: 'Win Rate',
                        value: '58%',
                        icon: Icons.trending_up_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                Row(
                  children: [
                    Expanded(
                      child: _KPICard(
                        title: 'Avg Duration',
                        value: '2.5h',
                        icon: Icons.access_time_rounded,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _KPICard(
                        title: 'Best Game',
                        value: 'Poker',
                        icon: Icons.star_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // Charts placeholder
                Text('Profit Over Time', style: AppTypography.headingSStyle()),
                const SizedBox(height: AppSpacing.md),

                SimpleGlassCard(
                  child: Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: Text(
                      'Chart Coming Soon',
                      style: AppTypography.bodyMStyle(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxxl * 2), // Space for FAB
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KPICard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _KPICard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleGlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.electricBluePrimary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                ),
                child: Icon(
                  icon,
                  size: AppSpacing.iconSM,
                  color: AppColors.electricBluePrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.displaySStyle()),
          const SizedBox(height: AppSpacing.xxxs),
          Text(
            title,
            style: AppTypography.bodyXSStyle(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
