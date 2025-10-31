import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/session.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/custom_button.dart' as custom;

/// Bottom sheet for adding or logging a new session
class AddSessionSheet extends StatefulWidget {
  final Session? existingSession;

  const AddSessionSheet({Key? key, this.existingSession}) : super(key: key);

  @override
  State<AddSessionSheet> createState() => _AddSessionSheetState();
}

class _AddSessionSheetState extends State<AddSessionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _buyInController = TextEditingController();
  final _cashOutController = TextEditingController();
  final _stakesController = TextEditingController();
  final _compsController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedGame = GameType.all.first;
  DateTime _startTime = DateTime.now();
  DateTime? _endTime;
  List<String> _tags = [];
  bool _isLiveSession = false;
  Timer? _liveTimer;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.existingSession != null) {
      _initializeFromSession(widget.existingSession!);
    }
  }

  void _initializeFromSession(Session session) {
    _selectedGame = session.game;
    _locationController.text = session.location;
    _startTime = session.startTime;
    _endTime = session.endTime;
    _buyInController.text = session.buyIn.toStringAsFixed(0);
    _cashOutController.text = session.cashOut.toStringAsFixed(0);
    _stakesController.text = session.stakes?.toStringAsFixed(0) ?? '';
    _compsController.text = session.comps ?? '';
    _notesController.text = session.notes ?? '';
    _tags = List.from(session.tags);
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    _locationController.dispose();
    _buyInController.dispose();
    _cashOutController.dispose();
    _stakesController.dispose();
    _compsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _startLiveSession() {
    setState(() {
      _isLiveSession = true;
      _startTime = DateTime.now();
      _elapsedTime = Duration.zero;
    });

    _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedTime = DateTime.now().difference(_startTime);
        });
      }
    });
  }

  void _stopLiveSession() {
    setState(() {
      _isLiveSession = false;
      _endTime = DateTime.now();
    });
    _liveTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXL),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXL),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.glassBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: AppSpacing.cardPadding,
                    right: AppSpacing.cardPadding,
                    top: AppSpacing.cardPadding,
                    bottom:
                        MediaQuery.of(context).viewInsets.bottom +
                        AppSpacing.cardPadding,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _isLiveSession ? 'Live Session' : 'Log Session',
                              style: AppTypography.headingLStyle(),
                            ),
                            custom.IconButtonCustom(
                              icon: Icons.close_rounded,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),

                        if (_isLiveSession) ...[
                          const SizedBox(height: AppSpacing.xl),
                          _buildLiveTimer(),
                        ],

                        const SizedBox(height: AppSpacing.xl),

                        // Game selector
                        Text('Game', style: AppTypography.labelStyle()),
                        const SizedBox(height: AppSpacing.xs),
                        _buildGameSelector(),

                        const SizedBox(height: AppSpacing.lg),

                        // Location
                        Text('Location', style: AppTypography.labelStyle()),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _locationController,
                          style: AppTypography.inputStyle(),
                          decoration: const InputDecoration(
                            hintText: 'e.g., MGM Grand',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a location';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Buy-in and Cash-out
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Buy-in',
                                    style: AppTypography.labelStyle(),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  TextFormField(
                                    controller: _buyInController,
                                    style: AppTypography.inputStyle(),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: '\$0',
                                      prefixText: '\$ ',
                                    ),
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
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cash-out',
                                    style: AppTypography.labelStyle(),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  TextFormField(
                                    controller: _cashOutController,
                                    style: AppTypography.inputStyle(),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: '\$0',
                                      prefixText: '\$ ',
                                    ),
                                    enabled: !_isLiveSession,
                                    validator: !_isLiveSession
                                        ? (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Required';
                                            }
                                            if (double.tryParse(value) ==
                                                null) {
                                              return 'Invalid';
                                            }
                                            return null;
                                          }
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Stakes (optional)
                        Text(
                          'Table Min / Stakes (optional)',
                          style: AppTypography.labelStyle(),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _stakesController,
                          style: AppTypography.inputStyle(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '\$0',
                            prefixText: '\$ ',
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Comps (optional)
                        Text(
                          'Comps Received (optional)',
                          style: AppTypography.labelStyle(),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _compsController,
                          style: AppTypography.inputStyle(),
                          decoration: const InputDecoration(
                            hintText: 'e.g., Free buffet, Hotel room',
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Notes
                        Text(
                          'Notes (optional)',
                          style: AppTypography.labelStyle(),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _notesController,
                          style: AppTypography.inputStyle(),
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Add any notes about this session...',
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        // Action buttons
                        if (!_isLiveSession)
                          Column(
                            children: [
                              custom.CustomButton(
                                text: 'Save Session',
                                isFullWidth: true,
                                onPressed: _saveSession,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              custom.CustomButton(
                                text: 'Start Live Timer',
                                icon: Icons.timer_outlined,
                                style: custom.ButtonStyle.outline,
                                isFullWidth: true,
                                onPressed: _startLiveSession,
                              ),
                            ],
                          )
                        else
                          custom.CustomButton(
                            text: 'End Session',
                            icon: Icons.stop_rounded,
                            isFullWidth: true,
                            onPressed: _stopLiveSession,
                          ),
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

  Widget _buildGameSelector() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: GameType.all.map((game) {
        final isSelected = _selectedGame == game;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedGame = game;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.getGameGradient(game) : null,
              color: isSelected ? null : AppColors.glassBorder,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
              border: isSelected
                  ? null
                  : Border.all(color: AppColors.glassBorder, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_getGameEmoji(game), style: const TextStyle(fontSize: 18)),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  game,
                  style: AppTypography.bodyMStyle(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLiveTimer() {
    final hours = _elapsedTime.inHours;
    final minutes = _elapsedTime.inMinutes % 60;
    final seconds = _elapsedTime.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppColors.primaryButtonGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricBlueGlow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('Session in Progress', style: AppTypography.labelStyle()),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: AppTypography.displayLStyle().copyWith(
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Started at ${_formatTime(_startTime)}',
            style: AppTypography.bodyXSStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  String _getGameEmoji(String game) {
    switch (game) {
      case 'Slots':
        return '🎰';
      case 'Blackjack':
        return '🃏';
      case 'Poker':
        return '♠️';
      case 'Roulette':
        return '🎡';
      case 'Craps':
        return '🎲';
      default:
        return '🎮';
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  void _saveSession() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final session = Session(
      game: _selectedGame,
      location: _locationController.text,
      startTime: _startTime,
      endTime: _endTime ?? DateTime.now(),
      buyIn: double.parse(_buyInController.text),
      cashOut: double.parse(_cashOutController.text),
      stakes: _stakesController.text.isNotEmpty
          ? double.tryParse(_stakesController.text)
          : null,
      comps: _compsController.text.isNotEmpty ? _compsController.text : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      tags: _tags,
    );

    context.read<AppState>().addSession(session);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session saved successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
