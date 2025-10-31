import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../core/theme/premium_theme.dart';
import '../../core/assets/app_assets.dart';
import '../../shared/widgets/space_background.dart';
import '../../providers/app_state.dart';
import '../../models/note.dart';
import '../onboarding/premium_onboarding_screen.dart';

class PremiumMoreScreen extends StatelessWidget {
  const PremiumMoreScreen({super.key});

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
                            'More',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: PremiumTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Settings, notes, and achievements',
                            style: TextStyle(
                              fontSize: 14,
                              color: PremiumTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Profile Card
                    _buildProfileCard(state),

                    const SizedBox(height: 24),

                    // Account Section
                    _buildAccountSection(context, state),

                    const SizedBox(height: 24),

                    // Settings Section
                    _buildSettingsSection(context),

                    const SizedBox(height: 24),

                    // Notes Section
                    _buildNotesSection(context, state),

                    const SizedBox(height: 24),

                    // Achievements Section
                    _buildAchievementsSection(state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(AppState state) {
    final totalSessions = state.sessions.length;
    final winRate = state.winRate;

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
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: PremiumTheme.bluePurpleGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 32, color: Colors.white),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.preferences.userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: PremiumTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalSessions sessions • ${winRate.toInt()}% win rate',
                    style: TextStyle(
                      fontSize: 14,
                      color: PremiumTheme.textSecondary,
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
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, AppState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumTheme.screenHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACCOUNT',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: PremiumTheme.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.person_outline_rounded,
            title: 'Edit Name',
            subtitle: state.preferences.userName,
            onTap: () => _showEditNameDialog(context, state),
          ),
          _buildSettingItem(
            icon: Icons.delete_outline_rounded,
            title: 'Delete Account',
            subtitle: 'Remove all data permanently',
            onTap: () => _showDeleteAccountDialog(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PremiumTheme.screenHorizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SETTINGS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: PremiumTheme.textTertiary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildNotificationsSetting(context, state),
              _buildSettingItem(
                icon: Icons.attach_money_rounded,
                title: 'Currency',
                subtitle: '${state.preferences.currency} (${state.preferences.currencySymbol})',
                onTap: () => _showCurrencyDialog(context, state),
              ),
              _buildSettingItem(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy Policy',
                onTap: () => _openWebView(
                  context,
                  'Privacy Policy',
                  'https://www.example.com/',
                ),
              ),
              _buildSettingItem(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () => _openWebView(
                  context,
                  'Terms & Conditions',
                  'https://www.example.com/',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: PremiumTheme.glassActionButton,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
            Container(
              width: 40,
              height: 40,
              decoration: PremiumTheme.iconContainerDecoration,
              child: Icon(icon, size: 20, color: PremiumTheme.primaryBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: PremiumTheme.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: PremiumTheme.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: PremiumTheme.textQuaternary,
            ),
          ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context, AppState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumTheme.screenHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NOTES',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: PremiumTheme.textTertiary,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () => _showAddNoteSheet(context, state),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: PremiumTheme.gradientButtonDecoration,
                  child: const Text(
                    'Add Note',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (state.notes.isEmpty)
            _buildEmptyNotes()
          else
            ...state.notes.take(3).map((note) => _buildNoteItem(note)),
        ],
      ),
    );
  }

  Widget _buildNoteItem(Note note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Text(
            note.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: PremiumTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            note.content,
            style: TextStyle(fontSize: 14, color: PremiumTheme.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('MMM d, y').format(note.createdAt),
            style: TextStyle(fontSize: 12, color: PremiumTheme.textQuaternary),
          ),
        ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyNotes() {
    return Container(
      decoration: PremiumTheme.glassActionButton,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
          children: [
            Image.asset(
              AppAssets.noNotesImage,
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            Text(
              'No notes yet',
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

  Widget _buildEmptyAchievements() {
    return Container(
      decoration: PremiumTheme.glassActionButton,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    AppAssets.noAchievementsImage,
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No achievements unlocked yet',
                    style: TextStyle(
                      fontSize: 14,
                      color: PremiumTheme.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start playing to unlock achievements',
                    style: TextStyle(
                      fontSize: 12,
                      color: PremiumTheme.textQuaternary,
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

  Widget _buildAchievementsSection(AppState state) {
    // Check if any achievements are unlocked
    final hasUnlockedAchievements = state.sessions.isNotEmpty ||
        state.sessions.length >= 10 ||
        state.sessions.any((s) => s.netProfit >= 1000) ||
        state.sessions.length >= 50;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumTheme.screenHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACHIEVEMENTS',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: PremiumTheme.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          if (!hasUnlockedAchievements)
            _buildEmptyAchievements()
          else ...[
            _buildAchievementItem(
              badgeType: 'first_win',
              title: 'First Session',
              description: 'Complete your first gaming session',
              isUnlocked: state.sessions.isNotEmpty,
            ),
            _buildAchievementItem(
              badgeType: 'winning_streak',
              title: '10 Session Streak',
              description: 'Play 10 sessions in a row',
              isUnlocked: state.sessions.length >= 10,
            ),
            _buildAchievementItem(
              badgeType: 'big_win',
              title: 'Big Winner',
              description: 'Win \$1,000 in a single session',
              isUnlocked: state.sessions.any((s) => s.netProfit >= 1000),
            ),
            _buildAchievementItem(
              badgeType: 'weekend_warrior',
              title: 'Weekend Warrior',
              description: 'Play 5 weekend sessions',
              isUnlocked: false, // TODO: Implement weekend check
            ),
            _buildAchievementItem(
              badgeType: 'discipline_master',
              title: 'Discipline Master',
              description: 'Stick to your limits for 30 days',
              isUnlocked: false, // TODO: Implement limit tracking
            ),
            _buildAchievementItem(
              badgeType: 'bankroll_builder',
              title: 'Bankroll Builder',
              description: 'Grow your bankroll by 50%',
              isUnlocked: false, // TODO: Implement bankroll growth tracking
            ),
            _buildAchievementItem(
              badgeType: 'data_analyst',
              title: 'Data Analyst',
              description: 'Log 50 sessions with detailed notes',
              isUnlocked: state.sessions.length >= 50,
            ),
            _buildAchievementItem(
              badgeType: 'responsible_player',
              title: 'Responsible Player',
              description: 'Set and follow session limits',
              isUnlocked: false, // TODO: Implement responsible gaming tracking
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAchievementItem({
    required String badgeType,
    required String title,
    required String description,
    required bool isUnlocked,
  }) {
    return Container(
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
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: isUnlocked
                      ? PremiumTheme.bluePurpleGradient
                      : LinearGradient(
                          colors: [
                            PremiumTheme.glassLight,
                            PremiumTheme.glassBase,
                          ],
                        ),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    AppAssets.getBadgeIcon(badgeType),
                    fit: BoxFit.contain,
                    color: isUnlocked
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isUnlocked
                            ? PremiumTheme.textPrimary
                            : PremiumTheme.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: PremiumTheme.textQuaternary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isUnlocked)
                Icon(
                  Icons.check_circle,
                  color: PremiumTheme.successGreen,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddNoteSheet(BuildContext context, AppState state) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: PremiumTheme.spaceBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [PremiumTheme.glassLight, PremiumTheme.glassBase],
                ),
                border: Border(
                  top: BorderSide(
                    color: PremiumTheme.borderGlassLight,
                    width: 1,
                  ),
                ),
              ),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'New Note',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: PremiumTheme.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: PremiumTheme.textSecondary,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Title Field
                    Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: PremiumTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: PremiumTheme.glassActionButton,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: TextField(
                            controller: titleController,
                            style: const TextStyle(
                              fontSize: 16,
                              color: PremiumTheme.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter note title...',
                              hintStyle: TextStyle(
                                color: PremiumTheme.textQuaternary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Content Field
                    Text(
                      'Content',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: PremiumTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: PremiumTheme.glassActionButton,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: TextField(
                            controller: contentController,
                            maxLines: 5,
                            style: const TextStyle(
                              fontSize: 16,
                              color: PremiumTheme.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Write your note here...',
                              hintStyle: TextStyle(
                                color: PremiumTheme.textQuaternary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Save Button
                    GestureDetector(
                      onTap: () {
                        if (titleController.text.isNotEmpty &&
                            contentController.text.isNotEmpty) {
                          final note = Note(
                            title: titleController.text,
                            content: contentController.text,
                            createdAt: DateTime.now(),
                          );
                          state.addNote(note);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        height: 56,
                        decoration: PremiumTheme.gradientButtonDecoration,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: const Center(
                              child: Text(
                                'Save Note',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, AppState state) {
    final TextEditingController nameController =
        TextEditingController(text: state.preferences.userName);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: PremiumTheme.glassActionButton,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Edit Name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: PremiumTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: PremiumTheme.glassActionButton,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: TextField(
                            controller: nameController,
                            autofocus: true,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: PremiumTheme.textPrimary,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(
                                color: PremiumTheme.textTertiary,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: PremiumTheme.glassActionButton,
                              child: const Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: PremiumTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final newName = nameController.text.trim();
                              if (newName.isNotEmpty) {
                                state.updatePreferences(
                                  state.preferences.copyWith(userName: newName),
                                );
                                Navigator.of(context).pop();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: PremiumTheme.gradientButtonDecoration,
                              child: const Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
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
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AppState state) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: PremiumTheme.glassActionButton,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_rounded,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Delete Account?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: PremiumTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This will permanently delete all your data including sessions, notes, and bankroll history. This action cannot be undone.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: PremiumTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: PremiumTheme.glassActionButton,
                              child: const Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: PremiumTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              state.deleteAccount();
                              Navigator.of(context).pop();
                              // Navigate to onboarding
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const OnboardingScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.withOpacity(0.8),
                                    Colors.red.withOpacity(0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
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
      ),
    );
  }

  Widget _buildNotificationsSetting(BuildContext context, AppState state) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: PremiumTheme.glassActionButton,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: PremiumTheme.iconContainerDecoration,
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    size: 20,
                    color: PremiumTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: PremiumTheme.textPrimary,
                    ),
                  ),
                ),
                Switch(
                  value: state.preferences.notificationsEnabled,
                  onChanged: (value) {
                    state.updatePreferences(
                      state.preferences.copyWith(notificationsEnabled: value),
                    );
                  },
                  activeColor: PremiumTheme.primaryBlue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, AppState state) {
    final currencies = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'AUD': 'A\$',
      'CAD': 'C\$',
      'CHF': 'CHF',
      'CNY': '¥',
      'INR': '₹',
      'MXN': 'MX\$',
    };

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: PremiumTheme.glassActionButton,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(maxHeight: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Currency',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: PremiumTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: currencies.entries.map((entry) {
                          final isSelected =
                              state.preferences.currency == entry.key;
                          return GestureDetector(
                            onTap: () {
                              state.updatePreferences(
                                state.preferences.copyWith(
                                  currency: entry.key,
                                  currencySymbol: entry.value,
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? PremiumTheme.bluePurpleGradient
                                    : null,
                                color: isSelected
                                    ? null
                                    : PremiumTheme.glassBase,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? PremiumTheme.primaryBlue
                                          .withOpacity(0.5)
                                      : PremiumTheme.borderGlass,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    entry.value,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : PremiumTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : PremiumTheme.textPrimary,
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const Spacer(),
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
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

  void _openWebView(BuildContext context, String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xFF0A0E21),
          appBar: AppBar(
            backgroundColor: PremiumTheme.glassBase,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: PremiumTheme.textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: PremiumTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url)),
            initialSettings: InAppWebViewSettings(
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
              javaScriptEnabled: true,
              supportZoom: true,
            ),
          ),
        ),
      ),
    );
  }
}
