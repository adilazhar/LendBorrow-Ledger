import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lend_borrow_tracker/src/db/app_database.dart';
import 'package:lend_borrow_tracker/src/features/contacts/domain/contact.dart'
    as domain;
import 'package:lend_borrow_tracker/src/features/transactions/domain/dashboard_summary.dart';
import 'package:lend_borrow_tracker/src/features/transactions/domain/transaction.dart'
    as domain;
import 'package:lend_borrow_tracker/src/features/transactions/domain/transaction_direction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

part 'transactions_repository.g.dart';

class TransactionsRepository {
  TransactionsRepository(this._db);
  final AppDatabase _db;

  // Watch all transactions for a specific contact, newest first
  Stream<List<domain.Transaction>> watchTransactionsForContact(int contactId) {
    final query = _db.select(_db.transactions)
      ..where((t) => t.contactId.equals(contactId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
      ]);

    return query.watch().map((rows) {
      return rows
          .map(
            (row) => domain.Transaction(
              id: row.id,
              contactId: row.contactId,
              amount: row.amount,
              direction: row.direction,
              description: row.description,
              date: row.date,
            ),
          )
          .toList();
    });
  }

  // Watch all transactions for a specific contact, newest first
  Future<List<domain.Transaction>> fetchTransactionsForContact(
    int contactId,
  ) async {
    final query = _db.select(_db.transactions)
      ..where((t) => t.contactId.equals(contactId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
      ]);

    final rows = await query.get();

    return rows
        .map(
          (row) => domain.Transaction(
            id: row.id,
            contactId: row.contactId,
            amount: row.amount,
            direction: row.direction,
            description: row.description,
            date: row.date,
          ),
        )
        .toList();
  }

  // Add a new transaction
  Future<void> addTransaction({
    required int contactId,
    required double amount,
    required TransactionDirection direction,
    required String description,
    required DateTime date,
  }) async {
    final companion = TransactionsCompanion.insert(
      contactId: contactId,
      amount: amount,
      direction: direction,
      description: description,
      date: date,
    );
    await _db.into(_db.transactions).insert(companion);
  }

  // Update an existing transaction
  Future<void> updateTransaction({
    required int transactionId,
    required double amount,
    required TransactionDirection direction,
    required String description,
    required DateTime date,
  }) async {
    final companion = TransactionsCompanion(
      amount: Value(amount),
      direction: Value(direction),
      description: Value(description),
      date: Value(date),
    );
    await (_db.update(
      _db.transactions,
    )..where((t) => t.id.equals(transactionId))).write(companion);
  }

  // Delete a transaction
  Future<void> deleteTransaction(int transactionId) {
    return (_db.delete(
      _db.transactions,
    )..where((t) => t.id.equals(transactionId))).go();
  }

  // Add this method inside the TransactionsRepository class
  Stream<double> watchContactBalance(int contactId) {
    return watchTransactionsForContact(contactId).map((transactions) {
      final totalLent = transactions
          .where((t) => t.direction == TransactionDirection.lent)
          .map((t) => t.amount)
          .sum;
      final totalReceived = transactions
          .where((t) => t.direction == TransactionDirection.received)
          .map((t) => t.amount)
          .sum;
      return totalLent - totalReceived;
    });
  }

  Future<double> fetchContactBalance(int contactId) async {
    // Await the single list of transactions from the future-based method
    final transactions = await fetchTransactionsForContact(contactId);

    // The calculation logic remains the same
    final totalLent = transactions
        .where((t) => t.direction == TransactionDirection.lent)
        .map((t) => t.amount)
        .sum; // Assuming .sum is an extension on Iterable<num>

    final totalReceived = transactions
        .where((t) => t.direction == TransactionDirection.received)
        .map((t) => t.amount)
        .sum; // Assuming .sum is an extension on Iterable<num>

    return totalLent - totalReceived;
  }

