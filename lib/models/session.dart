import 'package:uuid/uuid.dart';

/// Represents a single gaming session
class Session {
  final String id;
  final String game; // Slots, Blackjack, Poker, Roulette, Craps, Other
  final String location;
  final DateTime startTime;
  final DateTime? endTime;
  final double buyIn;
  final double cashOut;
  final double? stakes; // Table minimum or bet size
  final String? comps; // Complimentaries received
  final String? notes;
  final List<String> tags;
  final List<SessionEvent> events;

  Session({
    String? id,
    required this.game,
    required this.location,
    required this.startTime,
    this.endTime,
    required this.buyIn,
    this.cashOut = 0.0,
    this.stakes,
    this.comps,
    this.notes,
    List<String>? tags,
    List<SessionEvent>? events,
  }) : id = id ?? const Uuid().v4(),
       tags = tags ?? [],
       events = events ?? [];

  // Calculated properties
  double get netProfit => cashOut - buyIn;

  bool get isWin => netProfit > 0;

  Duration get duration {
    if (endTime == null) return Duration.zero;
    return endTime!.difference(startTime);
  }

  double get durationInHours {
    if (endTime == null) return 0.0;
    return duration.inMinutes / 60.0;
  }

  bool get isActive => endTime == null;

  String get formattedDuration {
    if (endTime == null) return 'Active';
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Session copyWith({
    String? game,
    String? location,
    DateTime? startTime,
    DateTime? endTime,
    double? buyIn,
    double? cashOut,
    double? stakes,
    String? comps,
    String? notes,
    List<String>? tags,
    List<SessionEvent>? events,
  }) {
    return Session(
      id: id,
      game: game ?? this.game,
      location: location ?? this.location,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      buyIn: buyIn ?? this.buyIn,
      cashOut: cashOut ?? this.cashOut,
      stakes: stakes ?? this.stakes,
      comps: comps ?? this.comps,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      events: events ?? this.events,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game': game,
      'location': location,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'buyIn': buyIn,
      'cashOut': cashOut,
      'stakes': stakes,
      'comps': comps,
      'notes': notes,
      'tags': tags,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      game: json['game'] as String,
      location: json['location'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      buyIn: (json['buyIn'] as num).toDouble(),
      cashOut: (json['cashOut'] as num).toDouble(),
      stakes: json['stakes'] != null
          ? (json['stakes'] as num).toDouble()
          : null,
      comps: json['comps'] as String?,
      notes: json['notes'] as String?,
      tags: List<String>.from(json['tags'] as List),
      events: (json['events'] as List)
          .map((e) => SessionEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Events during a session (buy-ins, re-buys, cash-outs)
class SessionEvent {
  final String id;
  final DateTime timestamp;
  final String type; // 'buyin', 'rebuy', 'cashout', 'note'
  final double? amount;
  final String? note;

  SessionEvent({
    String? id,
    required this.timestamp,
    required this.type,
    this.amount,
    this.note,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'amount': amount,
      'note': note,
    };
  }

  factory SessionEvent.fromJson(Map<String, dynamic> json) {
    return SessionEvent(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String,
      amount: json['amount'] != null
          ? (json['amount'] as num).toDouble()
          : null,
      note: json['note'] as String?,
    );
  }
}

/// Game types constants
class GameType {
  static const String slots = 'Slots';
  static const String blackjack = 'Blackjack';
  static const String poker = 'Poker';
  static const String roulette = 'Roulette';
  static const String craps = 'Craps';
  static const String other = 'Other';

  static const List<String> all = [
    slots,
    blackjack,
    poker,
    roulette,
    craps,
    other,
  ];
}
