import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lend_borrow_tracker/src/features/contacts/data/contact_repository.dart';
import 'package:lend_borrow_tracker/src/features/contacts/domain/contact.dart'
    as domain;
import 'package:lend_borrow_tracker/src/features/contacts/presentation/add_contact_dialog.dart';
import 'package:lend_borrow_tracker/src/features/transactions/data/transactions_repository.dart';
import 'package:lend_borrow_tracker/src/features/transactions/domain/transaction_direction.dart';

class AddTransactionFromHomeDialog extends ConsumerStatefulWidget {
  const AddTransactionFromHomeDialog({super.key});

  @override
  ConsumerState<AddTransactionFromHomeDialog> createState() =>
      _AddTransactionDialogState();
}

class _AddTransactionDialogState
    extends ConsumerState<AddTransactionFromHomeDialog> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedContactId;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  Set<TransactionDirection> _direction = {TransactionDirection.lent};
  DateTime _date = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final repo = ref.read(transactionsRepositoryProvider);
      try {
        await repo.addTransaction(
          contactId: _selectedContactId!,
          amount: double.parse(_amountController.text),
          direction: _direction.first,
          description: _descriptionController.text,
          date: _date,
        );
        if (mounted) Navigator.of(context).pop();
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(contactsStreamProvider(''));
    return AlertDialog(
      title: const Text('Add Transaction'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Contact Dropdown
                Row(
                  children: [
                    Expanded(
                      child: contactsAsync.when(
                        data: (contacts) {
                          if (contacts.isEmpty) {
                            return const Text('Add a contact first');
                          }
                          return DropdownButtonFormField<int>(
                            value: _selectedContactId,
                            hint: const Text('Select a friend'),
                            items: contacts.map((domain.Contact contact) {
                              return DropdownMenuItem<int>(
                                value: contact.id,
                                child: Text(contact.name),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _selectedContactId = value),
                            validator: (value) => value == null
                                ? 'Please select a friend.'
                                : null,
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, s) => const Text('Could not load contacts.'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        // Show the add contact dialog
                        await showDialog(
                          context: context,
                          builder: (_) => const AddContactDialog(),
                        );
                        // Refresh the contacts stream to get the new contact
                        ref.invalidate(contactsStreamProvider);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Other fields from the previous dialog
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Amount (PKR)',
                    prefixText: 'PKR ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Amount must be greater than zero.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SegmentedButton<TransactionDirection>(
                  segments: const [
                    ButtonSegment(
                      value: TransactionDirection.lent,
                      label: Text('You Lent'),
                    ),
                    ButtonSegment(
                      value: TransactionDirection.received,
                      label: Text('You Received'),
                    ),
                  ],
                  selected: _direction,
                  onSelectionChanged: (newSelection) =>
                      setState(() => _direction = newSelection),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                  ),
                  maxLength: 300,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Date'),
                  subtitle: Text(DateFormat.yMMMd().format(_date)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) setState(() => _date = pickedDate);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(),
                )
              : const Text('Add'),
        ),
      ],
    );
  }
}
