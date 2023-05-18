import 'package:equatable/equatable.dart';

abstract class AchievementEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AchievementsLoaded extends AchievementEvent {
  final int page;
  AchievementsLoaded({required this.page});
  @override
  List<Object> get props => [page];

  @override
  String toString() => 'AchievementsLoaded { page: $page }';
}
