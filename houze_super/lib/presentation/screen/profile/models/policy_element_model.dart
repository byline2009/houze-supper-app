import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PolicyElement extends Equatable {
  final String title;
  final String link;

  PolicyElement({@required this.title, @required this.link});

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
      title: 'privacy_policy',
      link:
          'https://drive.google.com/file/d/1AAwFbjbAlIIl0aLPjXTj4B_q_ugOQA49/view?usp=sharing',
    );
  return PolicyElement(
    title: 'dispute_settlement_mechanism',
    link:
        'https://drive.google.com/file/d/1Ju6vob1VGxI8rne_J7HIltq02rMsMbOS/view?usp=sharing',
  );
});
