import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class Search extends SearchEvent {
  final String query;

  const Search(this.query);

  @override
  List<Object?> get props => [query];
}

class UpdateFilters extends SearchEvent {
  final Map<String, dynamic> filters;

  const UpdateFilters(this.filters);

  @override
  List<Object?> get props => [filters];
}

class LoadMoreResults extends SearchEvent {
  const LoadMoreResults();
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}
