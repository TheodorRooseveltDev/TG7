/// User preferences and settings
class UserPreferences {
  final String userName;
  final bool hasCompletedOnboarding;
  final bool darkModeEnabled;
  final bool notificationsEnabled;
  final bool biometricsEnabled;
  final String currency;
  final String currencySymbol;

  UserPreferences({
    this.userName = 'Player',
    this.hasCompletedOnboarding = false,
    this.darkModeEnabled = true,
    this.notificationsEnabled = true,
    this.biometricsEnabled = false,
    this.currency = 'USD',
    this.currencySymbol = '\$',
  });

  UserPreferences copyWith({
    String? userName,
    bool? hasCompletedOnboarding,
    bool? darkModeEnabled,
    bool? notificationsEnabled,
    bool? biometricsEnabled,
    String? currency,
    String? currencySymbol,
  }) {
    return UserPreferences(
      userName: userName ?? this.userName,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'darkModeEnabled': darkModeEnabled,
      'notificationsEnabled': notificationsEnabled,
      'biometricsEnabled': biometricsEnabled,
      'currency': currency,
      'currencySymbol': currencySymbol,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      userName: json['userName'] as String? ?? 'Player',
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? true,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      biometricsEnabled: json['biometricsEnabled'] as bool? ?? false,
      currency: json['currency'] as String? ?? 'USD',
      currencySymbol: json['currencySymbol'] as String? ?? '\$',
    );
  }
}
