import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/domain/index.dart';
import 'package:houze_super/middle/model/facility/facility_detail_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/empty_page.dart';
import 'package:houze_super/presentation/index.dart';

class FacilityTermScreenArgument {
  final String id;
  const FacilityTermScreenArgument({@required this.id});
}

class FacilityTermScreen extends StatefulWidget {
  final FacilityTermScreenArgument args;

  FacilityTermScreen({Key key, @required this.args}) : super(key: key);

  @override
  FacilityTermScreenState createState() => FacilityTermScreenState();
}

class FacilityTermScreenState extends State<FacilityTermScreen> {
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
            cubit: _facilityBloc,
            builder: (
              BuildContext context,
              FacilityState facilityState,
            ) {
              if (facilityState is FacilityInitial) {
                _facilityBloc.add(FacilityGetDetailEvent(id: widget.args.id));
              }

              FacilityDetailModel _facilityDetail;
              if (facilityState is GetFacilityDetailSuccess) {
                _facilityDetail =
                    _facilityBloc.getFacilityDetailModel(facilityState);
                if (_facilityDetail == null) {
                  return Center(
                      child: Text(LocalizationsUtil.of(context)
                          .translate("lost_connection")));
                }
              }

              if (_facilityDetail != null) {
                if (_facilityDetail.regulation.isEmpty) {
                  return EmptyPage(
                    svgPath: AppVectors.icFacility,
                    content: 'there_is_no_information',
                  );
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(_facilityDetail.regulation,
                        style: AppFonts.medium14.copyWith(color: Colors.black)),
                  ),
                );
              }

              return Center(child: CupertinoActivityIndicator());
            }));
  }
}
