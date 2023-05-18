import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/domain/index.dart';
import 'package:houze_super/middle/model/facility/facility_detail_model.dart';
import 'package:houze_super/presentation/common_widgets/empty_page.dart';
import 'package:houze_super/presentation/index.dart';

import '../../../../../base/route_aware_state.dart';

class FacilityTermScreenArgument {
  final String id;
  const FacilityTermScreenArgument({required this.id});
}

class FacilityTermScreen extends StatefulWidget {
  final FacilityTermScreenArgument args;

  FacilityTermScreen({Key? key, required this.args}) : super(key: key);

  @override
  FacilityTermScreenState createState() => FacilityTermScreenState();
}

class FacilityTermScreenState extends RouteAwareState<FacilityTermScreen> {
  final _facilityBloc = FacilityBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: 'facility_regulations_and_terms_0',
        child: BlocBuilder<FacilityBloc, FacilityState>(
            bloc: _facilityBloc,
            builder: (
              BuildContext context,
              FacilityState facilityState,
            ) {
              if (facilityState is FacilityInitial) {
                _facilityBloc.add(FacilityGetDetailEvent(id: widget.args.id));
              }

              FacilityDetailModel? _facilityDetail =
                  _facilityBloc.getFacilityDetailModel(facilityState);

              if (_facilityDetail != null) {
                if (_facilityDetail.regulation!.isEmpty) {
                  return EmptyPage(
                    svgPath: AppVectors.icFacility,
                    content: 'there_is_no_information',
                  );
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(_facilityDetail.regulation ?? '',
                        style: AppFonts.medium14),
                  ),
                );
              }

              return Center(child: CupertinoActivityIndicator());
            }));
  }
}
