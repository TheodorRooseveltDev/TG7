import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/premium_theme.dart';

/// Premium glass modal for adding a new session
class AddSessionModal extends StatefulWidget {
  const AddSessionModal({Key? key}) : super(key: key);

  @override
  State<AddSessionModal> createState() => _AddSessionModalState();
}

class _AddSessionModalState extends State<AddSessionModal> {
  final _formKey = GlobalKey<FormState>();
  final _casinoController = TextEditingController();
  final _gameController = TextEditingController();
  final _buyInController = TextEditingController();
  final _cashOutController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _durationMinutes = 0;

  @override
  void dispose() {
    _casinoController.dispose();
    _gameController.dispose();
    _buyInController.dispose();
    _cashOutController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: PremiumTheme.primaryBlue,
              onPrimary: Colors.white,
              surface: PremiumTheme.spaceBlackTop,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: PremiumTheme.deepNavyCenter,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: PremiumTheme.primaryBlue,
              onPrimary: Colors.white,
              surface: PremiumTheme.spaceBlackTop,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: PremiumTheme.deepNavyCenter,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _calculateDuration() {
    // Simple duration calculation based on buy-in and cash-out times
    // In a real app, you'd have start and end time fields
    setState(() {
      _durationMinutes = 120; // Default 2 hours
    });
  }

  void _saveSession() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save session logic
      Navigator.pop(context, {
        'casino': _casinoController.text,
        'game': _gameController.text,
        'buyIn': double.tryParse(_buyInController.text) ?? 0,
        'cashOut': double.tryParse(_cashOutController.text) ?? 0,
        'date': _selectedDate,
        'time': _selectedTime,
        'duration': _durationMinutes,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: PremiumTheme.glassActionButton.copyWith(
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Title with gradient
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                PremiumTheme.primaryBlue,
                                PremiumTheme.gradientPurple,
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'Add Session',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w200,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Casino field
                          _buildInputLabel('Casino'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _casinoController,
                            hint: 'Enter casino name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter casino name';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Game field
                          _buildInputLabel('Game'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _gameController,
                            hint: 'Enter game name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter game name';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Buy-in and Cash-out row
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInputLabel('Buy-in'),
                                    const SizedBox(height: 8),
                                    _buildTextField(
                                      controller: _buyInController,
                                      hint: '\$0.00',
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Invalid';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInputLabel('Cash-out'),
                                    const SizedBox(height: 8),
                                    _buildTextField(
                                      controller: _cashOutController,
                                      hint: '\$0.00',
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Invalid';
                                        }
                                        return null;
                                      },
                                      onChanged: (_) => _calculateDuration(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Date and Time row
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInputLabel('Date'),
                                    const SizedBox(height: 8),
                                    _buildDateTimeButton(
                                      label:
                                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                      onTap: _selectDate,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInputLabel('Time'),
                                    const SizedBox(height: 8),
                                    _buildDateTimeButton(
                                      label: _selectedTime.format(context),
                                      onTap: _selectTime,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Duration
                          _buildInputLabel('Duration'),
                          const SizedBox(height: 8),
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    '${_durationMinutes ~/ 60}h ${_durationMinutes % 60}m',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Action buttons
                          Row(
                            children: [
                              Expanded(child: _buildCancelButton()),
                              const SizedBox(width: 12),
                              Expanded(child: _buildSaveButton()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w300,
        color: Colors.white.withOpacity(0.5),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.white.withOpacity(0.3),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              errorStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: const Center(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return InkWell(
      onTap: _saveSession,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: PremiumTheme.bluePurpleGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: PremiumTheme.primaryBlue.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Save Session',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper function to show the modal
Future<Map<String, dynamic>?> showAddSessionModal(BuildContext context) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => const AddSessionModal(),
  );
}
