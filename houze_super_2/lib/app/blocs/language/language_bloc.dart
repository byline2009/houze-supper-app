import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/app/blocs/language/language_event.dart';
import 'package:houze_super/app/blocs/language/language_state.dart';
import 'package:houze_super/middle/local/storage.dart';


/* Handling of languages changes */
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final countryCode = {
    "en": "US",
    "vi": "VN",
    "zh": "CN",
    "ko": "KR",
    "ja": "JP",
  };

  LanguageBloc() : super(LanguageInitial()) {
    on<LanguageButtonPressed>((event, emit) async {
      emit(LanguageLoading());
      await Storage.saveLanguage(event.language);
      emit(LanguagePicked(language: event.language));
    });

    on<LanguagePickedEvent>((event, emit) async {
      emit(LanguageLoading());
      final Locale locale = Locale(
        event.language.locale!,
        countryCode[event.language.locale],
      );
      emit(LanguageChangedSuccess(locale: locale));
    });
  }
}
