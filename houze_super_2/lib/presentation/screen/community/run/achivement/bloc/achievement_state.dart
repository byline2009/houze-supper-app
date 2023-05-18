import 'package:equatable/equatable.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/model/achievement_user_model.dart';

abstract class AchievementState extends Equatable {
  @override
  List<Object> get props => [];
}

class AchievementInitial extends AchievementState {}

class AchievementLoadInProgress extends AchievementState {}

class AchievementsLoadSuccess extends AchievementState {
  final List<AchievementUserModel> achivements;

  AchievementsLoadSuccess([this.achivements = const []]);

  @override
  List<Object> get props => [achivements];

  @override
  String toString() =>
      'AchievementLoadSuccess { Achievement: ${achivements.map((e) => print(e.toJson()))}} }';
}

class AchievementLoadFailure extends AchievementState {}
