import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lend_borrow_tracker/src/features/contacts/domain/contact.dart'
    as domain;
import 'package:lend_borrow_tracker/src/features/transactions/data/transactions_repository.dart';
import 'package:lend_borrow_tracker/src/features/transactions/domain/transaction.dart'
    as domain;
import 'package:lend_borrow_tracker/src/features/transactions/domain/transaction_direction.dart';
import 'package:lend_borrow_tracker/src/features/transactions/presentation/add_edit_transaction_dialog.dart';

class TransactionHistoryScreen extends ConsumerWidget {
  final domain.Contact contact;

  const TransactionHistoryScreen({super.key, required this.contact});

  void _showAddTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AddEditTransactionDialog(contactId: contact.id),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(
      transactionsStreamProvider(contact.id),
    );
    final balanceAsync = ref.watch(contactBalanceStreamProvider(contact.id));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contact.name),
            balanceAsync.when(
              data: (balance) => Text(
                'Balance: PKR ${balance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return Center(
              child: Text(
                'No transactions with ${contact.name} yet.\nTap the \'+\' button to log your first one!',
                textAlign: TextAlign.center,
              ),
            );
          }

          // Calculate running balance
          final transactionsWithRunningBalance =
              <(domain.Transaction, double)>[];
          double runningBalance = 0;
          // Sort oldest to newest for calculation
          final sortedForCalc = List<domain.Transaction>.from(transactions)
            ..sort((a, b) => a.date.compareTo(b.date));
          for (final t in sortedForCalc) {
            if (t.direction == TransactionDirection.lent) {
              runningBalance += t.amount;
            } else {
              runningBalance -= t.amount;
            }
            transactionsWithRunningBalance.add((t, runningBalance));
          }
          // Reverse for display (newest first)
          final displayList = transactionsWithRunningBalance.reversed.toList();

          return ListView.builder(
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final item = displayList[index];
              final transaction = item.$1;
              final runningBalance = item.$2;
              final isLent = transaction.direction == TransactionDirection.lent;
              final amountColor = isLent ? Colors.green : Colors.red;

              return ListTile(
                title: Text(
                  transaction.description.isEmpty
                      ? (isLent ? 'You Lent' : 'You Received')
                      : transaction.description,
                ),
                subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isLent ? '+' : '-'}PKR ${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: amountColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Balance: ${runningBalance.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                onLongPress: () {
                  // Show edit dialog
                  showDialog(
                    context: context,
                    builder: (_) => AddEditTransactionDialog(
                      contactId: contact.id,
                      transaction: transaction,
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
