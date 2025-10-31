import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/gradient_orb.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/custom_button.dart';
import '../../providers/app_state.dart';
import '../../models/bankroll.dart';

class BankrollScreen extends StatefulWidget {
  const BankrollScreen({Key? key}) : super(key: key);

  @override
  State<BankrollScreen> createState() => _BankrollScreenState();
}

class _BankrollScreenState extends State<BankrollScreen> {
  void _showAddTransactionSheet(BuildContext context, bool isDeposit) {
    final amountController = TextEditingController();
    final notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            gradient: AppColors.glassCardGradient,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXL),
            ),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              left: AppSpacing.screenMarginMobile,
              right: AppSpacing.screenMarginMobile,
              top: AppSpacing.xl,
              bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isDeposit ? 'Add Funds' : 'Withdraw Funds',
                      style: AppTypography.headingLStyle(),
                    ),
                    IconButtonCustom(
                      icon: Icons.close,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Amount', style: AppTypography.bodyLStyle()),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: AppTypography.bodyLStyle(),
                  decoration: InputDecoration(
                    hintText: '\$0.00',
                    hintStyle: AppTypography.bodyLStyle(
                      color: AppColors.textQuaternary,
                    ),
                    filled: true,
                    fillColor: AppColors.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(
                        color: AppColors.electricBluePrimary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Notes (Optional)', style: AppTypography.bodyLStyle()),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  style: AppTypography.bodyLStyle(),
                  decoration: InputDecoration(
                    hintText: 'Add any notes...',
                    hintStyle: AppTypography.bodyLStyle(
                      color: AppColors.textQuaternary,
                    ),
                    filled: true,
                    fillColor: AppColors.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(
                        color: AppColors.electricBluePrimary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                CustomButton(
                  text: isDeposit ? 'Add Funds' : 'Withdraw',
                  onPressed: () {
                    final amount = double.tryParse(amountController.text);
                    if (amount != null && amount > 0) {
                      final appState = context.read<AppState>();
                      final transaction = BankrollTransaction(
                        amount: isDeposit ? amount : -amount,
                        type: isDeposit ? 'deposit' : 'withdrawal',
                        timestamp: DateTime.now(),
                        note: notesController.text.isEmpty
                            ? null
                            : notesController.text,
                      );

                      // Update bankroll balance
                      if (appState.bankrolls.isNotEmpty) {
                        final bankroll = appState.bankrolls.first;
                        final newBalance =
                            bankroll.balance + (isDeposit ? amount : -amount);
                        final updatedTransactions = [
                          ...bankroll.transactions,
                          transaction,
                        ];
                        appState.updateBankrollBalance(
                          0,
                          newBalance,
                          updatedTransactions,
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: GradientOrbBackground(
        child: SafeArea(
          child: Consumer<AppState>(
            builder: (context, state, child) {
              final bankroll = state.bankrolls.isNotEmpty
                  ? state.bankrolls.first
                  : Bankroll(
                      name: 'Main Bankroll',
                      balance: 0,
                      transactions: [],
                    );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screenMarginMobile),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bankroll', style: AppTypography.headingXLStyle()),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Manage your gaming budget',
                      style: AppTypography.bodyMStyle(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Balance Card
                    SimpleGlassCard(
                      child: Column(
                        children: [
                          Text(
                            'Current Balance',
                            style: AppTypography.bodyLStyle(
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            NumberFormat.currency(
                              symbol: '\$',
                              decimalDigits: 2,
                            ).format(bankroll.balance),
                            style: AppTypography.displayLStyle(),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'Add Funds',
                                  onPressed: () =>
                                      _showAddTransactionSheet(context, true),
                                  style: ButtonStyle.primary,
                                  icon: Icons.add,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: CustomButton(
                                  text: 'Withdraw',
                                  onPressed: () =>
                                      _showAddTransactionSheet(context, false),
                                  style: ButtonStyle.secondary,
                                  icon: Icons.remove,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    // Transaction History
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaction History',
                          style: AppTypography.headingLStyle(),
                        ),
                        Text(
                          '${bankroll.transactions.length} total',
                          style: AppTypography.bodyMStyle(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),

                    if (bankroll.transactions.isEmpty)
                      SimpleGlassCard(
                        child: Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 48,
                                color: AppColors.textQuaternary,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'No transactions yet',
                                style: AppTypography.bodyLStyle(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Add funds to get started',
                                style: AppTypography.bodyMStyle(
                                  color: AppColors.textQuaternary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...bankroll.transactions.reversed.map((transaction) {
                        final isDeposit = transaction.type == 'deposit';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: SimpleGlassCard(
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isDeposit
                                        ? AppColors.successGreen.withOpacity(
                                            0.2,
                                          )
                                        : AppColors.errorRed.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusMD,
                                    ),
                                  ),
                                  child: Icon(
                                    isDeposit ? Icons.add : Icons.remove,
                                    color: isDeposit
                                        ? AppColors.successGreen
                                        : AppColors.errorRed,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isDeposit ? 'Deposit' : 'Withdrawal',
                                        style: AppTypography.bodyLStyle(),
                                      ),
                                      const SizedBox(height: AppSpacing.xxs),
                                      Text(
                                        DateFormat(
                                          'MMM d, y • h:mm a',
                                        ).format(transaction.timestamp),
                                        style: AppTypography.bodyMStyle(
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                      if (transaction.note != null) ...[
                                        const SizedBox(height: AppSpacing.xxs),
                                        Text(
                                          transaction.note!,
                                          style: AppTypography.bodyMStyle(
                                            color: AppColors.textQuaternary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Text(
                                  NumberFormat.currency(
                                    symbol: '\$',
                                    decimalDigits: 2,
                                  ).format(transaction.amount.abs()),
                                  style: AppTypography.headingSStyle(
                                    color: isDeposit
                                        ? AppColors.successGreen
                                        : AppColors.errorRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
