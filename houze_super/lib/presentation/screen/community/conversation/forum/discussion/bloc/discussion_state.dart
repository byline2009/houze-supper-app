part of 'discussion_bloc.dart';

abstract class DiscussionState extends Equatable {
  const DiscussionState();

  @override
  List<Object> get props => [];
}

class DiscussionInitial extends DiscussionState {}

class DiscussionLoading extends DiscussionState {}

class DiscussionListSuccess extends DiscussionState {
  final List<DiscussionModel> discussionList;
  const DiscussionListSuccess(this.discussionList);

  @override
  List<Object> get props => [discussionList];
}
