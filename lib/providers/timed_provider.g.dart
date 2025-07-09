// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timedProviderHash() => r'391d21b148fdcad7f0c0f716c074ed3f3e12baf9';

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

abstract class _$TimedProvider extends BuildlessAutoDisposeNotifier<TimedMode> {
  late final int initialDifficulty;
  late final String initialDurationName;
  late final String initialDifficultyName;

  TimedMode build({
    required int initialDifficulty,
    required String initialDurationName,
    required String initialDifficultyName,
  });
}

/// See also [TimedProvider].
@ProviderFor(TimedProvider)
const timedProviderProvider = TimedProviderFamily();

/// See also [TimedProvider].
class TimedProviderFamily extends Family<TimedMode> {
  /// See also [TimedProvider].
  const TimedProviderFamily();

  /// See also [TimedProvider].
  TimedProviderProvider call({
    required int initialDifficulty,
    required String initialDurationName,
    required String initialDifficultyName,
  }) {
    return TimedProviderProvider(
      initialDifficulty: initialDifficulty,
      initialDurationName: initialDurationName,
      initialDifficultyName: initialDifficultyName,
    );
  }

  @override
  TimedProviderProvider getProviderOverride(
    covariant TimedProviderProvider provider,
  ) {
    return call(
      initialDifficulty: provider.initialDifficulty,
      initialDurationName: provider.initialDurationName,
      initialDifficultyName: provider.initialDifficultyName,
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
  String? get name => r'timedProviderProvider';
}

/// See also [TimedProvider].
class TimedProviderProvider
    extends AutoDisposeNotifierProviderImpl<TimedProvider, TimedMode> {
  /// See also [TimedProvider].
  TimedProviderProvider({
    required int initialDifficulty,
    required String initialDurationName,
    required String initialDifficultyName,
  }) : this._internal(
          () => TimedProvider()
            ..initialDifficulty = initialDifficulty
            ..initialDurationName = initialDurationName
            ..initialDifficultyName = initialDifficultyName,
          from: timedProviderProvider,
          name: r'timedProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$timedProviderHash,
          dependencies: TimedProviderFamily._dependencies,
          allTransitiveDependencies:
              TimedProviderFamily._allTransitiveDependencies,
          initialDifficulty: initialDifficulty,
          initialDurationName: initialDurationName,
          initialDifficultyName: initialDifficultyName,
        );

  TimedProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initialDifficulty,
    required this.initialDurationName,
    required this.initialDifficultyName,
  }) : super.internal();

  final int initialDifficulty;
  final String initialDurationName;
  final String initialDifficultyName;

  @override
  TimedMode runNotifierBuild(
    covariant TimedProvider notifier,
  ) {
    return notifier.build(
      initialDifficulty: initialDifficulty,
      initialDurationName: initialDurationName,
      initialDifficultyName: initialDifficultyName,
    );
  }

  @override
  Override overrideWith(TimedProvider Function() create) {
    return ProviderOverride(
      origin: this,
      override: TimedProviderProvider._internal(
        () => create()
          ..initialDifficulty = initialDifficulty
          ..initialDurationName = initialDurationName
          ..initialDifficultyName = initialDifficultyName,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initialDifficulty: initialDifficulty,
        initialDurationName: initialDurationName,
        initialDifficultyName: initialDifficultyName,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TimedProvider, TimedMode> createElement() {
    return _TimedProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TimedProviderProvider &&
        other.initialDifficulty == initialDifficulty &&
        other.initialDurationName == initialDurationName &&
        other.initialDifficultyName == initialDifficultyName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialDifficulty.hashCode);
    hash = _SystemHash.combine(hash, initialDurationName.hashCode);
    hash = _SystemHash.combine(hash, initialDifficultyName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TimedProviderRef on AutoDisposeNotifierProviderRef<TimedMode> {
  /// The parameter `initialDifficulty` of this provider.
  int get initialDifficulty;

  /// The parameter `initialDurationName` of this provider.
  String get initialDurationName;

  /// The parameter `initialDifficultyName` of this provider.
  String get initialDifficultyName;
}

class _TimedProviderProviderElement
    extends AutoDisposeNotifierProviderElement<TimedProvider, TimedMode>
    with TimedProviderRef {
  _TimedProviderProviderElement(super.provider);

  @override
  int get initialDifficulty =>
      (origin as TimedProviderProvider).initialDifficulty;
  @override
  String get initialDurationName =>
      (origin as TimedProviderProvider).initialDurationName;
  @override
  String get initialDifficultyName =>
      (origin as TimedProviderProvider).initialDifficultyName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
