import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/premium_theme.dart';
import '../../shared/widgets/space_background.dart';
import '../../providers/app_state.dart';
import '../../models/bankroll.dart';

/// Premium Bankroll Screen with Glass Design
class PremiumBankrollScreen extends StatefulWidget {
  const PremiumBankrollScreen({Key? key}) : super(key: key);

  @override
  State<PremiumBankrollScreen> createState() => _PremiumBankrollScreenState();
}

class _PremiumBankrollScreenState extends State<PremiumBankrollScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        forceMaterialTransparency: true,
        title: const Text(''),
      ),
      body: SpaceBackground(
        child: Consumer<AppState>(
          builder: (context, state, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance Section
                    _buildBalanceSection(context, state),

                    const SizedBox(height: 24),

                    // Action Buttons
                    _buildActionButtons(context, state),

                    const SizedBox(height: 32),

                    // Quick Stats
                    _buildQuickStats(context, state),

                    const SizedBox(height: 24),

                    // Transactions List
                    _buildTransactionsList(context, state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBalanceSection(BuildContext context, AppState state) {
    final currencySymbol = state.preferences.currencySymbol;
    return Padding(
      padding: const EdgeInsets.only(
        top: 80,
        left: PremiumTheme.screenHorizontalPadding,
        right: PremiumTheme.screenHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bankroll',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: PremiumTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage your gaming budget',
            style: TextStyle(
              fontSize: 14,
              color: PremiumTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 32),
          // Gradient Balance Text
          ShaderMask(
            shaderCallback: (bounds) =>
                PremiumTheme.balanceTextGradient.createShader(bounds),
            child: Text(
              '$currencySymbol${NumberFormat('#,##0').format(state.currentBankroll.toInt())}',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w200,
                letterSpacing: -1.5,
                color: Colors.white,
                shadows: PremiumTheme.balanceTextShadow,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Initial bankroll (only show if > 0)
          if (state.initialBankroll > 0)
            Text(
              'Started with $currencySymbol${NumberFormat('#,##0').format(state.initialBankroll.toInt())}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: PremiumTheme.textTertiary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AppState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumTheme.screenHorizontalPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.add_rounded,
              label: 'Add Funds',
              color: PremiumTheme.successGreen,
              onTap: () => _showTransactionModal(context, state, true),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.remove_rounded,
              label: 'Withdraw',
              color: PremiumTheme.lossRed,
              onTap: () => _showTransactionModal(context, state, false),
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionModal(BuildContext context, AppState state, bool isDeposit) {
    final currencySymbol = state.preferences.currencySymbol;
    final amountController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            constraints: const BoxConstraints(maxWidth: 400),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: PremiumTheme.deepNavyCenter.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isDeposit ? 'Add Funds' : 'Withdraw Funds',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: PremiumTheme.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: PremiumTheme.textSecondary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Amount field
                    const Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: PremiumTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(
                        fontSize: 16,
                        color: PremiumTheme.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: '$currencySymbol 0.00',
                        hintStyle: TextStyle(
                          color: PremiumTheme.textQuaternary,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: PremiumTheme.primaryBlue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Notes field
                    const Text(
                      'Notes (Optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: PremiumTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 16,
                        color: PremiumTheme.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add any notes...',
                        hintStyle: TextStyle(
                          color: PremiumTheme.textQuaternary,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: PremiumTheme.primaryBlue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: PremiumTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final amount = double.tryParse(amountController.text);
                              if (amount != null && amount > 0) {
                                // Add transaction to bankroll
                                if (state.bankrolls.isEmpty) {
                                  // Initialize bankroll if it doesn't exist
                                  state.initializeBankroll('Main Bankroll', amount);
                                } else {
                                  final bankroll = state.bankrolls.first;
                                  final transaction = BankrollTransaction(
                                    amount: isDeposit ? amount : -amount,
                                    type: isDeposit ? 'deposit' : 'withdrawal',
                                    timestamp: DateTime.now(),
                                    note: notesController.text.isEmpty ? null : notesController.text,
                                  );
                                  
                                  final newBalance = bankroll.balance + (isDeposit ? amount : -amount);
                                  final updatedTransactions = [
                                    ...bankroll.transactions,
                                    transaction,
                                  ];
                                  
                                  state.updateBankrollBalance(0, newBalance, updatedTransactions);
                                }
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: PremiumTheme.gradientButtonDecoration,
                              alignment: Alignment.center,
                              child: Text(
                                isDeposit ? 'Add Funds' : 'Withdraw',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
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
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: PremiumTheme.glassActionButton,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: PremiumTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, AppState state) {
    final currencySymbol = state.preferences.currencySymbol;
    // Calculate deposits and withdrawals from all bankroll transactions
    double deposits = 0;
    double withdrawals = 0;

    for (var bankroll in state.bankrolls) {
      for (var transaction in bankroll.transactions) {
        if (transaction.type == 'deposit') {
          deposits += transaction.amount.abs();
        } else if (transaction.type == 'withdrawal') {
          withdrawals += transaction.amount.abs();
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumTheme.screenHorizontalPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: PremiumTheme.glassActionButton,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_downward,
                        size: 16,
                        color: PremiumTheme.successGreen,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Deposits',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: PremiumTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$currencySymbol${NumberFormat('#,##0.00').format(deposits)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: PremiumTheme.successGreen,
                    ),
                  ),
                ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: PremiumTheme.glassActionButton,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        size: 16,
                        color: PremiumTheme.lossRed,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Withdrawals',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: PremiumTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$currencySymbol${NumberFormat('#,##0.00').format(withdrawals)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: PremiumTheme.lossRed,
                    ),
                  ),
                ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(BuildContext context, AppState state) {
    final currencySymbol = state.preferences.currencySymbol;
    // Collect all transactions from all bankrolls
    final allTransactions = <Map<String, dynamic>>[];

    for (var bankroll in state.bankrolls) {
      for (var transaction in bankroll.transactions) {
        allTransactions.add({
          'transaction': transaction,
          'bankrollName': bankroll.name,
        });
      }
    }

    // Sort by timestamp descending
    allTransactions.sort(
      (a, b) => (b['transaction'].timestamp as DateTime).compareTo(
        a['transaction'].timestamp as DateTime,
      ),
    );

    if (allTransactions.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumTheme.screenHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TRANSACTIONS',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: PremiumTheme.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: allTransactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = allTransactions[index];
              final transaction = item['transaction'];
              final isDeposit = transaction.type == 'deposit';

              return Container(
                decoration: PremiumTheme.glassActionButton,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                    // Icon with circular gradient
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDeposit
                              ? [
                                  PremiumTheme.successGreen,
                                  PremiumTheme.successGreen.withOpacity(0.7),
                                ]
                              : [
                                  PremiumTheme.lossRed,
                                  PremiumTheme.lossRed.withOpacity(0.7),
                                ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isDeposit ? 'Deposit' : 'Withdrawal',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat(
                              'MMM d, yyyy • h:mm a',
                            ).format(transaction.timestamp),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          if (transaction.note != null &&
                              transaction.note!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              transaction.note!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.white.withOpacity(0.4),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Amount
                    Text(
                      '${isDeposit ? '+' : '-'}$currencySymbol${transaction.amount.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: isDeposit
                            ? PremiumTheme.successGreen
                            : PremiumTheme.lossRed,
                      ),
                    ),
                  ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PremiumTheme.screenHorizontalPadding,
      ),
      child: Container(
        decoration: PremiumTheme.glassActionButton,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(32),
              child: const Column(
                children: [
            Icon(
              Icons.account_balance_wallet_rounded,
              size: 64,
              color: PremiumTheme.textQuaternary,
            ),
            SizedBox(height: 16),
            Text(
              'No Transactions Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: PremiumTheme.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add your first deposit or withdrawal\nto start tracking your bankroll',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: PremiumTheme.textTertiary),
            ),
          ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
