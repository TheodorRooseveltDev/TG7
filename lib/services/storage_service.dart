import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';
import '../models/bankroll.dart';
import '../models/note.dart';
import '../models/user_preferences.dart';

/// Local storage service using SharedPreferences
class StorageService {
  static const String _keyPreferences = 'user_preferences';
  static const String _keySessions = 'sessions';
  static const String _keyBankrolls = 'bankrolls';
  static const String _keyNotes = 'notes';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Initialize storage service
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  /// Save user preferences
  Future<void> savePreferences(UserPreferences preferences) async {
    await _prefs.setString(_keyPreferences, jsonEncode(preferences.toJson()));
  }

  /// Load user preferences
  UserPreferences? loadPreferences() {
    final data = _prefs.getString(_keyPreferences);
    if (data == null) return null;
    try {
      return UserPreferences.fromJson(jsonDecode(data));
    } catch (e) {
      print('Error loading preferences: $e');
      return null;
    }
  }

  /// Save sessions
  Future<void> saveSessions(List<Session> sessions) async {
    final data = sessions.map((s) => s.toJson()).toList();
    await _prefs.setString(_keySessions, jsonEncode(data));
  }

  /// Load sessions
  List<Session> loadSessions() {
    final data = _prefs.getString(_keySessions);
    if (data == null) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => Session.fromJson(json)).toList();
    } catch (e) {
      print('Error loading sessions: $e');
      return [];
    }
  }

  /// Save bankrolls
  Future<void> saveBankrolls(List<Bankroll> bankrolls) async {
    final data = bankrolls.map((b) => b.toJson()).toList();
    await _prefs.setString(_keyBankrolls, jsonEncode(data));
  }

  /// Load bankrolls
  List<Bankroll> loadBankrolls() {
    final data = _prefs.getString(_keyBankrolls);
    if (data == null) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => Bankroll.fromJson(json)).toList();
    } catch (e) {
      print('Error loading bankrolls: $e');
      return [];
    }
  }

  /// Save notes
  Future<void> saveNotes(List<Note> notes) async {
    final data = notes.map((n) => n.toJson()).toList();
    await _prefs.setString(_keyNotes, jsonEncode(data));
  }

  /// Load notes
  List<Note> loadNotes() {
    final data = _prefs.getString(_keyNotes);
    if (data == null) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => Note.fromJson(json)).toList();
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
