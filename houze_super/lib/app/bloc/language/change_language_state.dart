import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/language_model.dart';

class ChangeLanguageState extends Equatable {
  final bool isLoading;
  final LanguageModel language;
  final String error;

  const ChangeLanguageState({
    this.isLoading,
    this.language,
    this.error,
  });
  @override
  List<Object> get props => [
        isLoading,
        language,
        error,
      ];

  factory ChangeLanguageState.initial() {
    return ChangeLanguageState(
      language: null,
      isLoading: false,
      error: null,
    );
  }

  factory ChangeLanguageState.loading() {
    return ChangeLanguageState(
      language: null,
      isLoading: true,
      error: null,
    );
  }

  factory ChangeLanguageState.success(LanguageModel language) {
    return ChangeLanguageState(
      language: language,
      isLoading: false,
      error: null,
    );
  }

  factory ChangeLanguageState.error(String code) {
    return ChangeLanguageState(
      language: null,
      isLoading: false,
      error: code,
    );
  }

  bool get hasLoading => isLoading && error == null && language == null;
  bool get hasData => !isLoading && error == null && language != null;
  bool get isInitial => !isLoading && error == null && language == null;
  bool get hasError => !isLoading && error != null;

  @override
  String toString() {
    if (isInitial) {
      return 'ChangeLanguageState initial';
    }
    if (hasData) {
      return 'ChangeLanguageState {language: ${language.name}}';
    }
    if (hasLoading) {
      return 'ChangeLanguageState is loading';
    }

    if (hasError) {
      return 'ChangeLanguageState has error $error';
    }

    return '';
  }
}
