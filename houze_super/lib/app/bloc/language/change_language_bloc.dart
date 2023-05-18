import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:houze_super/app/bloc/language/change_language_event.dart';
import 'package:houze_super/app/bloc/language/change_language_state.dart';
import 'package:houze_super/middle/local/storage.dart';

class ChangeLanguageBloc
    extends Bloc<ChangeLanguageEvent, ChangeLanguageState> {
  ChangeLanguageBloc() : super(ChangeLanguageState.initial());

  @override
  Stream<ChangeLanguageState> mapEventToState(
      ChangeLanguageEvent event) async* {
    yield ChangeLanguageState.loading();
    try {
      await Storage.saveLanguage(
        event.language,
      );
      yield ChangeLanguageState.success(event.language);
    } catch (e) {
      yield ChangeLanguageState.error(e.code);
    }
  }
}
