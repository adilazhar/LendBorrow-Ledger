import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lend_borrow_tracker/src/db/app_database.dart';
import 'package:lend_borrow_tracker/src/features/contacts/data/contact_errors.dart';
import 'package:lend_borrow_tracker/src/features/contacts/domain/contact.dart'
    as domain;
import 'package:lend_borrow_tracker/src/features/transactions/domain/transaction_direction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contact_repository.g.dart';

class ContactsRepository {
  ContactsRepository(this._db);
  final AppDatabase _db;

  // Watch all contacts, ordered by name
  Stream<List<domain.Contact>> watchContacts({String query = ''}) {
    final select = _db.select(_db.contacts);

    // If the query is not empty, add a where clause
    if (query.isNotEmpty) {
      // Use .like() for partial matching. The '%' is a wildcard.
      // Use .lower() to make the search case-insensitive.
      select.where((t) => t.name.lower().like('%${query.toLowerCase()}%'));
    }

    // Always order by name
    select.orderBy([(t) => OrderingTerm(expression: t.name.lower())]);
    return select.watch().map((rows) {
      return rows
          .map<domain.Contact>(
            (row) => domain.Contact(id: row.id, name: row.name),
          )
          .toList();
    });
  }

  // Add a new contact
  Future<void> addContact(String name) async {
    try {
      final companion = ContactsCompanion.insert(name: name);
      await _db.into(_db.contacts).insert(companion);
    } on SqliteException catch (e) {
      // Handle unique constraint violation
      if (e.message.contains('UNIQUE constraint failed')) {
        throw ContactAlreadyExistsException();
      }
      rethrow;
    }
  }

  // Update a contact's name
  Future<void> updateContact(int id, String newName) async {
    final companion = ContactsCompanion(name: Value(newName));
    await (_db.update(
      _db.contacts,
    )..where((t) => t.id.equals(id))).write(companion);
  }

  // Efficient: Calculates balance inside the database
  Future<void> deleteContact(int id) async {
    // 1. Calculate the balance for this contact using a single aggregate query
    final amount = _db.transactions.amount;
    final direction = _db.transactions.direction;

    // Use a CASE WHEN expression to make 'received' amounts negative
    final signedAmount = CaseWhenExpression<double>(
      cases: [
        CaseWhen<bool, double>(
          direction.equals(TransactionDirection.lent.index),
          then: amount,
        ),
      ],
      orElse: -amount,
    );

    final balanceQuery = _db.selectOnly(_db.transactions)
      ..addColumns([signedAmount.sum()]) // Calculate SUM() in the DB
      ..where(_db.transactions.contactId.equals(id));

    // .readSingle() returns the single row with the single calculated value
    final balance =
        await balanceQuery
            .map((row) => row.read(signedAmount.sum()))
            .getSingleOrNull() ??
        0.0;

    // 2. Check if balance is zero
    if (balance.abs() > 0.001) {
      // Use a small tolerance for double comparison
      throw ContactHasBalanceException();
    }

    // 3. If balance is zero, delete the associated transactions (Good Practice)
    await (_db.delete(
      _db.transactions,
    )..where((t) => t.contactId.equals(id))).go();

    // 4. Then delete the contact itself
    await (_db.delete(_db.contacts)..where((c) => c.id.equals(id))).go();
  }
}

@Riverpod(keepAlive: true)
ContactsRepository contactsRepository(Ref ref) {
  // It depends on the appDatabaseProvider
  return ContactsRepository(ref.watch(appDatabaseProvider));
}

@riverpod
Stream<List<domain.Contact>> contactsStream(Ref ref, String query) {
  final contactsRepository = ref.watch(contactsRepositoryProvider);
  return contactsRepository.watchContacts(query: query);
}
