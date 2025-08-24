// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contactsRepositoryHash() =>
    r'e5626af1e50f7b42bb0ca12711968018db7edbdb';

/// See also [contactsRepository].
@ProviderFor(contactsRepository)
final contactsRepositoryProvider = Provider<ContactsRepository>.internal(
  contactsRepository,
  name: r'contactsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contactsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ContactsRepositoryRef = ProviderRef<ContactsRepository>;
String _$contactsStreamHash() => r'811b71d3b4959179ef5cee265d668edee07e0861';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [contactsStream].
@ProviderFor(contactsStream)
const contactsStreamProvider = ContactsStreamFamily();

/// See also [contactsStream].
class ContactsStreamFamily extends Family<AsyncValue<List<domain.Contact>>> {
  /// See also [contactsStream].
  const ContactsStreamFamily();

  /// See also [contactsStream].
  ContactsStreamProvider call(String query) {
    return ContactsStreamProvider(query);
  }

  @override
  ContactsStreamProvider getProviderOverride(
    covariant ContactsStreamProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'contactsStreamProvider';
}

/// See also [contactsStream].
class ContactsStreamProvider
    extends AutoDisposeStreamProvider<List<domain.Contact>> {
  /// See also [contactsStream].
  ContactsStreamProvider(String query)
    : this._internal(
        (ref) => contactsStream(ref as ContactsStreamRef, query),
        from: contactsStreamProvider,
        name: r'contactsStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$contactsStreamHash,
        dependencies: ContactsStreamFamily._dependencies,
        allTransitiveDependencies:
            ContactsStreamFamily._allTransitiveDependencies,
        query: query,
      );

  ContactsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    Stream<List<domain.Contact>> Function(ContactsStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ContactsStreamProvider._internal(
        (ref) => create(ref as ContactsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<domain.Contact>> createElement() {
    return _ContactsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ContactsStreamProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ContactsStreamRef on AutoDisposeStreamProviderRef<List<domain.Contact>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _ContactsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<domain.Contact>>
    with ContactsStreamRef {
  _ContactsStreamProviderElement(super.provider);

  @override
  String get query => (origin as ContactsStreamProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
