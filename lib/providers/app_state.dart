import 'package:flutter/foundation.dart';
import '../models/session.dart';
import '../models/bankroll.dart';
import '../models/note.dart';
import '../models/user_preferences.dart';
import '../services/storage_service.dart';

/// Main app state provider
class AppState extends ChangeNotifier {
  User? _user;
  List<Session> _sessions = [];
  List<Bankroll> _bankrolls = [];
  List<Note> _notes = [];
  UserPreferences _preferences = UserPreferences();
  Session? _activeSession;
  StorageService? _storage;

  // Getters
  User? get user => _user;
  List<Session> get sessions => List.unmodifiable(_sessions);
  List<Bankroll> get bankrolls => List.unmodifiable(_bankrolls);
  List<Note> get notes => List.unmodifiable(_notes);
  UserPreferences get preferences => _preferences;
  Session? get activeSession => _activeSession;

  /// Initialize app state with storage
  Future<void> init() async {
    _storage = await StorageService.init();
    await _loadData();
  }

  /// Load all data from storage
  Future<void> _loadData() async {
    if (_storage == null) return;
    
    final prefs = _storage!.loadPreferences();
    if (prefs != null) {
      _preferences = prefs;
    }
    
    _sessions = _storage!.loadSessions();
    _bankrolls = _storage!.loadBankrolls();
    _notes = _storage!.loadNotes();
    
    notifyListeners();
  }

  /// Save all data to storage
  Future<void> _saveData() async {
    if (_storage == null) return;
    
    await _storage!.savePreferences(_preferences);
    await _storage!.saveSessions(_sessions);
    await _storage!.saveBankrolls(_bankrolls);
    await _storage!.saveNotes(_notes);
  }

  // Computed values
  double get totalNetProfit {
    return _sessions.fold(0.0, (sum, session) => sum + session.netProfit);
  }

  int get totalSessions => _sessions.length;

  double get winRate {
    if (_sessions.isEmpty) return 0.0;
    final wins = _sessions.where((s) => s.isWin).length;
    return (wins / _sessions.length) * 100;
  }

  double get averageDuration {
    if (_sessions.isEmpty) return 0.0;
    final completedSessions = _sessions.where((s) => !s.isActive);
    if (completedSessions.isEmpty) return 0.0;
    final totalHours = completedSessions.fold(
      0.0,
      (sum, session) => sum + session.durationInHours,
    );
    return totalHours / completedSessions.length;
  }

  double get currentBankroll {
    if (_bankrolls.isEmpty) return 0.0;
    return _bankrolls.first.balance;
  }

  double get initialBankroll {
    if (_bankrolls.isEmpty) return 0.0;
    // Get initial transaction amount
    final firstBankroll = _bankrolls.first;
    if (firstBankroll.transactions.isEmpty) return firstBankroll.balance;
    final initialTransaction =
        firstBankroll.transactions.last; // Last is oldest
    return initialTransaction.amount;
  }

  Map<String, double> get profitByGame {
    final Map<String, double> result = {};
    for (final session in _sessions) {
      result[session.game] = (result[session.game] ?? 0.0) + session.netProfit;
    }
    return result;
  }

  // Start with ZERO data - real app behavior
  AppState() {
    // User starts with completely empty state
    // They will add their own bankroll and data through onboarding
  }

  // User methods
  void setUser(User user) {
    _user = user;
    notifyListeners();
    _saveData();
  }

  void updateUser(User user) {
    _user = user;
    notifyListeners();
    _saveData();
  }

  void deleteAccount() {
    _user = null;
    _sessions.clear();
    _bankrolls.clear();
    _notes.clear();
    _preferences = UserPreferences();
    _activeSession = null;
    _storage?.clearAll();
    notifyListeners();
  }

  // Session methods
  void addSession(Session session) {
    _sessions.insert(0, session);
    notifyListeners();
    _saveData();
  }

  void updateSession(Session session) {
    final index = _sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      _sessions[index] = session;
      notifyListeners();
      _saveData();
    }
  }

  void deleteSession(String sessionId) {
    _sessions.removeWhere((s) => s.id == sessionId);
    notifyListeners();
    _saveData();
  }

  void startSession(Session session) {
    _activeSession = session;
    addSession(session);
  }

  void endSession(Session session) {
    updateSession(session);
    _activeSession = null;
  }

  // Note methods
  void addNote(Note note) {
    _notes.insert(0, note);
    notifyListeners();
    _saveData();
  }

  void updateNote(Note note) {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
      _saveData();
    }
  }

  void deleteNote(String noteId) {
    _notes.removeWhere((n) => n.id == noteId);
    notifyListeners();
    _saveData();
  }

  // Preferences methods
  void updatePreferences(UserPreferences prefs) {
    _preferences = prefs;
    notifyListeners();
    _saveData();
  }

  // Bankroll methods
  void initializeBankroll(String name, double initialAmount) {
    final bankroll = Bankroll(
      name: name,
      balance: initialAmount,
      transactions: [
        BankrollTransaction(
          amount: initialAmount,
          type: 'initial',
          timestamp: DateTime.now(),
          note: 'Initial bankroll setup',
        ),
      ],
    );
    _bankrolls.add(bankroll);
    notifyListeners();
    _saveData();
  }

  void updateBankrollBalance(
    int index,
    double newBalance,
    List<BankrollTransaction> transactions,
  ) {
    if (index < _bankrolls.length) {
      _bankrolls[index] = _bankrolls[index].copyWith(
        balance: newBalance,
        transactions: transactions,
      );
      notifyListeners();
      _saveData();
    }
  }
}
