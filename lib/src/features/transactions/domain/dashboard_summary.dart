import 'package:lend_borrow_tracker/src/features/contacts/domain/contact.dart';

// A model to hold a contact and their calculated balance.
class FriendBalance {
  FriendBalance({required this.contact, required this.balance});
  final Contact contact;
  final double balance;
}

// The main model for all data needed by the dashboard.
class DashboardSummary {
  DashboardSummary({
    required this.totalOwedToYou,
    required this.totalOwedByYou,
    required this.netBalance,
    required this.friendBalances,
  });

  final double totalOwedToYou; // Sum of all positive balances
  final double
  totalOwedByYou; // Sum of all negative balances (as a positive number)
  final double netBalance;
  final List<FriendBalance> friendBalances;
}
