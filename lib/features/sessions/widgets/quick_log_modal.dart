import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/premium_theme.dart';
import '../../../core/assets/app_assets.dart';
import '../../../providers/app_state.dart';
import '../../../models/session.dart';
import '../../../shared/widgets/custom_toast.dart';

/// Comprehensive Quick Log Modal
/// Fields: Game, Location, Start/End Times, Buy-in, Cash-out, Stakes, Comps, Notes, Tags
/// Actions: Save, Cancel
class QuickLogModal extends StatefulWidget {
  const QuickLogModal({super.key});

  @override
  State<QuickLogModal> createState() => _QuickLogModalState();
}

class _QuickLogModalState extends State<QuickLogModal> {
  final _formKey = GlobalKey<FormState>();
  
  // Form field controllers
  String _selectedGame = 'Slots';
  final _locationController = TextEditingController();
  DateTime _startTime = DateTime.now().subtract(const Duration(hours: 2));
  DateTime _endTime = DateTime.now();
  final _buyInController = TextEditingController(text: '100');
  final _cashOutController = TextEditingController(text: '0');
  final _stakesController = TextEditingController();
  final _compsController = TextEditingController(text: '0');
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  
  // Focus nodes for clearing "0" on tap
  final _cashOutFocusNode = FocusNode();
  final _compsFocusNode = FocusNode();
  
  final List<String> _games = [
    'Slots',
    'Blackjack',
    'Poker',
    'Roulette',
    'Craps',
    'Baccarat',
    'Other'
  ];
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Clear "0" when cash-out field is focused
    _cashOutFocusNode.addListener(() {
      if (_cashOutFocusNode.hasFocus && _cashOutController.text == '0') {
        _cashOutController.clear();
      }
    });
    
