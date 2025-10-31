import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/premium_theme.dart';
import '../../core/assets/app_assets.dart';
import '../../shared/widgets/space_background.dart';
import '../../providers/app_state.dart';
import '../../models/session.dart';

/// Complete Home Screen Dashboard
/// Features: Greeting, Last Session, KPIs with Period Selector, Charts, Insights, Recent Notes, FAB
class PremiumHomeScreenV2 extends StatefulWidget {
  const PremiumHomeScreenV2({super.key});

  @override
  State<PremiumHomeScreenV2> createState() => _PremiumHomeScreenV2State();
}

class _PremiumHomeScreenV2State extends State<PremiumHomeScreenV2> {
  String _selectedPeriod = '30d'; // 7d, 30d, YTD, All
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpaceBackground(
        child: Consumer<AppState>(
          builder: (context, state, _) {
            final filteredSessions = _getFilteredSessions(state.sessions);
            
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    
                    // Header: Greeting + Last Session Summary
                    _buildHeader(state),
                    
                    const SizedBox(height: 24),
                    
                    // Period Selector
                    _buildPeriodSelector(),
                    
                    const SizedBox(height: 24),
                    
                    // KPI Cards (4 metrics)
                    _buildKPICards(filteredSessions),
                    
                    const SizedBox(height: 32),
                    
                    // Profit Over Time Chart
                    _buildProfitChart(filteredSessions),
                    
                    const SizedBox(height: 32),
                    
                    // Breakdown by Game (Donut Chart)
                    _buildGameBreakdown(state),
                    
                    const SizedBox(height: 32),
                    
                    // Saved Insights
                    _buildInsightsCards(state),
                    
                    const SizedBox(height: 32),
                    
                    // Recent Notes (Latest 3)
                    _buildRecentNotes(state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Session> _getFilteredSessions(List<Session> sessions) {
    final now = DateTime.now();
    DateTime cutoffDate;
    
    switch (_selectedPeriod) {
      case '7d':
        cutoffDate = now.subtract(const Duration(days: 7));
        break;
      case '30d':
        cutoffDate = now.subtract(const Duration(days: 30));
        break;
      case 'YTD':
        cutoffDate = DateTime(now.year, 1, 1);
        break;
      case 'All':
      default:
        return sessions;
    }
    
    return sessions.where((s) => s.startTime.isAfter(cutoffDate)).toList();
  }

  Widget _buildHeader(AppState state) {
    final currencySymbol = state.preferences.currencySymbol;
    final hour = DateTime.now().hour;
    String greetingTime;
    if (hour < 12) {
      greetingTime = 'Good Morning';
    } else if (hour < 17) {
      greetingTime = 'Good Afternoon';
    } else {
      greetingTime = 'Good Evening';
    }
    
    // Get user name from preferences
    final userName = state.preferences.userName;
    final greeting = '$greetingTime, $userName';
    
    final lastSession = state.sessions.isNotEmpty 
        ? state.sessions.reduce((a, b) => a.startTime.isAfter(b.startTime) ? a : b)
        : null;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PremiumTheme.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                PremiumTheme.balanceTextGradient.createShader(bounds),
            child: Text(
              greeting,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w200,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          if (lastSession != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: PremiumTheme.glassActionButton,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: Image.asset(
                          AppAssets.getGameIcon(lastSession.game),
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last Session: ${lastSession.game}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: PremiumTheme.textPrimary,
                              ),
                            ),
                            Text(
                              '${lastSession.netProfit >= 0 ? '+' : ''}$currencySymbol${lastSession.netProfit.toStringAsFixed(0)} • ${lastSession.formattedDuration}',
                              style: TextStyle(
                                fontSize: 13,
                                color: lastSession.netProfit >= 0 
                                    ? PremiumTheme.successGreen 
                                    : PremiumTheme.lossRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: PremiumTheme.screenHorizontalPadding),
      child: Row(
        children: ['7d', '30d', 'YTD', 'All'].map((period) {
          final isSelected = _selectedPeriod == period;
          return GestureDetector(
            onTap: () => setState(() => _selectedPeriod = period),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: isSelected
                  ? PremiumTheme.gradientButtonDecoration
                  : PremiumTheme.glassActionButton,
              child: Text(
                period,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : PremiumTheme.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKPICards(List<Session> sessions) {
    final currencySymbol = context.read<AppState>().preferences.currencySymbol;
    final netProfit = sessions.fold<double>(0, (sum, s) => sum + s.netProfit);
    final sessionsCount = sessions.length;
    final avgDuration = sessions.isEmpty
        ? 0.0
        : sessions.fold<double>(0, (sum, s) => sum + s.durationInHours) / sessions.length;
    final winRate = sessions.isEmpty
        ? 0.0
        : sessions.where((s) => s.netProfit > 0).length / sessions.length * 100;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PremiumTheme.screenHorizontalPadding),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4, // Increased from 1.1 to make cards shorter
        children: [
          _buildKPICardWithIcon(
            'Net Profit',
            '${netProfit >= 0 ? '+' : ''}$currencySymbol${netProfit.abs().toStringAsFixed(0)}',
            AppAssets.bigWinBadge,
            netProfit >= 0 ? PremiumTheme.successGreen : PremiumTheme.lossRed,
          ),
          _buildKPICardWithIcon(
            'Sessions',
            '$sessionsCount',
            AppAssets.sessionIcon,
            PremiumTheme.primaryBlue,
          ),
          _buildKPICardWithIcon(
            'Avg Duration',
            '${avgDuration.toStringAsFixed(1)}h',
            AppAssets.disciplineMasterBadge,
            PremiumTheme.gradientPurple,
          ),
          _buildKPICardWithIcon(
            'Win Rate',
            '${winRate.toStringAsFixed(0)}%',
            AppAssets.firstWinBadge,
            PremiumTheme.successGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildKPICardWithIcon(String label, String value, String iconPath, Color color) {
    return Container(
      decoration: PremiumTheme.glassActionButton,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(14), // Reduced from 16 to 14
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // Changed from spaceBetween to center
              children: [
                // Icon in small circular container
                Container(
                  width: 36, // Smaller circular container
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      iconPath,
                      color: color,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Reduced spacing
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 22, // Slightly smaller from 24
                        fontWeight: FontWeight.w600,
                        color: PremiumTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2), // Reduced from 4 to 2
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11, // Slightly smaller from 12
                        color: PremiumTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfitChart(List<Session> sessions) {
    final currencySymbol = context.read<AppState>().preferences.currencySymbol;
    if (sessions.isEmpty) {
      return _buildEmptyChart('No data for selected period');
    }
    
    final sortedSessions = List<Session>.from(sessions)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    
    double cumulative = 0;
    final spots = <FlSpot>[];
    
    for (var i = 0; i < sortedSessions.length; i++) {
      cumulative += sortedSessions[i].netProfit;
      spots.add(FlSpot(i.toDouble(), cumulative));
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PremiumTheme.screenHorizontalPadding),
      child: Container(
        decoration: PremiumTheme.glassActionButton,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profit Over Time',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: PremiumTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, top: 16, bottom: 8),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: spots.isNotEmpty 
                              ? () {
                                  final maxVal = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b).abs();
                                  final minVal = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b).abs();
                                  final range = (maxVal + minVal);
                                  // Ensure at least 4 grid lines with minimum spacing
                                  return (range / 4).clamp(100.0, double.infinity).toDouble();
                                }()
                              : 100.0,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: PremiumTheme.borderGlass,
                                strokeWidth: 1,
                              );
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
                                reservedSize: 55,
                                interval: spots.isNotEmpty 
                                  ? () {
                                      final maxVal = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b).abs();
                                      final minVal = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b).abs();
                                      final range = (maxVal + minVal);
                                      // Ensure at least 4 labels with minimum spacing
                                      return (range / 4).clamp(100.0, double.infinity).toDouble();
                                    }()
                                  : null,
                                getTitlesWidget: (value, meta) {
                                  // Format large numbers with k/M suffix
                                  String formattedValue;
                                  if (value.abs() >= 1000000) {
                                    formattedValue = '$currencySymbol${(value / 1000000).toStringAsFixed(1)}M';
                                  } else if (value.abs() >= 10000) {
                                    formattedValue = '$currencySymbol${(value / 1000).toStringAsFixed(0)}k';
                                  } else if (value.abs() >= 1000) {
                                    formattedValue = '$currencySymbol${(value / 1000).toStringAsFixed(1)}k';
                                  } else {
                                    formattedValue = '$currencySymbol${value.toInt()}';
                                  }
                                  
                                  return Text(
                                    formattedValue,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: PremiumTheme.textQuaternary,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: spots.length > 4 
                                  ? (spots.length / 4).ceil().toDouble()
                                  : 1,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >= sortedSessions.length) {
                                    return const SizedBox.shrink();
                                  }
                                  final session = sortedSessions[value.toInt()];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      DateFormat('M/d').format(session.startTime),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: PremiumTheme.textQuaternary,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minY: spots.isNotEmpty 
                            ? spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) * 1.2
                            : 0,
                          maxY: spots.isNotEmpty 
                            ? spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.2
                            : 100,
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              gradient: PremiumTheme.bluePurpleGradient,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: PremiumTheme.primaryBlue,
                                    strokeWidth: 2,
                                    strokeColor: PremiumTheme.deepNavyCenter,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    PremiumTheme.primaryBlue.withOpacity(0.3),
                                    PremiumTheme.primaryBlue.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameBreakdown(AppState state) {
    final currencySymbol = state.preferences.currencySymbol;
    if (state.profitByGame.isEmpty) {
      return _buildEmptyChart('Play some games to see breakdown');
    }
    
    final sortedGames = state.profitByGame.entries.toList()
      ..sort((a, b) => b.value.abs().compareTo(a.value.abs()));
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PremiumTheme.screenHorizontalPadding),
      child: Container(
        decoration: PremiumTheme.glassActionButton,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Breakdown by Game',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: PremiumTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...sortedGames.take(5).map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Image.asset(
                                AppAssets.getGameIcon(entry.key),
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: PremiumTheme.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              '${entry.value >= 0 ? '+' : ''}$currencySymbol${entry.value.abs().toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: entry.value >= 0
                                    ? PremiumTheme.successGreen
                                    : PremiumTheme.lossRed,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightsCards(AppState state) {
    final insights = _generateInsights(state);
    
    if (insights.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PremiumTheme.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Insights',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: PremiumTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...insights.map((insight) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: PremiumTheme.glassActionButton,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: PremiumTheme.bluePurpleGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            insight,
                            style: const TextStyle(
                              fontSize: 14,
                              color: PremiumTheme.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRecentNotes(AppState state) {
    final recentNotes = state.notes.take(3).toList();
    
    if (recentNotes.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PremiumTheme.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Notes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: PremiumTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...recentNotes.map((note) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: PremiumTheme.glassActionButton,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: PremiumTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          note.content,
                          style: const TextStyle(
                            fontSize: 14,
                            color: PremiumTheme.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('MMM d, y').format(note.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: PremiumTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildEmptyChart(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PremiumTheme.screenHorizontalPadding),
      child: Container(
        height: 200,
        decoration: PremiumTheme.glassActionButton,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Center(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: PremiumTheme.textTertiary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> _generateInsights(AppState state) {
    final currencySymbol = state.preferences.currencySymbol;
    final insights = <String>[];
    
    if (state.profitByGame.isNotEmpty) {
      final best = state.profitByGame.entries.reduce((a, b) => a.value > b.value ? a : b);
      if (best.value > 0) {
        insights.add('Most profitable: ${best.key} (avg +$currencySymbol${best.value.toStringAsFixed(0)})');
      }
    }
    
    if (state.sessions.length >= 5) {
      final recentSessions = state.sessions.take(5).toList();
      final avgProfit = recentSessions.fold<double>(0, (sum, s) => sum + s.netProfit) / 5;
      if (avgProfit > 0) {
        insights.add('You\'re on a roll! Last 5 sessions averaged +$currencySymbol${avgProfit.toStringAsFixed(0)}');
      }
    }
    
    return insights;
  }
}
