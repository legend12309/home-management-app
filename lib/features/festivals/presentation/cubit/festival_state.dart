import 'package:equatable/equatable.dart';
import '../../../core/models/festival_model.dart';

abstract class FestivalState extends Equatable {
  const FestivalState();

  @override
  List<Object?> get props => [];
}

class FestivalInitial extends FestivalState {}

class FestivalLoading extends FestivalState {}

class FestivalLoaded extends FestivalState {
  final List<Festival> upcomingFestivals;
  final List<Festival> familyFestivals;

  const FestivalLoaded({
    required this.upcomingFestivals,
    required this.familyFestivals,
  });

  @override
  List<Object?> get props => [upcomingFestivals, familyFestivals];
}

class FestivalError extends FestivalState {
  final String message;

  const FestivalError(this.message);

  @override
  List<Object?> get props => [message];
}

