import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/premium_theme.dart';
import '../../core/assets/app_assets.dart';
import '../../shared/widgets/space_background.dart';
import '../../providers/app_state.dart';
import '../../models/session.dart';

/// Premium Sessions Screen with Glass Design
class PremiumSessionsScreen extends StatefulWidget {
  const PremiumSessionsScreen({super.key});

  @override
  State<PremiumSessionsScreen> createState() => _PremiumSessionsScreenState();
}

class _PremiumSessionsScreenState extends State<PremiumSessionsScreen> {
  String _searchQuery = '';
  String _filterGame = 'All';
  String _filterResult = 'All'; // All, Win, Loss
  
  final List<String> _games = [
    'All',
    'Slots',
    'Blackjack',
    'Poker',
    'Roulette',
    'Craps',
    'Baccarat',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    
    // Filter sessions
    var filteredSessions = state.sessions.where((session) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!session.location.toLowerCase().contains(query) &&
            !session.game.toLowerCase().contains(query) &&
            !(session.notes?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }
      
      // Game filter
      if (_filterGame != 'All' && session.game != _filterGame) {
        return false;
      }
      
      // Result filter
      if (_filterResult == 'Win' && session.netProfit <= 0) return false;
      if (_filterResult == 'Loss' && session.netProfit > 0) return false;
      
      return true;
    }).toList();
    
    // Sort by date descending
    filteredSessions.sort((a, b) => b.startTime.compareTo(a.startTime));

