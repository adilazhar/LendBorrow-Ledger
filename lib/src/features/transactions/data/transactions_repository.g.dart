// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsRepositoryHash() =>
    r'd243ac803799da7d777f6ae89d7d6af9999c579e';

/// See also [transactionsRepository].
@ProviderFor(transactionsRepository)
final transactionsRepositoryProvider =
    Provider<TransactionsRepository>.internal(
      transactionsRepository,
      name: r'transactionsRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsRepositoryRef = ProviderRef<TransactionsRepository>;
String _$transactionsStreamHash() =>
    r'98ac791ede1c23744948abdff689acf7e4f9e6d1';

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

/// See also [transactionsStream].
@ProviderFor(transactionsStream)
const transactionsStreamProvider = TransactionsStreamFamily();

/// See also [transactionsStream].
class TransactionsStreamFamily
    extends Family<AsyncValue<List<domain.Transaction>>> {
  /// See also [transactionsStream].
  const TransactionsStreamFamily();

  /// See also [transactionsStream].
  TransactionsStreamProvider call(int contactId) {
    return TransactionsStreamProvider(contactId);
  }

  @override
  TransactionsStreamProvider getProviderOverride(
    covariant TransactionsStreamProvider provider,
  ) {
    return call(provider.contactId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'transactionsStreamProvider';
}

/// See also [transactionsStream].
class TransactionsStreamProvider
    extends AutoDisposeStreamProvider<List<domain.Transaction>> {
  /// See also [transactionsStream].
  TransactionsStreamProvider(int contactId)
    : this._internal(
        (ref) => transactionsStream(ref as TransactionsStreamRef, contactId),
        from: transactionsStreamProvider,
        name: r'transactionsStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$transactionsStreamHash,
        dependencies: TransactionsStreamFamily._dependencies,
        allTransitiveDependencies:
            TransactionsStreamFamily._allTransitiveDependencies,
        contactId: contactId,
      );

  TransactionsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contactId,
  }) : super.internal();

  final int contactId;

  @override
  Override overrideWith(
    Stream<List<domain.Transaction>> Function(TransactionsStreamRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransactionsStreamProvider._internal(
        (ref) => create(ref as TransactionsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contactId: contactId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<domain.Transaction>> createElement() {
    return _TransactionsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionsStreamProvider && other.contactId == contactId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contactId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionsStreamRef
    on AutoDisposeStreamProviderRef<List<domain.Transaction>> {
  /// The parameter `contactId` of this provider.
  int get contactId;
}

class _TransactionsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<domain.Transaction>>
    with TransactionsStreamRef {
  _TransactionsStreamProviderElement(super.provider);

  @override
  int get contactId => (origin as TransactionsStreamProvider).contactId;
}

String _$fetchTransactionsForContactHash() =>
    r'e0775bee1d6e6448f501b69d905b3c1db196e02d';

/// See also [fetchTransactionsForContact].
@ProviderFor(fetchTransactionsForContact)
const fetchTransactionsForContactProvider = FetchTransactionsForContactFamily();

/// See also [fetchTransactionsForContact].
class FetchTransactionsForContactFamily
    extends Family<AsyncValue<List<domain.Transaction>>> {
  /// See also [fetchTransactionsForContact].
  const FetchTransactionsForContactFamily();

  /// See also [fetchTransactionsForContact].
  FetchTransactionsForContactProvider call(int contactId) {
    return FetchTransactionsForContactProvider(contactId);
  }

  @override
  FetchTransactionsForContactProvider getProviderOverride(
    covariant FetchTransactionsForContactProvider provider,
  ) {
    return call(provider.contactId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchTransactionsForContactProvider';
}

/// See also [fetchTransactionsForContact].
class FetchTransactionsForContactProvider
    extends AutoDisposeFutureProvider<List<domain.Transaction>> {
  /// See also [fetchTransactionsForContact].
  FetchTransactionsForContactProvider(int contactId)
    : this._internal(
        (ref) => fetchTransactionsForContact(
          ref as FetchTransactionsForContactRef,
          contactId,
        ),
        from: fetchTransactionsForContactProvider,
        name: r'fetchTransactionsForContactProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$fetchTransactionsForContactHash,
        dependencies: FetchTransactionsForContactFamily._dependencies,
        allTransitiveDependencies:
            FetchTransactionsForContactFamily._allTransitiveDependencies,
        contactId: contactId,
      );

  FetchTransactionsForContactProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contactId,
  }) : super.internal();

  final int contactId;

  @override
  Override overrideWith(
    FutureOr<List<domain.Transaction>> Function(
      FetchTransactionsForContactRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchTransactionsForContactProvider._internal(
        (ref) => create(ref as FetchTransactionsForContactRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contactId: contactId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<domain.Transaction>> createElement() {
    return _FetchTransactionsForContactProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchTransactionsForContactProvider &&
        other.contactId == contactId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contactId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchTransactionsForContactRef
    on AutoDisposeFutureProviderRef<List<domain.Transaction>> {
  /// The parameter `contactId` of this provider.
  int get contactId;
}

class _FetchTransactionsForContactProviderElement
    extends AutoDisposeFutureProviderElement<List<domain.Transaction>>
    with FetchTransactionsForContactRef {
  _FetchTransactionsForContactProviderElement(super.provider);

  @override
  int get contactId =>
      (origin as FetchTransactionsForContactProvider).contactId;
}

String _$contactBalanceStreamHash() =>
    r'f9f326b5fbf8083924f594e6f2dd38a3dd9206ee';

/// See also [contactBalanceStream].
@ProviderFor(contactBalanceStream)
const contactBalanceStreamProvider = ContactBalanceStreamFamily();

/// See also [contactBalanceStream].
class ContactBalanceStreamFamily extends Family<AsyncValue<double>> {
  /// See also [contactBalanceStream].
  const ContactBalanceStreamFamily();

  /// See also [contactBalanceStream].
  ContactBalanceStreamProvider call(int contactId) {
    return ContactBalanceStreamProvider(contactId);
  }

  @override
  ContactBalanceStreamProvider getProviderOverride(
    covariant ContactBalanceStreamProvider provider,
  ) {
    return call(provider.contactId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'contactBalanceStreamProvider';
}

/// See also [contactBalanceStream].
class ContactBalanceStreamProvider extends AutoDisposeStreamProvider<double> {
  /// See also [contactBalanceStream].
  ContactBalanceStreamProvider(int contactId)
    : this._internal(
        (ref) =>
            contactBalanceStream(ref as ContactBalanceStreamRef, contactId),
        from: contactBalanceStreamProvider,
        name: r'contactBalanceStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$contactBalanceStreamHash,
        dependencies: ContactBalanceStreamFamily._dependencies,
        allTransitiveDependencies:
            ContactBalanceStreamFamily._allTransitiveDependencies,
        contactId: contactId,
      );

  ContactBalanceStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contactId,
  }) : super.internal();

  final int contactId;

  @override
  Override overrideWith(
    Stream<double> Function(ContactBalanceStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ContactBalanceStreamProvider._internal(
        (ref) => create(ref as ContactBalanceStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contactId: contactId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<double> createElement() {
    return _ContactBalanceStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ContactBalanceStreamProvider &&
        other.contactId == contactId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contactId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ContactBalanceStreamRef on AutoDisposeStreamProviderRef<double> {
  /// The parameter `contactId` of this provider.
  int get contactId;
}

class _ContactBalanceStreamProviderElement
    extends AutoDisposeStreamProviderElement<double>
    with ContactBalanceStreamRef {
  _ContactBalanceStreamProviderElement(super.provider);

  @override
  int get contactId => (origin as ContactBalanceStreamProvider).contactId;
}

String _$fetchContactBalanceHash() =>
    r'9197bc021e0bfb37b66ae3e77a71f059837dbbc5';

/// See also [fetchContactBalance].
@ProviderFor(fetchContactBalance)
const fetchContactBalanceProvider = FetchContactBalanceFamily();

/// See also [fetchContactBalance].
class FetchContactBalanceFamily extends Family<AsyncValue<double>> {
  /// See also [fetchContactBalance].
  const FetchContactBalanceFamily();

  /// See also [fetchContactBalance].
  FetchContactBalanceProvider call(int contactId) {
    return FetchContactBalanceProvider(contactId);
  }

  @override
  FetchContactBalanceProvider getProviderOverride(
    covariant FetchContactBalanceProvider provider,
  ) {
    return call(provider.contactId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchContactBalanceProvider';
}

/// See also [fetchContactBalance].
class FetchContactBalanceProvider extends AutoDisposeFutureProvider<double> {
  /// See also [fetchContactBalance].
  FetchContactBalanceProvider(int contactId)
    : this._internal(
        (ref) => fetchContactBalance(ref as FetchContactBalanceRef, contactId),
        from: fetchContactBalanceProvider,
        name: r'fetchContactBalanceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$fetchContactBalanceHash,
        dependencies: FetchContactBalanceFamily._dependencies,
        allTransitiveDependencies:
            FetchContactBalanceFamily._allTransitiveDependencies,
        contactId: contactId,
      );

  FetchContactBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contactId,
  }) : super.internal();

  final int contactId;

  @override
  Override overrideWith(
    FutureOr<double> Function(FetchContactBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchContactBalanceProvider._internal(
        (ref) => create(ref as FetchContactBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contactId: contactId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _FetchContactBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchContactBalanceProvider && other.contactId == contactId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contactId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchContactBalanceRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `contactId` of this provider.
  int get contactId;
}

class _FetchContactBalanceProviderElement
    extends AutoDisposeFutureProviderElement<double>
    with FetchContactBalanceRef {
  _FetchContactBalanceProviderElement(super.provider);

  @override
  int get contactId => (origin as FetchContactBalanceProvider).contactId;
}

String _$dashboardSummaryHash() => r'34573f78394c464f397302d416e5cef092211006';

/// See also [dashboardSummary].
@ProviderFor(dashboardSummary)
final dashboardSummaryProvider =
    AutoDisposeStreamProvider<DashboardSummary>.internal(
      dashboardSummary,
      name: r'dashboardSummaryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardSummaryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardSummaryRef = AutoDisposeStreamProviderRef<DashboardSummary>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
