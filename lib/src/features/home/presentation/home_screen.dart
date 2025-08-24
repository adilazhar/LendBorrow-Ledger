import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lend_borrow_tracker/src/features/home/presentation/sort_options.dart';
import 'package:lend_borrow_tracker/src/features/transactions/data/transactions_repository.dart';
import 'package:lend_borrow_tracker/src/features/transactions/domain/dashboard_summary.dart';
import 'package:lend_borrow_tracker/src/features/transactions/presentation/add_transaction_from_home_dialog.dart';
import 'package:lend_borrow_tracker/src/features/transactions/presentation/transaction_history_screen.dart';

// A local provider to hold the current sort option for the UI
final sortOptionProvider = StateProvider<SortOption>(
  (ref) => SortOption.byAmount,
);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Color _getAmountColor(double amount, BuildContext context) {
    if (amount > 0.01) return Colors.green;
    if (amount < -0.01) return Colors.red;
    return Theme.of(context).colorScheme.onSurface;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final sortOption = ref.watch(sortOptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (value) =>
                ref.read(sortOptionProvider.notifier).state = value,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortOption.byAmount,
                child: Text('Sort by Amount'),
              ),
              const PopupMenuItem(
                value: SortOption.byName,
                child: Text('Sort by Name'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddTransactionFromHomeDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: summaryAsync.when(
        data: (summary) {
          // Apply sorting
          final sortedBalances = List<FriendBalance>.from(
            summary.friendBalances,
          );
          if (sortOption == SortOption.byAmount) {
            sortedBalances.sort((a, b) {
              final compare = b.balance.compareTo(a.balance);
              if (compare != 0) return compare;
              return a.contact.name.compareTo(b.contact.name);
            });
          } else {
            sortedBalances.sort(
              (a, b) => a.contact.name.compareTo(b.contact.name),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(dashboardSummaryProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Net Balance Display
                _NetBalanceCard(netBalance: summary.netBalance),
                const SizedBox(height: 16),
                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'You Are Owed',
                        amount: summary.totalOwedToYou,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SummaryCard(
                        title: 'You Owe',
                        amount: summary.totalOwedByYou,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Breakdown',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(),
                if (sortedBalances.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text('Everything is settled up. Great job!'),
                    ),
                  )
                else
                  ...sortedBalances.map((fb) {
                    final color = _getAmountColor(fb.balance, context);
                    final balanceText = fb.balance > 0
                        ? '+PKR ${fb.balance.toStringAsFixed(2)}'
                        : 'PKR ${fb.balance.toStringAsFixed(2)}';
                    return Card(
                      child: ListTile(
                        title: Text(fb.contact.name),
                        trailing: Text(
                          balanceText,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TransactionHistoryScreen(
                              contact: fb.contact,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

// Helper Widgets for cleaner build method

class _NetBalanceCard extends StatelessWidget {
  final double netBalance;
  const _NetBalanceCard({required this.netBalance});

  @override
  Widget build(BuildContext context) {
    final color = netBalance > 0.01
        ? Colors.green
        : (netBalance < -0.01
              ? Colors.red
              : Theme.of(context).colorScheme.onSurface);
    final text = netBalance.abs().toStringAsFixed(2);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Net Balance', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'PKR $text',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(
              'PKR ${amount.toStringAsFixed(2)}',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
