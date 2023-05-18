
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:path/path.dart';

class PolicyElement extends Equatable {
  final String title;
  final String link;


  PolicyElement({required this.title, required this.link});

  @override
  List<Object> get props => [title, link];
}

final List<PolicyElement> policies = List.generate(3, (i) {
  if (i == 0)
    return PolicyElement(
      title: 'operational_regulations',
      link:
          'https://drive.google.com/file/d/1uL3ox37NmHIB_ItIs9OyJM_iaDqMyvAp/view?usp=sharing',
    );
  if (i == 1)
    return PolicyElement(
      // title: 'Chính sách bảo mật',
      title: 'privacy_policy',
      link:
          'https://houzebuilding.com/privatepolicy.html',
    );
  return PolicyElement(
    // title: 'Cơ chế giải quyết tranh chấp',
    title: 'dispute_settlement_mechanism',
    link:
        'https://drive.google.com/file/d/1Ju6vob1VGxI8rne_J7HIltq02rMsMbOS/view?usp=sharing',
  );
});
