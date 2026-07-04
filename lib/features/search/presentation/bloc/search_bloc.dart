import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../ads/domain/entities/ad_entity.dart';
import '../../domain/repositories/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;
  DocumentSnapshot? _lastDoc;
  String _currentQuery = '';
  Map<String, dynamic> _currentFilters = {};
  Timer? _debounce;

  SearchBloc({required SearchRepository searchRepository})
      : _searchRepository = searchRepository,
        super(const SearchInitial()) {
    on<Search>(_onSearch);
    on<UpdateFilters>(_onUpdateFilters);
    on<LoadMoreResults>(_onLoadMoreResults);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearch(
      Search event, Emitter<SearchState> emit) async {
    _currentQuery = event.query;
    _lastDoc = null;

    if (event.query.trim().isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());
    try {
      final results = await _searchRepository.searchAds(
        event.query,
      );
      if (results.isEmpty) {
        emit(const SearchEmpty());
      } else {
        emit(SearchLoaded(
            results: results, hasMore: results.length >= 20));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onUpdateFilters(
      UpdateFilters event, Emitter<SearchState> emit) async {
    _currentFilters = event.filters;
    _lastDoc = null;

    emit(const SearchLoading());
    try {
      final results = await _searchRepository.searchAdsByFilters(
        categoryId: event.filters['categoryId'] as String?,
        governorate: event.filters['governorate'] as String?,
        city: event.filters['city'] as String?,
        minPrice: event.filters['minPrice'] as double?,
        maxPrice: event.filters['maxPrice'] as double?,
        condition: event.filters['condition'] as String?,
      );
      if (results.isEmpty) {
        emit(const SearchEmpty());
      } else {
        emit(SearchLoaded(
            results: results, hasMore: results.length >= 20));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onLoadMoreResults(
      LoadMoreResults event, Emitter<SearchState> emit) async {
    if (state is! SearchLoaded) return;
    final currentState = state as SearchLoaded;
    if (!currentState.hasMore) return;

    try {
      List<AdEntity> moreResults;
      if (_currentFilters.isNotEmpty) {
        moreResults = await _searchRepository.searchAdsByFilters(
          categoryId: _currentFilters['categoryId'] as String?,
          governorate: _currentFilters['governorate'] as String?,
          city: _currentFilters['city'] as String?,
          minPrice: _currentFilters['minPrice'] as double?,
          maxPrice: _currentFilters['maxPrice'] as double?,
          condition: _currentFilters['condition'] as String?,
          lastDoc: _lastDoc,
        );
      } else {
        moreResults = await _searchRepository.searchAds(
          _currentQuery,
          lastDoc: _lastDoc,
        );
      }

      final allResults = [...currentState.results, ...moreResults];
      emit(SearchLoaded(
          results: allResults, hasMore: moreResults.length >= 20));
    } catch (_) {}
  }

  void _onClearSearch(
      ClearSearch event, Emitter<SearchState> emit) {
    _currentQuery = '';
    _currentFilters = {};
    _lastDoc = null;
    _debounce?.cancel();
    emit(const SearchInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
