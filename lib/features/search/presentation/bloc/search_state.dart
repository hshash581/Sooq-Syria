import 'package:equatable/equatable.dart';

import '../../../ads/domain/entities/ad_entity.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<AdEntity> results;
  final bool hasMore;

  const SearchLoaded({required this.results, this.hasMore = false});

  @override
  List<Object?> get props => [results, hasMore];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchEmpty extends SearchState {
  const SearchEmpty();
}
