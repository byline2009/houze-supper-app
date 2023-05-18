import 'package:equatable/equatable.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/index.dart';

abstract class PollState extends Equatable {
  const PollState();

  @override
  List<Object> get props => [];
}

class PollInitial extends PollState {}

class PollLoading extends PollState {}

class PollListSuccess extends PollState {
  final List<PollModel> pollList;
  const PollListSuccess(this.pollList);

  @override
  List<Object> get props => [pollList];
}
