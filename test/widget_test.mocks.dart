// Mocks generated by Mockito 5.0.17 from annotations
// in rafael_jobsity_challenge/test/widget_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;

import 'widget_test.dart' as _i2;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [SeriesRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSeriesRepository extends _i1.Mock implements _i2.SeriesRepository {
  MockSeriesRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<List<_i2.ASeries>> get seriesPagination => (super.noSuchMethod(
      Invocation.getter(#seriesPagination),
      returnValue: <List<_i2.ASeries>>[]) as List<List<_i2.ASeries>>);
  @override
  List<List<_i2.ASeries>> get searchPagination => (super.noSuchMethod(
      Invocation.getter(#searchPagination),
      returnValue: <List<_i2.ASeries>>[]) as List<List<_i2.ASeries>>);
  @override
  String get searchInput =>
      (super.noSuchMethod(Invocation.getter(#searchInput), returnValue: '')
          as String);
  @override
  set searchInput(String? _searchInput) =>
      super.noSuchMethod(Invocation.setter(#searchInput, _searchInput),
          returnValueForMissingStub: null);
  @override
  _i3.Future<List<_i2.ASeries>> getSeries() => (super.noSuchMethod(
          Invocation.method(#getSeries, []),
          returnValue: Future<List<_i2.ASeries>>.value(<_i2.ASeries>[]))
      as _i3.Future<List<_i2.ASeries>>);
  @override
  _i3.Future<List<_i2.ASeries>> getMoreSeries() => (super.noSuchMethod(
          Invocation.method(#getMoreSeries, []),
          returnValue: Future<List<_i2.ASeries>>.value(<_i2.ASeries>[]))
      as _i3.Future<List<_i2.ASeries>>);
  @override
  _i3.Future<List<_i2.ASeries>> searchSeries(String? name) =>
      (super.noSuchMethod(Invocation.method(#searchSeries, [name]),
              returnValue:
                  Future<List<_i2.ASeries>>.value(<_i2.ASeries>[]))
          as _i3.Future<List<_i2.ASeries>>);
  @override
  _i3.Future<List<_i2.ASeries>> searchMoreSeries() => (super.noSuchMethod(
          Invocation.method(#searchMoreSeries, []),
          returnValue: Future<List<_i2.ASeries>>.value(<_i2.ASeries>[]))
      as _i3.Future<List<_i2.ASeries>>);
}

/// A class which mocks [SeriesRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockSeriesRemoteDataSource extends _i1.Mock
    implements _i2.SeriesRemoteDataSource {
  MockSeriesRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i2.ASeries>> getSeries([int? page = 0]) =>
      (super.noSuchMethod(Invocation.method(#getSeries, [page]),
              returnValue:
                  Future<List<_i2.ASeries>>.value(<_i2.ASeries>[]))
          as _i3.Future<List<_i2.ASeries>>);
  @override
  _i3.Future<List<_i2.ASeries>> searchSeries(
          {String? name, int? page = 0}) =>
      (super.noSuchMethod(
              Invocation.method(#searchSeries, [], {#name: name, #page: page}),
              returnValue:
                  Future<List<_i2.ASeries>>.value(<_i2.ASeries>[]))
          as _i3.Future<List<_i2.ASeries>>);
}
