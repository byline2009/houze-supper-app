import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/language_model.dart';

abstract class LanguageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {
  @override
  String toString() => 'LanguageInitial';
  @override
  List<Object> get props => [];
}

class LanguageLoading extends LanguageState {
  @override
  String toString() => 'LanguageLoading';
  @override
  List<Object> get props => [];
}

class LanguagePicked extends LanguageState {
  final LanguageModel language;

  LanguagePicked({
    required this.language,
  });
  @override
  List<Object> get props => [
        language,
      ];
  @override
  String toString() => 'LanguagePicked { language: ${language.name} }';
}

class LanguageChangedSuccess extends LanguageState {
  final Locale locale;
  LanguageChangedSuccess({
    required this.locale,
  });
  @override
  List<Object> get props => [
        locale,
      ];
  @override
  String toString() =>
      'LanguageChangedSuccess { language: ${locale.countryCode} }';
}
