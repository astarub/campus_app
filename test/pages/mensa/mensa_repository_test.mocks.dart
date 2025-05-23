// Mocks generated by Mockito 5.4.5 from annotations
// in campus_app/test/pages/mensa/mensa_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:campus_app/pages/mensa/dish_entity.dart' as _i6;
import 'package:campus_app/pages/mensa/mensa_datasource.dart' as _i4;
import 'package:dio/dio.dart' as _i2;
import 'package:hive/hive.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDio_0 extends _i1.SmartFake implements _i2.Dio {
  _FakeDio_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBox_1<E> extends _i1.SmartFake implements _i3.Box<E> {
  _FakeBox_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MensaDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockMensaDataSource extends _i1.Mock implements _i4.MensaDataSource {
  MockMensaDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Dio get client => (super.noSuchMethod(
        Invocation.getter(#client),
        returnValue: _FakeDio_0(
          this,
          Invocation.getter(#client),
        ),
      ) as _i2.Dio);

  @override
  _i3.Box<dynamic> get mensaCache => (super.noSuchMethod(
        Invocation.getter(#mensaCache),
        returnValue: _FakeBox_1<dynamic>(
          this,
          Invocation.getter(#mensaCache),
        ),
      ) as _i3.Box<dynamic>);

  @override
  _i5.Future<Map<String, dynamic>> getRemoteData(int? restaurant) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRemoteData,
          [restaurant],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<void> writeDishEntitiesToCache(
    List<_i6.DishEntity>? entities,
    int? restaurant,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #writeDishEntitiesToCache,
          [
            entities,
            restaurant,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  List<_i6.DishEntity> readDishEntitiesFromCache(int? restaurant) =>
      (super.noSuchMethod(
        Invocation.method(
          #readDishEntitiesFromCache,
          [restaurant],
        ),
        returnValue: <_i6.DishEntity>[],
      ) as List<_i6.DishEntity>);
}
