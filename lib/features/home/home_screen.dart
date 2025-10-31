import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_orb.dart';
import '../../providers/app_state.dart';

/// Home/Dashboard screen - fully dynamic with real user data
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
                    // Greeting
                    Text(
                      _getGreeting(state.preferences.userName),
                      style: AppTypography.headingXLStyle(),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      state.sessions.isEmpty
                          ? 'Ready to track your first session?'
                          : 'Here\'s your gaming overview',
                      style: AppTypography.bodyMStyle(
                        color: AppColors.textTertiary,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // KPIs or Empty State
                    if (state.sessions.isNotEmpty)
                      _buildKPISection(state)
                    else
                      _buildEmptyState(),

                    const SizedBox(height: AppSpacing.xxl),

                    // Recent Sessions
                    if (state.sessions.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Sessions',
                            style: AppTypography.headingLStyle(),
                          ),
                          Text(
                            '${state.sessions.length} total',
                            style: AppTypography.bodyMStyle(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...state.sessions.take(3).map((session) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: SimpleGlassCard(
                            child: Row(
                              children: [
                                Text(
                                  _getGameEmoji(session.game),
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        session.game,
                                        style: AppTypography.bodyLStyle(),
                                      ),
                                      const SizedBox(height: AppSpacing.xxs),
                                      Text(
                                        '${session.location} • ${DateFormat('MMM d').format(session.startTime)}',
                                        style: AppTypography.bodyMStyle(
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  NumberFormat.currency(
                                    symbol: '\$',
                                    decimalDigits: 0,
                                  ).format(session.netProfit),
                                  style: AppTypography.headingSStyle(
                                    color: AppColors.getStatusColor(
                                      session.isWin,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: AppSpacing.xl),
                    ],

                    // Recent Notes
                    if (state.notes.isNotEmpty) ...[
                      Text(
                        'Recent Notes',
                        style: AppTypography.headingLStyle(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...state.notes.take(2).map((note) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: SimpleGlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (note.isPinned)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: AppSpacing.xs,
                                        ),
                                        child: Icon(
                                          Icons.push_pin,
                                          size: 16,
                                          color: AppColors.electricBluePrimary,
                                        ),
                                      ),
                                    Expanded(
                                      child: Text(
                                        note.title,
                                        style: AppTypography.bodyLStyle(),
                                      ),
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
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],

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

  Widget _buildKPISection(AppState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SimpleGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Net Profit',
                      style: AppTypography.bodyMStyle(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      NumberFormat.currency(
                        symbol: '\$',
                        decimalDigits: 0,
                      ).format(state.totalNetProfit),
                      style: AppTypography.displayMStyle(
                        color: AppColors.getStatusColor(
                          state.totalNetProfit >= 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: SimpleGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Win Rate',
                      style: AppTypography.bodyMStyle(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${state.winRate.toStringAsFixed(0)}%',
                      style: AppTypography.displayMStyle(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: SimpleGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sessions',
                      style: AppTypography.bodyMStyle(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${state.totalSessions}',
                      style: AppTypography.displayMStyle(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: SimpleGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Avg Duration',
                      style: AppTypography.bodyMStyle(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${state.averageDuration.toStringAsFixed(1)}h',
                      style: AppTypography.displayMStyle(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return SimpleGlassCard(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryButtonGradient,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
            ),
            child: const Center(
              child: Text('🎰', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Start Your Journey', style: AppTypography.headingMStyle()),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tap the + button below to log your first casino session',
            style: AppTypography.bodyMStyle(color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEmptyFeature(Icons.timer_outlined, 'Track Time'),
              _buildEmptyFeature(Icons.attach_money, 'Log Profits'),
              _buildEmptyFeature(Icons.trending_up, 'See Trends'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFeature(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: AppColors.electricBluePrimary),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.bodyMStyle(color: AppColors.textQuaternary),
        ),
      ],
    );
  }

  String _getGreeting(String userName) {
    final hour = DateTime.now().hour;
    String timeGreeting;

    if (hour < 12) {
      timeGreeting = 'Good Morning';
    } else if (hour < 17) {
      timeGreeting = 'Good Afternoon';
    } else {
      timeGreeting = 'Good Evening';
    }

    return '$timeGreeting, $userName';
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
