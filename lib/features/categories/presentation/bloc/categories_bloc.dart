import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../domain/repositories/categories_repository.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository _categoriesRepository;

  CategoriesBloc(
      {required CategoriesRepository categoriesRepository})
      : _categoriesRepository = categoriesRepository,
        super(const CategoriesInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoriesState> emit) async {
    emit(const CategoriesLoading());
    try {
      final categories = await _categoriesRepository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  void _onSelectCategory(
      SelectCategory event, Emitter<CategoriesState> emit) {
    if (state is CategoriesLoaded) {
      emit(state);
    }
  }
}
