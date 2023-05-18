import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/language_model.dart';

class ChangeLanguageEvent extends Equatable {
  final LanguageModel language;
  const ChangeLanguageEvent({
    @required this.language,
  });

  @override
  List<Object> get props => [
        language,
      ];

  @override
  String toString() => 'ChangeLanguageEvent { language: ${language.name} }';
}
