// A generic exception for contact-related operations
sealed class ContactException implements Exception {
  ContactException(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => message;
}

// Thrown when trying to add a contact with a name that already exists
class ContactAlreadyExistsException extends ContactException {
  ContactAlreadyExistsException()
    : super(
        'name-already-exists',
        'The name is already present in the database',
      );
}

// Thrown when trying to delete a contact that has a non-zero balance
class ContactHasBalanceException extends ContactException {
  ContactHasBalanceException()
    : super(
        'non-zero-balance',
        'Contact has non-zero balance and can\'t be deleted',
      );
}
