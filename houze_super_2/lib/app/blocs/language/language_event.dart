import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/language_model.dart';

abstract class LanguageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LanguageButtonPressed extends LanguageEvent {
  final LanguageModel language;

  LanguageButtonPressed({required this.language});
  @override
  List<Object> get props => [language];
  @override
  String toString() => 'LanguageButtonPressed { language: $language }';
}

class LanguagePickedEvent extends LanguageEvent {
  final LanguageModel language;

  LanguagePickedEvent({
    required this.language,
  });
  @override
  List<Object> get props => [language];
  @override
  String toString() => 'LanguagePickedEvent { language: ${language.name} }';
}
