// Mocks generated by Mockito 5.2.0 from annotations
// in campus_app/test/pages/rubnews/rubnews_repository_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:campus_app/pages/rubnews/news_entity.dart' as _i7;
import 'package:campus_app/pages/rubnews/rubnews_datasource.dart' as _i5;
import 'package:dio/dio.dart' as _i2;
import 'package:hive/hive.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:xml/xml.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeDio_0 extends _i1.Fake implements _i2.Dio {}

class _FakeBox_1<E> extends _i1.Fake implements _i3.Box<E> {}

class _FakeXmlDocument_2 extends _i1.Fake implements _i4.XmlDocument {}

/// A class which mocks [RubnewsDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockRubnewsDatasource extends _i1.Mock implements _i5.RubnewsDatasource {
  MockRubnewsDatasource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Dio get client =>
      (super.noSuchMethod(Invocation.getter(#client), returnValue: _FakeDio_0())
          as _i2.Dio);
  @override
  _i3.Box<dynamic> get rubnewsCach =>
      (super.noSuchMethod(Invocation.getter(#rubnewsCach),
          returnValue: _FakeBox_1<dynamic>()) as _i3.Box<dynamic>);
  @override
  _i6.Future<_i4.XmlDocument> getNewsfeedAsXml() =>
      (super.noSuchMethod(Invocation.method(#getNewsfeedAsXml, []),
              returnValue: Future<_i4.XmlDocument>.value(_FakeXmlDocument_2()))
          as _i6.Future<_i4.XmlDocument>);
  @override
  _i6.Future<List<String>> getImageUrlsFromNewsUrl(String? url) =>
      (super.noSuchMethod(Invocation.method(#getImageUrlsFromNewsUrl, [url]),
              returnValue: Future<List<String>>.value(<String>[]))
          as _i6.Future<List<String>>);
  @override
  _i6.Future<void> writeNewsEntitiesToCach(List<_i7.NewsEntity>? entities) =>
      (super.noSuchMethod(
          Invocation.method(#writeNewsEntitiesToCach, [entities]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  List<_i7.NewsEntity> readNewsEntitiesFromCach() =>
      (super.noSuchMethod(Invocation.method(#readNewsEntitiesFromCach, []),
          returnValue: <_i7.NewsEntity>[]) as List<_i7.NewsEntity>);
}