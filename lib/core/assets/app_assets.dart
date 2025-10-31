/// Custom app assets paths
class AppAssets {
  AppAssets._();

  // Game Icons
  static const String slotsIcon = 'assets/icons/games/slots.png';
  static const String blackjackIcon = 'assets/icons/games/blackjack.png';
  static const String pokerIcon = 'assets/icons/games/poker.png';
  static const String rouletteIcon = 'assets/icons/games/roulette.png';
  static const String crapsIcon = 'assets/icons/games/craps.png';
  static const String baccaratIcon = 'assets/icons/games/baccarat.png';

  // Tab Bar Icons
  static const String homeIcon = 'assets/icons/tabs/home.png';
  static const String sessionIcon = 'assets/icons/tabs/session.png';
  static const String analyzeIcon = 'assets/icons/tabs/analyze.png';
  static const String bankrollIcon = 'assets/icons/tabs/bankroll.png';
  static const String moreIcon = 'assets/icons/tabs/more.png';

  // Achievement Badges
  static const String firstWinBadge = 'assets/icons/badges/first_win.png';
  static const String weekendWarriorBadge = 'assets/icons/badges/weekend_warrior.png';
  static const String bigWinBadge = 'assets/icons/badges/big_win.png';
  static const String winningStreakBadge = 'assets/icons/badges/winning_streak.png';
  static const String disciplineMasterBadge = 'assets/icons/badges/discipline_master.png';
  static const String bankrollBuilderBadge = 'assets/icons/badges/bankroll_builder.png';
  static const String dataAnalystBadge = 'assets/icons/badges/data_analyst.png';
  static const String responsiblePlayerBadge = 'assets/icons/badges/responsible_player.png';

  // Empty State Images
  static const String noSessionsImage = 'assets/images/empty_states/no_sessions.png';
  static const String noNotesImage = 'assets/images/empty_states/no_notes.png';
  static const String noAchievementsImage = 'assets/images/empty_states/no_achievements.png';

  /// Get game icon path by game name
  static String getGameIcon(String game) {
    switch (game.toLowerCase()) {
      case 'slots':
        return slotsIcon;
      case 'blackjack':
        return blackjackIcon;
      case 'poker':
        return pokerIcon;
      case 'roulette':
        return rouletteIcon;
      case 'craps':
        return crapsIcon;
      case 'baccarat':
        return baccaratIcon;
      default:
        return slotsIcon; // Default fallback
    }
  }

  /// Get badge icon path by badge type
  static String getBadgeIcon(String badgeType) {
    switch (badgeType.toLowerCase()) {
      case 'first_win':
      case 'firstwin':
        return firstWinBadge;
      case 'weekend_warrior':
      case 'weekendwarrior':
        return weekendWarriorBadge;
      case 'big_win':
      case 'bigwin':
        return bigWinBadge;
      case 'winning_streak':
      case 'winningstreak':
        return winningStreakBadge;
      case 'discipline_master':
      case 'disciplinemaster':
        return disciplineMasterBadge;
      case 'bankroll_builder':
      case 'bankrollbuilder':
        return bankrollBuilderBadge;
      case 'data_analyst':
      case 'dataanalyst':
        return dataAnalystBadge;
      case 'responsible_player':
      case 'responsibleplayer':
        return responsiblePlayerBadge;
      default:
        return firstWinBadge; // Default fallback
    }
  }
}
