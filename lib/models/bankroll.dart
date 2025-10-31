import 'package:uuid/uuid.dart';

/// Represents a bankroll/wallet
class Bankroll {
  final String id;
  final String name;
  final double balance;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<BankrollTransaction> transactions;

  Bankroll({
    String? id,
    required this.name,
    required this.balance,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<BankrollTransaction>? transactions,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       transactions = transactions ?? [];

  Bankroll copyWith({
    String? name,
    double? balance,
    DateTime? updatedAt,
    List<BankrollTransaction>? transactions,
  }) {
    return Bankroll(
      id: id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }

  factory Bankroll.fromJson(Map<String, dynamic> json) {
    return Bankroll(
      id: json['id'] as String,
      name: json['name'] as String,
      balance: (json['balance'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      transactions: (json['transactions'] as List)
          .map((t) => BankrollTransaction.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Bankroll transaction (deposit, withdrawal, adjustment)
class BankrollTransaction {
  final String id;
  final DateTime timestamp;
  final String type; // 'deposit', 'withdrawal', 'adjustment'
  final double amount;
  final String? note;

  BankrollTransaction({
    String? id,
    required this.timestamp,
    required this.type,
    required this.amount,
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

  factory BankrollTransaction.fromJson(Map<String, dynamic> json) {
    return BankrollTransaction(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String?,
    );
  }
}

/// Spending limits
class SpendingLimit {
  final String id;
  final String type; // 'daily', 'weekly', 'monthly', 'per_session'
  final double amount;
  final bool enabled;

  SpendingLimit({
    String? id,
    required this.type,
    required this.amount,
    this.enabled = true,
  }) : id = id ?? const Uuid().v4();

  SpendingLimit copyWith({String? type, double? amount, bool? enabled}) {
    return SpendingLimit(
      id: id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'amount': amount, 'enabled': enabled};
  }

  factory SpendingLimit.fromJson(Map<String, dynamic> json) {
    return SpendingLimit(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      enabled: json['enabled'] as bool,
    );
  }
}
