import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lend_borrow_tracker/src/features/transactions/data/transactions_repository.dart';
import 'package:lend_borrow_tracker/src/features/transactions/domain/transaction.dart'
    as domain;
import 'package:lend_borrow_tracker/src/features/transactions/domain/transaction_direction.dart';

class AddEditTransactionDialog extends ConsumerStatefulWidget {
  final int contactId;
  final domain.Transaction?
  transaction; // Null when adding, non-null when editing

  const AddEditTransactionDialog({
    super.key,
    required this.contactId,
    this.transaction,
  });

  @override
  ConsumerState<AddEditTransactionDialog> createState() =>
      _AddEditTransactionDialogState();
}

class _AddEditTransactionDialogState
    extends ConsumerState<AddEditTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late Set<TransactionDirection> _direction;
  late DateTime _date;
  bool _isLoading = false;

  bool get _isEditMode => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    _amountController = TextEditingController(text: t?.amount.toString() ?? '');
    _descriptionController = TextEditingController(text: t?.description ?? '');
    _direction = {t?.direction ?? TransactionDirection.lent};
    _date = t?.date ?? DateTime.now();
  }

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
        if (_isEditMode) {
          await repo.updateTransaction(
            transactionId: widget.transaction!.id,
            amount: double.parse(_amountController.text),
            direction: _direction.first,
            description: _descriptionController.text,
            date: _date,
          );
        } else {
          await repo.addTransaction(
            contactId: widget.contactId,
            amount: double.parse(_amountController.text),
            direction: _direction.first,
            description: _descriptionController.text,
            date: _date,
          );
        }
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
    return AlertDialog(
      title: Text(_isEditMode ? 'Edit Transaction' : 'Add Transaction'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                    if (pickedDate != null) {
                      setState(() => _date = pickedDate);
                    }
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
              : Text(_isEditMode ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
