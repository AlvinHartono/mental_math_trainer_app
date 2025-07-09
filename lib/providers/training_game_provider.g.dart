// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trainingGameProviderHash() =>
    r'56f3b585dac8f24e8f3b73d0592b7cf8cd4b52ac';

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

abstract class _$TrainingGameProvider
    extends BuildlessAutoDisposeNotifier<TrainingGameState> {
  late final int difficulty;
  late final String operator;

  TrainingGameState build({
    required int difficulty,
    required String operator,
  });
}

/// See also [TrainingGameProvider].
@ProviderFor(TrainingGameProvider)
const trainingGameProviderProvider = TrainingGameProviderFamily();

/// See also [TrainingGameProvider].
class TrainingGameProviderFamily extends Family<TrainingGameState> {
  /// See also [TrainingGameProvider].
  const TrainingGameProviderFamily();

  /// See also [TrainingGameProvider].
  TrainingGameProviderProvider call({
    required int difficulty,
    required String operator,
  }) {
    return TrainingGameProviderProvider(
      difficulty: difficulty,
      operator: operator,
    );
  }

  @override
  TrainingGameProviderProvider getProviderOverride(
    covariant TrainingGameProviderProvider provider,
  ) {
    return call(
      difficulty: provider.difficulty,
      operator: provider.operator,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'trainingGameProviderProvider';
}

/// See also [TrainingGameProvider].
class TrainingGameProviderProvider extends AutoDisposeNotifierProviderImpl<
    TrainingGameProvider, TrainingGameState> {
  /// See also [TrainingGameProvider].
  TrainingGameProviderProvider({
    required int difficulty,
    required String operator,
  }) : this._internal(
          () => TrainingGameProvider()
            ..difficulty = difficulty
            ..operator = operator,
          from: trainingGameProviderProvider,
          name: r'trainingGameProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trainingGameProviderHash,
          dependencies: TrainingGameProviderFamily._dependencies,
          allTransitiveDependencies:
              TrainingGameProviderFamily._allTransitiveDependencies,
          difficulty: difficulty,
          operator: operator,
        );

  TrainingGameProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.difficulty,
    required this.operator,
  }) : super.internal();

  final int difficulty;
  final String operator;

  @override
  TrainingGameState runNotifierBuild(
    covariant TrainingGameProvider notifier,
  ) {
    return notifier.build(
      difficulty: difficulty,
      operator: operator,
    );
  }

  @override
  Override overrideWith(TrainingGameProvider Function() create) {
    return ProviderOverride(
      origin: this,
      override: TrainingGameProviderProvider._internal(
        () => create()
          ..difficulty = difficulty
          ..operator = operator,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        difficulty: difficulty,
        operator: operator,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TrainingGameProvider, TrainingGameState>
      createElement() {
    return _TrainingGameProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrainingGameProviderProvider &&
        other.difficulty == difficulty &&
        other.operator == operator;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, difficulty.hashCode);
    hash = _SystemHash.combine(hash, operator.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TrainingGameProviderRef
    on AutoDisposeNotifierProviderRef<TrainingGameState> {
  /// The parameter `difficulty` of this provider.
  int get difficulty;

  /// The parameter `operator` of this provider.
  String get operator;
}

class _TrainingGameProviderProviderElement
    extends AutoDisposeNotifierProviderElement<TrainingGameProvider,
        TrainingGameState> with TrainingGameProviderRef {
  _TrainingGameProviderProviderElement(super.provider);

  @override
  int get difficulty => (origin as TrainingGameProviderProvider).difficulty;
  @override
  String get operator => (origin as TrainingGameProviderProvider).operator;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