  Stream<DashboardSummary> watchDashboardSummary() {
    // Use CombineLatestStream to react to changes from either contacts or transactions.
    return CombineLatestStream.combine2(
      // GOOD: The stream of contacts is immediately mapped to your domain model.
      // This decouples your business logic from the database implementation.
      _db.select(_db.contacts).watch().map((databaseContacts) {
        return databaseContacts
            .map(
              (dbContact) =>
                  domain.Contact(id: dbContact.id, name: dbContact.name),
            )
            .toList();
      }),
      // GOOD: The stream of transactions is also mapped to your domain model right away.
      _db.select(_db.transactions).watch().map((databaseTransactions) {
        return databaseTransactions
            .map(
              (dbTransaction) => domain.Transaction(
                id: dbTransaction.id,
                contactId: dbTransaction.contactId,
                amount: dbTransaction.amount,
                direction: dbTransaction.direction,
                description: dbTransaction.description,
                date: dbTransaction.date,
              ),
            )
            .toList();
      }),
      // The combiner function now operates purely on your domain models, which is excellent.
      (List<domain.Contact> contacts, List<domain.Transaction> transactions) {
        final contactMap = {for (var c in contacts) c.id: c};
        final transactionsByContact = groupBy(transactions, (t) => t.contactId);
        final friendBalances = <FriendBalance>[];

        for (final entry in transactionsByContact.entries) {
          final contact = contactMap[entry.key];
          if (contact == null) {
            continue; // Data is consistent, skips orphaned transactions.
          }

          final lent = entry.value
              .where((t) => t.direction == TransactionDirection.lent)
              .map((t) => t.amount)
              .sum;

          final received = entry.value
              .where((t) => t.direction == TransactionDirection.received)
              .map((t) => t.amount)
              .sum;

          final balance = lent - received;

          if (balance.abs() > 0.001) {
            friendBalances.add(
              FriendBalance(
                contact: contact,
                balance: balance,
              ),
            );
          }
        }

        friendBalances.sort((a, b) => a.contact.name.compareTo(b.contact.name));

        final totalOwedToYou = friendBalances
            .where((fb) => fb.balance > 0)
            .map((fb) => fb.balance)
            .sum;

        final totalOwedByYou = friendBalances
            .where((fb) => fb.balance < 0)
            .map((fb) => fb.balance.abs())
            .sum;

        return DashboardSummary(
          totalOwedToYou: totalOwedToYou,
          totalOwedByYou: totalOwedByYou,
          netBalance: totalOwedToYou - totalOwedByYou,
          friendBalances: friendBalances,
        );
      },
    );
  }
}

@Riverpod(keepAlive: true)
TransactionsRepository transactionsRepository(Ref ref) {
  // It depends on the appDatabaseProvider
  return TransactionsRepository(ref.watch(appDatabaseProvider));
}

@riverpod
Stream<List<domain.Transaction>> transactionsStream(Ref ref, int contactId) {
  final repo = ref.watch(transactionsRepositoryProvider);
  return repo.watchTransactionsForContact(contactId);
}

@riverpod
Future<List<domain.Transaction>> fetchTransactionsForContact(
  Ref ref,
  int contactId,
) {
  final transactionsRepo = ref.watch(transactionsRepositoryProvider);
  return transactionsRepo.fetchTransactionsForContact(contactId);
}

@riverpod
Stream<double> contactBalanceStream(
  Ref ref,
  int contactId,
) {
  final repo = ref.watch(transactionsRepositoryProvider);
  return repo.watchContactBalance(contactId);
}

@riverpod
Future<double> fetchContactBalance(
  Ref ref,
  int contactId,
) {
  final repo = ref.watch(transactionsRepositoryProvider);
  return repo.fetchContactBalance(contactId);
}

// Add this to transactions_providers.dart
@riverpod
Stream<DashboardSummary> dashboardSummary(Ref ref) {
  final repo = ref.watch(transactionsRepositoryProvider);
  return repo.watchDashboardSummary();
}
