import 'package:equatable/equatable.dart';

class HeaderEvent extends Equatable {
  final double offset;
  final double highlightHeaderSize;

  const HeaderEvent({
    this.offset,
    this.highlightHeaderSize,
  });

  @override
  List<Object> get props => [
        offset,
        highlightHeaderSize,
      ];
}