    // Clear "0" when comps field is focused
    _compsFocusNode.addListener(() {
      if (_compsFocusNode.hasFocus && _compsController.text == '0') {
        _compsController.clear();
      }
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _buyInController.dispose();
    _cashOutController.dispose();
    _stakesController.dispose();
    _compsController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    _cashOutFocusNode.dispose();
    _compsFocusNode.dispose();
    super.dispose();
  }

  double get _buyIn => double.tryParse(_buyInController.text) ?? 0;
  double get _cashOut => double.tryParse(_cashOutController.text) ?? 0;
  double get _comps => double.tryParse(_compsController.text) ?? 0;
  double get _netProfit => _cashOut - _buyIn + _comps;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context, listen: false);
    final recentLocations = _getRecentLocations(state);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        gradient: PremiumTheme.spaceBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGameSelector(),
                        const SizedBox(height: 20),
                        _buildLocationField(recentLocations),
                        const SizedBox(height: 20),
                        _buildTimeFields(),
                        const SizedBox(height: 20),
                        _buildMoneyFields(),
                        const SizedBox(height: 20),
                        _buildStakesAndComps(),
                        const SizedBox(height: 20),
                        _buildNotesField(),
                        const SizedBox(height: 20),
                        _buildTagsField(),
                        const SizedBox(height: 32),
                        _buildActions(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: PremiumTheme.textSecondary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: PremiumTheme.bluePurpleGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.add_chart, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Quick Log Session',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: PremiumTheme.textPrimary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: PremiumTheme.textSecondary),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildGameSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Game *',
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
              child: DropdownButtonFormField<String>(
                initialValue: _selectedGame,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                dropdownColor: PremiumTheme.deepNavyBottom,
                style: const TextStyle(
                  color: PremiumTheme.textPrimary,
                  fontSize: 16,
                ),
                items: _games.map((game) {
                  return DropdownMenuItem(
                    value: game,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset(
                            AppAssets.getGameIcon(game),
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(game),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedGame = value);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField(List<String> recentLocations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location *',
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
              child: TextFormField(
                controller: _locationController,
                style: const TextStyle(color: PremiumTheme.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'e.g., Caesar\'s Palace',
                  hintStyle: TextStyle(color: PremiumTheme.textSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: Icon(Icons.place, color: PremiumTheme.textSecondary),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Location is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        if (recentLocations.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recentLocations.take(3).map((location) {
              return GestureDetector(
                onTap: () => _locationController.text = location,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: PremiumTheme.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: PremiumTheme.textSecondary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.history, size: 14, color: PremiumTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: PremiumTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeFields() {
    return Row(
      children: [
        Expanded(child: _buildTimeField('Start Time *', _startTime, (time) {
          setState(() => _startTime = time);
        })),
        const SizedBox(width: 12),
        Expanded(child: _buildTimeField('End Time *', _endTime, (time) {
          setState(() => _endTime = time);
        })),
      ],
    );
  }

  Widget _buildTimeField(String label, DateTime value, Function(DateTime) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: PremiumTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDateTime(context, value, onChanged),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: PremiumTheme.glassActionButton,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, color: PremiumTheme.textSecondary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        DateFormat('MMM d, h:mm a').format(value),
                        style: const TextStyle(
                          color: PremiumTheme.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoneyFields() {
    final currencySymbol = context.read<AppState>().preferences.currencySymbol;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMoneyField('Buy-in *', _buyInController, Icons.arrow_downward, null),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMoneyField('Cash-out *', _cashOutController, Icons.arrow_upward, _cashOutFocusNode),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: _netProfit >= 0
                ? LinearGradient(
                    colors: [
                      PremiumTheme.successGreen.withOpacity(0.2),
                      PremiumTheme.successGreen.withOpacity(0.1),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      PremiumTheme.lossRed.withOpacity(0.2),
                      PremiumTheme.lossRed.withOpacity(0.1),
                    ],
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _netProfit >= 0
                  ? PremiumTheme.successGreen.withOpacity(0.5)
                  : PremiumTheme.lossRed.withOpacity(0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Net Profit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: PremiumTheme.textPrimary,
                ),
              ),
              Text(
                '${_netProfit >= 0 ? '+' : ''}$currencySymbol${_netProfit.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: _netProfit >= 0
                      ? PremiumTheme.successGreen
                      : PremiumTheme.lossRed,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoneyField(String label, TextEditingController controller, IconData icon, FocusNode? focusNode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
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
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: PremiumTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: const TextStyle(color: PremiumTheme.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: Icon(icon, color: PremiumTheme.textSecondary, size: 20),
                  prefixText: '\$ ',
                  prefixStyle: const TextStyle(
                    color: PremiumTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount < 0) {
                    return 'Invalid amount';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}), // Update net profit display
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStakesAndComps() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stakes',
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
                    child: TextFormField(
                      controller: _stakesController,
                      style: const TextStyle(color: PremiumTheme.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'e.g., \$5/\$10',
                        hintStyle: TextStyle(color: PremiumTheme.textSecondary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        prefixIcon: Icon(Icons.payments, color: PremiumTheme.textSecondary, size: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Comps',
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
                    child: TextFormField(
                      controller: _compsController,
                      focusNode: _compsFocusNode,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: PremiumTheme.textPrimary),
                      decoration: const InputDecoration(
                        hintText: '0.00',
                        hintStyle: TextStyle(color: PremiumTheme.textSecondary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        prefixIcon: Icon(Icons.card_giftcard, color: PremiumTheme.textSecondary, size: 20),
                        prefixText: '\$ ',
                        prefixStyle: TextStyle(
                          color: PremiumTheme.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                      onChanged: (_) => setState(() {}), // Update net profit display
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes',
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
              child: TextFormField(
                controller: _notesController,
                maxLines: 4,
                style: const TextStyle(color: PremiumTheme.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Add session notes...',
                  hintStyle: TextStyle(color: PremiumTheme.textSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
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
              child: TextFormField(
                controller: _tagsController,
                style: const TextStyle(color: PremiumTheme.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Separate tags with commas',
                  hintStyle: TextStyle(color: PremiumTheme.textSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: Icon(Icons.label, color: PremiumTheme.textSecondary, size: 20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        // Save Button
        _buildActionButton(
          label: 'Save Session',
          icon: Icons.check_circle_outline,
          gradient: PremiumTheme.bluePurpleGradient,
          onPressed: _isLoading ? null : () => _saveSession(false),
        ),
        const SizedBox(height: 12),
        // Cancel Button
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: PremiumTheme.textSecondary,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: onPressed == null ? null : gradient,
          color: onPressed == null ? PremiumTheme.textSecondary.withOpacity(0.3) : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: onPressed == null
              ? null
              : [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateTime(
    BuildContext context,
    DateTime currentValue,
    Function(DateTime) onChanged,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: currentValue,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: PremiumTheme.primaryBlue,
              surface: PremiumTheme.deepNavyBottom,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentValue),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: PremiumTheme.primaryBlue,
                surface: PremiumTheme.deepNavyBottom,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        onChanged(newDateTime);
      }
    }
  }

  void _saveSession(bool startLiveTimer) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate end time is after start time
    if (_endTime.isBefore(_startTime)) {
      _showError('End time must be after start time');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final state = Provider.of<AppState>(context, listen: false);
      
      // Parse tags
      final tags = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      // Create session
      final session = Session(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        game: _selectedGame,
        location: _locationController.text.trim(),
        startTime: _startTime,
        endTime: _endTime,
        buyIn: _buyIn,
        cashOut: _cashOut,
        stakes: _stakesController.text.trim().isEmpty ? null : double.tryParse(_stakesController.text.trim()),
        comps: _compsController.text.trim().isEmpty ? null : _compsController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        tags: tags.isEmpty ? null : tags,
      );

      state.addSession(session);

      if (context.mounted) {
        Navigator.pop(context);
        
        if (startLiveTimer) {
          // TODO: Navigate to live timer screen
          CustomToast.show(
            context,
            message: 'Live Timer feature - Coming soon!',
            icon: Icons.timer,
            isSuccess: true,
          );
        } else {
          CustomToast.show(
            context,
            message: 'Session saved successfully!',
            icon: Icons.check_circle,
            isSuccess: true,
          );
        }
      }
    } catch (e) {
      _showError('Failed to save session: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    CustomToast.show(
      context,
      message: message,
      icon: Icons.error_outline,
      isSuccess: false,
    );
  }

  List<String> _getRecentLocations(AppState state) {
    final locations = state.sessions
        .map((s) => s.location)
        .toSet()
        .toList();
    return locations;
  }
}
