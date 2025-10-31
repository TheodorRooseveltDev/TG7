import 'package:uuid/uuid.dart';

/// User note/journal entry
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final List<String> tags;

  Note({
    String? id,
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isPinned = false,
    List<String>? tags,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       tags = tags ?? [];

  Note copyWith({
    String? title,
    String? content,
    DateTime? updatedAt,
    bool? isPinned,
    List<String>? tags,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isPinned: isPinned ?? this.isPinned,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
      'tags': tags,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPinned: json['isPinned'] as bool,
      tags: List<String>.from(json['tags'] as List),
    );
  }
}

/// Achievement/Badge
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final DateTime? unlockedAt;
  final bool isUnlocked;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.unlockedAt,
    this.isUnlocked = false,
  });

  Achievement copyWith({DateTime? unlockedAt, bool? isUnlocked}) {
    return Achievement(
      id: id,
      name: name,
      description: description,
      icon: icon,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'isUnlocked': isUnlocked,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      isUnlocked: json['isUnlocked'] as bool,
    );
  }
}

/// Predefined achievements
class AchievementsList {
  static final List<Achievement> all = [
    Achievement(
      id: 'first_session',
      name: 'First Session',
      description: 'Log your first casino session',
      icon: '🎰',
    ),
    Achievement(
      id: 'big_win',
      name: 'Big Win',
      description: 'Win \$500 or more in a single session',
      icon: '💰',
    ),
    Achievement(
      id: 'weekend_warrior',
      name: 'Weekend Warrior',
      description: 'Play sessions on 4 consecutive weekends',
      icon: '🎮',
    ),
    Achievement(
      id: 'consistent_player',
      name: 'Consistent Player',
      description: 'Log 10 sessions',
      icon: '📊',
    ),
    Achievement(
      id: 'responsible_gamer',
      name: 'Responsible Gamer',
      description: 'Set and stick to your limits for 5 sessions',
      icon: '🛡️',
    ),
    Achievement(
      id: 'profitable_month',
      name: 'Profitable Month',
      description: 'End the month with positive net profit',
      icon: '📈',
    ),
  ];
}

/// User Account
class User {
  final String id;
  final String name;
  final DateTime createdAt;
  final String? avatarUrl;

  User({
    String? id,
    required this.name,
    DateTime? createdAt,
    this.avatarUrl,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  User copyWith({
    String? name,
    String? avatarUrl,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'avatarUrl': avatarUrl,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}