    return Scaffold(
      body: SpaceBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(state),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 12),
              _buildFilters(),
              const SizedBox(height: 16),
              Expanded(
                child: filteredSessions.isEmpty
                    ? _buildEmptyState()
                    : _buildSessionsList(filteredSessions),
              ),
              const SizedBox(height: 100), // Space for FAB and tab bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumTheme.screenHorizontalPadding,
        vertical: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      PremiumTheme.balanceTextGradient.createShader(bounds),
                  child: const Text(
                    'Sessions',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.sessions.length} total sessions',
                  style: const TextStyle(
                    fontSize: 14,
                    color: PremiumTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildBulkActionsButton(state),
        ],
      ),
    );
  }

  Widget _buildBulkActionsButton(AppState state) {
    if (state.sessions.isEmpty) return const SizedBox.shrink();
    
    return Container(
      decoration: PremiumTheme.glassActionButton,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: IconButton(
            icon: const Icon(Icons.more_vert, color: PremiumTheme.textSecondary),
            onPressed: () => _showBulkActions(context),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
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
            child: TextField(
              style: const TextStyle(
                fontSize: 16,
                color: PremiumTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search sessions...',
                hintStyle: const TextStyle(color: PremiumTheme.textQuaternary),
                prefixIcon: const Icon(
                  Icons.search,
                  color: PremiumTheme.textSecondary,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: PremiumTheme.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumTheme.screenHorizontalPadding,
      ),
      child: Row(
        children: [
          _buildFilterChip('Game', _filterGame, _games, (value) {
            setState(() {
              _filterGame = value;
            });
          }),
          const SizedBox(width: 8),
          _buildFilterChip('Result', _filterResult, ['All', 'Win', 'Loss'], (value) {
            setState(() {
              _filterResult = value;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String currentValue,
    List<String> options,
    Function(String) onSelected,
  ) {
    final isFiltered = currentValue != 'All';
    
    return GestureDetector(
      onTap: () => _showFilterOptions(label, currentValue, options, onSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: isFiltered
            ? PremiumTheme.gradientButtonDecoration
            : PremiumTheme.glassActionButton,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: $currentValue',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isFiltered ? Colors.white : PremiumTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: isFiltered ? Colors.white : PremiumTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionsList(List<Session> sessions) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumTheme.screenHorizontalPadding,
      ),
      itemCount: sessions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _buildSessionItem(session);
      },
    );
  }

  Widget _buildSessionItem(Session session) {
    final currencySymbol = context.read<AppState>().preferences.currencySymbol;
    final isWin = session.netProfit > 0;
    final duration = session.endTime != null 
        ? session.endTime!.difference(session.startTime)
        : Duration.zero;
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    return GestureDetector(
      onTap: () => _showSessionDetail(session),
      child: Container(
        decoration: PremiumTheme.glassActionButton,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Game icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: _getGameGradient(session.game),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            AppAssets.getGameIcon(session.game),
                            fit: BoxFit.contain,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Session info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.game,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: PremiumTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              session.location,
                              style: const TextStyle(
                                fontSize: 14,
                                color: PremiumTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Net profit
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${isWin ? '+' : ''}$currencySymbol${session.netProfit.abs().toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: isWin
                                  ? PremiumTheme.successGreen
                                  : PremiumTheme.lossRed,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${hours}h ${minutes}m',
                            style: const TextStyle(
                              fontSize: 12,
                              color: PremiumTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Date and tags
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: PremiumTheme.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM d, y • h:mm a').format(session.startTime),
                        style: const TextStyle(
                          fontSize: 13,
                          color: PremiumTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Custom empty state image
                    Image.asset(
                      AppAssets.noSessionsImage,
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No Sessions Yet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: PremiumTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap the + button to log your first session',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: PremiumTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterOptions(
    String label,
    String currentValue,
    List<String> options,
    Function(String) onSelected,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: PremiumTheme.deepNavyCenter.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter by $label',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: PremiumTheme.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: PremiumTheme.textSecondary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Options Grid (for Game filter with icons)
                    if (label == 'Game')
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.85,
                        children: options.map((option) {
                          final isSelected = option == currentValue;
                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: isSelected
                                  ? PremiumTheme.gradientButtonDecoration
                                  : BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Game Icon
                                  if (option != 'All')
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.2)
                                            : Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset(
                                        AppAssets.getGameIcon(option),
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.2)
                                            : Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.grid_view_rounded,
                                        color: isSelected
                                            ? Colors.white
                                            : PremiumTheme.textSecondary,
                                        size: 28,
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  Text(
                                    option,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                      color: isSelected ? Colors.white : PremiumTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    // Simple List (for Result filter)
                    else
                      Column(
                        children: options.map((option) {
                          final isSelected = option == currentValue;
                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: isSelected
                                  ? PremiumTheme.gradientButtonDecoration
                                  : BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                              child: Row(
                                children: [
                                  Icon(
                                    option == 'All'
                                        ? Icons.all_inclusive
                                        : option == 'Win'
                                            ? Icons.trending_up
                                            : Icons.trending_down,
                                    color: isSelected
                                        ? Colors.white
                                        : PremiumTheme.textSecondary,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                      color: isSelected ? Colors.white : PremiumTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBulkActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: PremiumTheme.deepNavyCenter,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Bulk Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: PremiumTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildBulkActionItem(
              icon: Icons.file_download,
              label: 'Export as CSV',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement CSV export
              },
            ),
            _buildBulkActionItem(
              icon: Icons.code,
              label: 'Export as JSON',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement JSON export
              },
            ),
            _buildBulkActionItem(
              icon: Icons.delete_outline,
              label: 'Delete All',
              color: PremiumTheme.lossRed,
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement delete all with confirmation
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: PremiumTheme.glassActionButton,
        child: Row(
          children: [
            Icon(icon, color: color ?? PremiumTheme.primaryBlue),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color ?? PremiumTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSessionDetail(Session session) {
    // TODO: Show session detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Session detail for ${session.game} - Coming soon!')),
    );
  }

  LinearGradient _getGameGradient(String game) {
    switch (game.toLowerCase()) {
      case 'slots':
        return PremiumTheme.stellarGradient;
      case 'blackjack':
        return PremiumTheme.bitcoinGradient;
      case 'poker':
        return PremiumTheme.ethereumGradient;
      case 'roulette':
        return PremiumTheme.bluePurpleGradient;
      default:
        return PremiumTheme.stellarGradient;
    }
  }
}
