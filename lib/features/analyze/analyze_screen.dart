import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/gradient_orb.dart';
import '../../shared/widgets/glass_card.dart';
import '../../providers/app_state.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({Key? key}) : super(key: key);

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  String _selectedPeriod = '30d';

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
                    // Header
                    Text('Analytics', style: AppTypography.headingXLStyle()),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Insights from your gaming sessions',
                      style: AppTypography.bodyMStyle(
                        color: AppColors.textTertiary,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Period selector
                    _buildPeriodSelector(),

                    const SizedBox(height: AppSpacing.xl),

                    // Profit over time chart
                    Text(
                      'Profit Over Time',
                      style: AppTypography.headingLStyle(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildProfitChart(state),

                    const SizedBox(height: AppSpacing.xxl),

                    // Overview Stats
                    _buildOverviewStats(state),

                    const SizedBox(height: AppSpacing.xxl),

                    // Game breakdown
                    Text(
                      'Profit by Game',
                      style: AppTypography.headingLStyle(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildGameBreakdown(state),

                    const SizedBox(height: AppSpacing.xxl),

                    // Game distribution pie chart
                    Text(
                      'Sessions by Game',
                      style: AppTypography.headingLStyle(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildGameDistributionChart(state),

                    const SizedBox(height: AppSpacing.xxl),

                    // Win rate by game
                    Text(
                      'Win Rate by Game',
                      style: AppTypography.headingLStyle(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildWinRateChart(state),

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

  Widget _buildPeriodSelector() {
    final periods = ['7d', '30d', 'YTD', 'All'];

    return Row(
      children: periods.map((period) {
        final isSelected = _selectedPeriod == period;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedPeriod = period;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: AppSpacing.xs),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
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
                period,
                style: AppTypography.bodyMStyle(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProfitChart(AppState state) {
    if (state.sessions.isEmpty) {
      return _buildEmptyChart('No data to display');
    }

    // Get cumulative profit data
    final sortedSessions = List.from(state.sessions)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    double cumulativeProfit = 0;
    final spots = <FlSpot>[];

    for (var i = 0; i < sortedSessions.length; i++) {
      cumulativeProfit += sortedSessions[i].netProfit;
      spots.add(FlSpot(i.toDouble(), cumulativeProfit));
    }

    return SimpleGlassCard(
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Padding(
          padding: const EdgeInsets.only(
            right: AppSpacing.md,
            top: AppSpacing.md,
            bottom: AppSpacing.sm,
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: cumulativeProfit.abs() / 5,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: AppColors.glassBorder, strokeWidth: 1);
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '\$${value.toInt()}',
                        style: AppTypography.bodyXSStyle(
                          color: AppColors.textQuaternary,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (spots.length / 4).ceil().toDouble(),
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= sortedSessions.length) {
                        return const SizedBox.shrink();
                      }
                      final session = sortedSessions[value.toInt()];
                      return Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xs),
                        child: Text(
                          DateFormat('M/d').format(session.startTime),
                          style: AppTypography.bodyXXSStyle(
                            color: AppColors.textQuaternary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minY: spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) * 1.2,
              maxY: spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.2,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  gradient: AppColors.primaryButtonGradient,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.electricBluePrimary,
                        strokeWidth: 2,
                        strokeColor: AppColors.primaryBackground,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.electricBluePrimary.withOpacity(0.3),
                        AppColors.electricBluePrimary.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewStats(AppState state) {
    return Row(
      children: [
        Expanded(
          child: SimpleGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Sessions',
                  style: AppTypography.bodyMStyle(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${state.sessions.length}',
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
                  'Avg Session',
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
    );
  }

  Widget _buildGameBreakdown(AppState state) {
    if (state.profitByGame.isEmpty) {
      return _buildEmptyChart('No games played yet');
    }

    final sortedGames = state.profitByGame.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxProfit = sortedGames.first.value.abs();

    return SimpleGlassCard(
      child: Column(
        children: sortedGames.map((entry) {
          final percentage = maxProfit > 0
              ? (entry.value.abs() / maxProfit)
              : 0.0;
          final isPositive = entry.value >= 0;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          _getGameEmoji(entry.key),
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(entry.key, style: AppTypography.bodyLStyle()),
                      ],
                    ),
                    Text(
                      NumberFormat.currency(
                        symbol: '\$',
                        decimalDigits: 0,
                      ).format(entry.value),
                      style: AppTypography.headingSStyle(
                        color: AppColors.getStatusColor(isPositive),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXS),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 8,
                    backgroundColor: AppColors.glassBorder,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.getGameColor(entry.key),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGameDistributionChart(AppState state) {
    if (state.sessions.isEmpty) {
      return _buildEmptyChart('No sessions yet');
    }

    // Count sessions by game
    final gameCount = <String, int>{};
    for (final session in state.sessions) {
      gameCount[session.game] = (gameCount[session.game] ?? 0) + 1;
    }

    final sections = gameCount.entries.map((entry) {
      final percentage = (entry.value / state.sessions.length * 100);
      return PieChartSectionData(
        color: AppColors.getGameColor(entry.key),
        value: entry.value.toDouble(),
        title: '${percentage.toInt()}%',
        radius: 100,
        titleStyle: AppTypography.bodyMStyle(color: AppColors.textPrimary),
      );
    }).toList();

    return SimpleGlassCard(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 0,
                sectionsSpace: 2,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...gameCount.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.getGameColor(entry.key),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    _getGameEmoji(entry.key),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(entry.key, style: AppTypography.bodyMStyle()),
                  const Spacer(),
                  Text(
                    '${entry.value} sessions',
                    style: AppTypography.bodyMStyle(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildWinRateChart(AppState state) {
    if (state.sessions.isEmpty) {
      return _buildEmptyChart('No data available');
    }

    // Calculate win rate by game
    final gameStats = <String, Map<String, int>>{};
    for (final session in state.sessions) {
      gameStats.putIfAbsent(session.game, () => {'wins': 0, 'losses': 0});
      if (session.isWin) {
        gameStats[session.game]!['wins'] =
            gameStats[session.game]!['wins']! + 1;
      } else {
        gameStats[session.game]!['losses'] =
            gameStats[session.game]!['losses']! + 1;
      }
    }

    return SimpleGlassCard(
      child: Column(
        children: gameStats.entries.map((entry) {
          final wins = entry.value['wins']!;
          final losses = entry.value['losses']!;
          final total = wins + losses;
          final winRate = (wins / total * 100).toInt();

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          _getGameEmoji(entry.key),
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(entry.key, style: AppTypography.bodyLStyle()),
                      ],
                    ),
                    Text(
                      '$winRate%',
                      style: AppTypography.headingSStyle(
                        color: winRate >= 50
                            ? AppColors.successGreen
                            : AppColors.errorRed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      flex: wins,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.successGreen,
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(AppSpacing.radiusXS),
                          ),
                        ),
                      ),
                    ),
                    if (losses > 0)
                      Expanded(
                        flex: losses,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.errorRed,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(AppSpacing.radiusXS),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$wins wins',
                      style: AppTypography.bodyXSStyle(
                        color: AppColors.textQuaternary,
                      ),
                    ),
                    Text(
                      '$losses losses',
                      style: AppTypography.bodyXSStyle(
                        color: AppColors.textQuaternary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyChart(String message) {
    return SimpleGlassCard(
      child: Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          message,
          style: AppTypography.bodyMStyle(color: AppColors.textTertiary),
        ),
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
