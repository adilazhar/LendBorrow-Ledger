import 'package:lend_borrow_tracker/src/features/transactions/domain/transaction_direction.dart';

class Transaction {
  Transaction({
    required this.id,
    required this.contactId,
    required this.amount,
    required this.direction,
    required this.description,
    required this.date,
  });

  final int id;
  final int contactId;
  final double amount;
  final TransactionDirection direction;
  final String description;
  final DateTime date;
}
