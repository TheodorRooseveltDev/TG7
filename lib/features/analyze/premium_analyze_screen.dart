import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/theme/premium_theme.dart';
import '../../core/assets/app_assets.dart';
import '../../shared/widgets/space_background.dart';
import '../../providers/app_state.dart';

class PremiumAnalyzeScreen extends StatefulWidget {
  const PremiumAnalyzeScreen({Key? key}) : super(key: key);

  @override
  State<PremiumAnalyzeScreen> createState() => _PremiumAnalyzeScreenState();
}

class _PremiumAnalyzeScreenState extends State<PremiumAnalyzeScreen> {
  String _selectedPeriod = '30d';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        forceMaterialTransparency: true,
        title: const Text(''),
      ),
      body: SpaceBackground(
        child: Consumer<AppState>(
          builder: (context, state, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 110, // Space for floating tab bar
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 80,
                        left: PremiumTheme.screenHorizontalPadding,
                        right: PremiumTheme.screenHorizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Analytics',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: PremiumTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Insights from your gaming sessions',
                            style: TextStyle(
                              fontSize: 14,
                              color: PremiumTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Period selector
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PremiumTheme.screenHorizontalPadding,
                      ),
                      child: _buildPeriodSelector(),
                    ),

                    const SizedBox(height: 32),

                    // Profit chart
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PremiumTheme.screenHorizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profit Over Time',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: PremiumTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildProfitChart(state),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Overview Stats
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PremiumTheme.screenHorizontalPadding,
                      ),
                      child: _buildOverviewStats(state),
                    ),

                    const SizedBox(height: 32),

                    // Game breakdown
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PremiumTheme.screenHorizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profit by Game',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: PremiumTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildGameBreakdown(state),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
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
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: isSelected
                  ? PremiumTheme.gradientButtonDecoration
                  : PremiumTheme.glassActionButton,
              child: Text(
                period,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : PremiumTheme.textSecondary,
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
    final currencySymbol = state.preferences.currencySymbol;
    if (state.sessions.isEmpty) {
      return _buildEmptyChart('No data to display');
    }

    // Filter sessions based on selected period
    final now = DateTime.now();
    final filteredSessions = state.sessions.where((session) {
      switch (_selectedPeriod) {
        case '7d':
          return session.startTime.isAfter(now.subtract(const Duration(days: 7)));
        case '30d':
          return session.startTime.isAfter(now.subtract(const Duration(days: 30)));
        case 'YTD':
          return session.startTime.year == now.year;
        case 'All':
        default:
          return true;
      }
    }).toList();

    if (filteredSessions.isEmpty) {
      return _buildEmptyChart('No data for selected period');
    }

    final sortedSessions = List.from(filteredSessions)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    double cumulativeProfit = 0;
    final spots = <FlSpot>[];

    for (var i = 0; i < sortedSessions.length; i++) {
      cumulativeProfit += sortedSessions[i].netProfit;
      spots.add(FlSpot(i.toDouble(), cumulativeProfit));
    }

    return Container(
      decoration: PremiumTheme.glassActionButton,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
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
                        style: TextStyle(
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
                    interval: (spots.length / 4).ceil().toDouble(),
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= sortedSessions.length) {
                        return const SizedBox.shrink();
                      }
                      final session = sortedSessions[value.toInt()];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('M/d').format(session.startTime),
                          style: TextStyle(
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
              minY: spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) * 1.2,
              maxY: spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.2,
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
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewStats(AppState state) {
    // Filter sessions based on selected period
    final now = DateTime.now();
    final filteredSessions = state.sessions.where((session) {
      switch (_selectedPeriod) {
        case '7d':
          return session.startTime.isAfter(now.subtract(const Duration(days: 7)));
        case '30d':
          return session.startTime.isAfter(now.subtract(const Duration(days: 30)));
        case 'YTD':
          return session.startTime.year == now.year;
        case 'All':
        default:
          return true;
      }
    }).toList();

    // Calculate average duration for filtered sessions
    double avgDuration = 0;
    if (filteredSessions.isNotEmpty) {
      final totalMinutes = filteredSessions.fold<int>(
        0,
        (sum, session) => sum + session.duration.inMinutes,
      );
      avgDuration = (totalMinutes / filteredSessions.length) / 60.0;
    }

    return Row(
      children: [
        Expanded(
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
                      Text(
                        'Total Sessions',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: PremiumTheme.textSecondary,
                        ),
                      ),
                const SizedBox(height: 8),
                Text(
                  '${filteredSessions.length}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: PremiumTheme.textPrimary,
                  ),
                ),
              ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
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
                      Text(
                        'Avg Session',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                    color: PremiumTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${avgDuration.toStringAsFixed(1)}h',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: PremiumTheme.textPrimary,
                  ),
                ),
              ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameBreakdown(AppState state) {
    final currencySymbol = state.preferences.currencySymbol;
    // Filter sessions based on selected period
    final now = DateTime.now();
    final filteredSessions = state.sessions.where((session) {
      switch (_selectedPeriod) {
        case '7d':
          return session.startTime.isAfter(now.subtract(const Duration(days: 7)));
        case '30d':
          return session.startTime.isAfter(now.subtract(const Duration(days: 30)));
        case 'YTD':
          return session.startTime.year == now.year;
        case 'All':
        default:
          return true;
      }
    }).toList();

    // Calculate profit by game for filtered sessions
    final Map<String, double> profitByGame = {};
    for (var session in filteredSessions) {
      profitByGame[session.game] = 
          (profitByGame[session.game] ?? 0) + session.netProfit;
    }

    if (profitByGame.isEmpty) {
      return _buildEmptyChart('No games played yet');
    }

    final sortedGames = profitByGame.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxProfit = sortedGames.first.value.abs();

    return Container(
      decoration: PremiumTheme.glassActionButton,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: sortedGames.map((entry) {
          final percentage = maxProfit > 0
              ? (entry.value.abs() / maxProfit)
              : 0.0;
          final isPositive = entry.value >= 0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset(
                            AppAssets.getGameIcon(entry.key),
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: PremiumTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      NumberFormat.currency(
                        symbol: currencySymbol,
                        decimalDigits: 0,
                      ).format(entry.value),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isPositive
                            ? PremiumTheme.successGreen
                            : PremiumTheme.lossRed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 8,
                    backgroundColor: PremiumTheme.borderGlass,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isPositive
                          ? PremiumTheme.successGreen
                          : PremiumTheme.lossRed,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChart(String message) {
    return Container(
      height: 200,
      decoration: PremiumTheme.glassActionButton,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Text(
              message,
              style: TextStyle(fontSize: 14, color: PremiumTheme.textTertiary),
            ),
          ),
        ),
      ),
    );
  }
}
