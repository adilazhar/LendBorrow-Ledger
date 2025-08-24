import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lend_borrow_tracker/src/features/contacts/data/contact_errors.dart';
import 'package:lend_borrow_tracker/src/features/contacts/data/contact_repository.dart';
import 'package:lend_borrow_tracker/src/features/contacts/domain/contact.dart'
    as domain;

class AddContactDialog extends ConsumerStatefulWidget {
  // If a contact is passed, we are in "edit" mode
  final domain.Contact? contact;

  const AddContactDialog({super.key, this.contact});

  @override
  ConsumerState<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends ConsumerState<AddContactDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String? _errorText;
  bool _isLoading = false;

  bool get _isEditMode => widget.contact != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorText = null;
        _isLoading = true;
      }); // Clear previous errors
      final repository = ref.read(contactsRepositoryProvider);
      try {
        if (_isEditMode) {
          await repository.updateContact(
            widget.contact!.id,
            _nameController.text,
          );
        } else {
          await repository.addContact(_nameController.text);
        }
        // If successful, close the dialog
        if (mounted) Navigator.of(context).pop();
      } on ContactAlreadyExistsException catch (e) {
        setState(() => _errorText = e.message);
      } catch (e) {
        // Handle other potential errors, maybe show a SnackBar
        setState(() => _errorText = 'An unexpected error occurred.');
      } finally {
        _isLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditMode ? 'Edit Contact' : 'Add New Contact'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          enabled: !_isLoading,
          autofocus: true,
          maxLength: 50,
          decoration: InputDecoration(
            labelText: 'Name',
            errorText: _errorText,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Name cannot be empty.';
            }
            return null;
          },
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
              ? CircularProgressIndicator()
              : Text(_isEditMode ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
