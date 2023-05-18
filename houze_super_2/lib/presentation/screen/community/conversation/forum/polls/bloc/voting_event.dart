import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class VotingEvent extends Equatable {
  VotingEvent() : super();
}

class GetUserChoiceEvent extends VotingEvent {
  final int page;
  final String id;
  GetUserChoiceEvent({required this.page, required this.id});

  @override
  String toString() => 'VotingEvent: GetUserChoiceEvent';

  @override
  List<Object> get props => [this.page, this.id];
}
