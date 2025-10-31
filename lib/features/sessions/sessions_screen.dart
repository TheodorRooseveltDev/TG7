import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/gradient_orb.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/custom_button.dart' as custom;
import '../../providers/app_state.dart';
import '../../models/session.dart';
import 'widgets/session_list_item.dart';
import 'widgets/session_filter_bar.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  String _searchQuery = '';
  String? _selectedGame;
  bool _showWinsOnly = false;
  bool _showLossesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: GradientOrbBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.screenMarginMobile),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sessions', style: AppTypography.headingXLStyle()),
                        custom.IconButtonCustom(
                          icon: Icons.filter_list_rounded,
                          onPressed: () => _showFilterSheet(context),
                          tooltip: 'Filter',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Search bar
                    _buildSearchBar(),
                  ],
                ),
              ),

              // Filter chips
              if (_selectedGame != null || _showWinsOnly || _showLossesOnly)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenMarginMobile,
                  ),
                  child: _buildActiveFilters(),
                ),

              // Sessions list
              Expanded(
                child: Consumer<AppState>(
                  builder: (context, state, child) {
                    final filteredSessions = _filterSessions(state.sessions);

                    if (filteredSessions.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenMarginMobile,
                        vertical: AppSpacing.md,
                      ),
                      itemCount: filteredSessions.length,
                      itemBuilder: (context, index) {
                        final session = filteredSessions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: SessionListItem(
                            session: session,
                            onTap: () => _viewSessionDetails(context, session),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x08FFFFFF),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: TextField(
        style: AppTypography.inputStyle(),
        decoration: InputDecoration(
          hintText: 'Search by location or tags...',
          hintStyle: AppTypography.inputStyle(color: AppColors.textQuaternary),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textTertiary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.inputPaddingHorizontal,
            vertical: AppSpacing.inputPaddingVertical,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildActiveFilters() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (_selectedGame != null)
            _buildFilterChip(
              label: _selectedGame!,
              onRemove: () => setState(() => _selectedGame = null),
            ),
          if (_showWinsOnly)
            _buildFilterChip(
              label: 'Wins Only',
              onRemove: () => setState(() => _showWinsOnly = false),
            ),
          if (_showLossesOnly)
            _buildFilterChip(
              label: 'Losses Only',
              onRemove: () => setState(() => _showLossesOnly = false),
            ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedGame = null;
                _showWinsOnly = false;
                _showLossesOnly = false;
              });
            },
            child: Text(
              'Clear All',
              style: AppTypography.bodyMStyle(
                color: AppColors.electricBluePrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.electricBluePrimary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        border: Border.all(
          color: AppColors.electricBluePrimary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.bodyMStyle(
              color: AppColors.electricBluePrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 16,
              color: AppColors.electricBluePrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: SimpleGlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.electricBluePrimary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.casino_rounded,
                  size: 48,
                  color: AppColors.electricBluePrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                _searchQuery.isNotEmpty
                    ? 'No sessions found'
                    : 'No sessions yet',
                style: AppTypography.headingMStyle(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _searchQuery.isNotEmpty
                    ? 'Try adjusting your search or filters'
                    : 'Tap the button below to log your first session',
                style: AppTypography.bodyMStyle(
                  color: AppColors.textQuaternary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Session> _filterSessions(List<Session> sessions) {
    return sessions.where((session) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesLocation = session.location.toLowerCase().contains(
          _searchQuery,
        );
        final matchesTags = session.tags.any(
          (tag) => tag.toLowerCase().contains(_searchQuery),
        );
        final matchesNotes =
            session.notes?.toLowerCase().contains(_searchQuery) ?? false;

        if (!matchesLocation && !matchesTags && !matchesNotes) {
          return false;
        }
      }

      // Game filter
      if (_selectedGame != null && session.game != _selectedGame) {
        return false;
      }

      // Win/Loss filter
      if (_showWinsOnly && !session.isWin) {
        return false;
      }
      if (_showLossesOnly && session.isWin) {
        return false;
      }

      return true;
    }).toList();
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SessionFilterBar(
        selectedGame: _selectedGame,
        showWinsOnly: _showWinsOnly,
        showLossesOnly: _showLossesOnly,
        onGameSelected: (game) => setState(() => _selectedGame = game),
        onWinsOnlyChanged: (value) => setState(() {
          _showWinsOnly = value;
          if (value) _showLossesOnly = false;
        }),
        onLossesOnlyChanged: (value) => setState(() {
          _showLossesOnly = value;
          if (value) _showWinsOnly = false;
        }),
      ),
    );
  }

  void _viewSessionDetails(BuildContext context, Session session) {
    // TODO: Navigate to session details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('View details: ${session.game} at ${session.location}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
