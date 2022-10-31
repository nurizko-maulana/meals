part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoaded extends DetailState {
  final Meal detail;

  const DetailLoaded(this.detail);

  @override
  List<Object> get props => [detail];
}

class DetailLoadingFailed extends DetailState {
  final String message;

  const DetailLoadingFailed(this.message);

  @override
  List<Object> get props => [message];
}
