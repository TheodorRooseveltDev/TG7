import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/premium_theme.dart';
import '../../core/utils/responsive_utils.dart';
import '../../shared/widgets/space_background.dart';
import '../../shared/widgets/add_session_modal.dart';
import '../../providers/app_state.dart';

/// Premium Home Screen with Glassmorphic Design
class PremiumHomeScreen extends StatelessWidget {
  const PremiumHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        forceMaterialTransparency: true,
        title: const Text(''),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              size: ResponsiveUtils.iconSize(context, 24),
            ),
            onPressed: () {},
          ),
          SizedBox(width: ResponsiveUtils.spacing(context, 8)),
        ],
      ),
      body: SpaceBackground(
        child: Consumer<AppState>(
          builder: (context, state, _) {
            return ResponsiveUtils.constrainWidth(
              context,
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: ResponsiveUtils.spacing(context, 90), // Reduced space for tab bar
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Balance Card
                      _buildBalanceSection(context, state),

                      SizedBox(height: ResponsiveUtils.spacing(context, 24)),

                      // Action Buttons
                      _buildActionButtons(context),

                      SizedBox(height: ResponsiveUtils.spacing(context, 24)),

                      // Stats Grid
                      _buildStatsGrid(context, state),

                      SizedBox(height: ResponsiveUtils.spacing(context, 24)),

                      // Recent Sessions
                      _buildRecentSessions(context, state),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// EXACT Main Balance Display with GRADIENT TEXT
  /// Scaled down for responsiveness
  Widget _buildBalanceSection(BuildContext context, AppState state) {
    final totalProfit = state.totalNetProfit;
    final isProfit = totalProfit >= 0;
    final percentage = state.sessions.isEmpty
        ? 0.0
        : (totalProfit / state.initialBankroll * 100);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Padding(
      padding: EdgeInsets.only(
        top: isTablet ? 100 : 80,
        left: ResponsiveUtils.screenHorizontalPadding(context),
        right: ResponsiveUtils.screenHorizontalPadding(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            'Current balance',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, 13),
              fontWeight: FontWeight.w400,
              color: PremiumTheme.textMuted,
              letterSpacing: 0.3,
            ),
          ),

          SizedBox(height: ResponsiveUtils.spacing(context, 6)),

          // Balance Amount with GRADIENT TEXT - scaled down
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    PremiumTheme.balanceTextGradient.createShader(bounds),
                child: Text(
                  '\$${NumberFormat('#,##0').format(state.currentBankroll.toInt())}',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, isTablet ? 48 : 42),
                    fontWeight: FontWeight.w200,
                    letterSpacing: -1.2,
                    color: Colors.white,
                    shadows: PremiumTheme.balanceTextShadow,
                  ),
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) =>
                    PremiumTheme.balanceTextGradient.createShader(bounds),
                child: Text(
                  '.${(state.currentBankroll % 1 * 100).toInt().toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, isTablet ? 26 : 24),
                    fontWeight: FontWeight.w200,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveUtils.spacing(context, 10)),

          // Percentage Badge
          if (state.sessions.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.padding(context, 10),
                vertical: ResponsiveUtils.padding(context, 5),
              ),
              decoration: isProfit
                  ? PremiumTheme.profitBadgeDecoration
                  : PremiumTheme.lossBadgeDecoration,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                    size: ResponsiveUtils.iconSize(context, 10),
                    color: isProfit
                        ? PremiumTheme.successGreen
                        : PremiumTheme.lossRed,
                  ),
                  SizedBox(width: ResponsiveUtils.spacing(context, 4)),
                  Text(
                    '${percentage.abs().toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(context, 12),
                      fontWeight: FontWeight.w500,
                      color: isProfit
                          ? PremiumTheme.successGreen
                          : PremiumTheme.lossRed,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Action Buttons Row (Add Session, View Stats, etc.)
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.screenHorizontalPadding(context),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              context: context,
              icon: Icons.add_rounded,
              label: 'Add Session',
              onTap: () {
                showAddSessionModal(context);
              },
            ),
          ),
          SizedBox(width: ResponsiveUtils.spacing(context, 10)),
          Expanded(
            child: _buildActionButton(
              context: context,
              icon: Icons.assessment_rounded,
              label: 'Statistics',
              onTap: () {
                // TODO: Navigate to stats
              },
            ),
          ),
          SizedBox(width: ResponsiveUtils.spacing(context, 10)),
          Expanded(
            child: _buildActionButton(
              context: context,
              icon: Icons.history_rounded,
              label: 'History',
              onTap: () {
                // TODO: Navigate to history
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Glass Action Buttons - scaled down
  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        height: ResponsiveUtils.cardHeight(context, 44),
        decoration: PremiumTheme.glassActionButton,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: ResponsiveUtils.iconSize(context, 16),
                  color: PremiumTheme.textSecondary,
                ),
                SizedBox(width: ResponsiveUtils.spacing(context, 6)),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, 13),
                    fontWeight: FontWeight.w500,
                    color: PremiumTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Stats Grid (2x2 cards)
  Widget _buildStatsGrid(BuildContext context, AppState state) {
    final columnCount = ResponsiveUtils.gridColumnCount(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.screenHorizontalPadding(context),
      ),
      child: GridView.count(
        crossAxisCount: columnCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: ResponsiveUtils.spacing(context, 10),
        crossAxisSpacing: ResponsiveUtils.spacing(context, 10),
        childAspectRatio: columnCount > 2 ? 1.6 : 2.0, // Increased to fix overflow
        children: [
          _buildStatCard(
            context: context,
            icon: Icons.trending_up_rounded,
            value:
                '\$${NumberFormat('#,##0').format(state.totalNetProfit.abs())}',
            label: state.totalNetProfit >= 0 ? 'Total Profit' : 'Total Loss',
            color: state.totalNetProfit >= 0
                ? PremiumTheme.successGreen
                : PremiumTheme.lossRed,
          ),
          _buildStatCard(
            context: context,
            icon: Icons.casino_rounded,
            value: '${state.sessions.length}',
            label: 'Sessions',
            color: PremiumTheme.primaryBlue,
          ),
          _buildStatCard(
            context: context,
            icon: Icons.percent_rounded,
            value: '${state.winRate.toStringAsFixed(0)}%',
            label: 'Win Rate',
            color: PremiumTheme.primaryBlue,
          ),
          _buildStatCard(
            context: context,
            icon: Icons.access_time_rounded,
            value: state.sessions.isEmpty
                ? '0h'
                : '${(state.averageDuration).toInt()}h',
            label: 'Avg Duration',
            color: PremiumTheme.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: PremiumTheme.glassActionButton,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.padding(context, 12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon and Value in same row
                Row(
                  children: [
                    Container(
                      width: ResponsiveUtils.iconSize(context, 32),
                      height: ResponsiveUtils.iconSize(context, 32),
                      decoration: PremiumTheme.iconContainerDecoration,
                      child: Icon(
                        icon,
                        size: ResponsiveUtils.iconSize(context, 16),
                        color: PremiumTheme.primaryBlue,
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.spacing(context, 8)),
                    Expanded(
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(context, 17),
                          fontWeight: FontWeight.w600,
                          color: PremiumTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveUtils.spacing(context, 6)),

                // Label
                Text(
                  label,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, 12),
                    fontWeight: FontWeight.w500,
                    color: PremiumTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Recent Sessions List
  Widget _buildRecentSessions(BuildContext context, AppState state) {
    if (state.sessions.isEmpty) {
      return _buildEmptyState();
    }

    final recentSessions = state.sessions.take(5).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumTheme.screenHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Text(
            'RECENT SESSIONS',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: PremiumTheme.textTertiary,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 16),

          // Session Items
          ...recentSessions.map((session) => _buildSessionItem(session)),
        ],
      ),
    );
  }

  Widget _buildSessionItem(dynamic session) {
    final isProfit = session.netResult >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: PremiumTheme.glassBox(
        borderRadius: 20,
        customBackground: PremiumTheme.glassBase,
      ),
      child: Row(
        children: [
          // Game Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: _getGameGradient(session.casino),
              borderRadius: BorderRadius.circular(14),
              boxShadow: PremiumTheme.buttonShadow,
            ),
            child: Center(
              child: Text(
                _getGameEmoji(session.casino),
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.casino,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: PremiumTheme.textQuaternary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${session.duration.inHours}h ${session.duration.inMinutes % 60}m',
                  style: TextStyle(
                    fontSize: 13,
                    color: PremiumTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '${isProfit ? '+' : ''}\$${NumberFormat('#,##0').format(session.netResult.abs())}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isProfit
                  ? PremiumTheme.successGreen
                  : PremiumTheme.lossRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumTheme.screenHorizontalPadding,
      ),
      child: Container(
        decoration: PremiumTheme.glassActionButton,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(32),
              child: const Column(
                children: [
                  Icon(
                    Icons.casino_rounded,
                    size: 64,
                    color: PremiumTheme.textQuaternary,
                  ),
            SizedBox(height: 16),
            Text(
              'Start Your Journey',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: PremiumTheme.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Track your first gaming session\nand start building insights',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: PremiumTheme.textTertiary),
            ),
          ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _getGameGradient(String casino) {
    switch (casino.toLowerCase()) {
      case 'bitcoin':
        return PremiumTheme.bitcoinGradient;
      case 'ethereum':
        return PremiumTheme.ethereumGradient;
      default:
        return PremiumTheme.stellarGradient;
    }
  }

  String _getGameEmoji(String casino) {
    switch (casino.toLowerCase()) {
      case 'bitcoin':
        return '🎲';
      case 'ethereum':
        return '🎰';
      case 'poker':
        return '🃏';
      case 'blackjack':
        return '🂡';
      default:
        return '🎯';
    }
  }
}
