import 'package:equatable/equatable.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/statistic_overview_model.dart';

class DashboardState extends Equatable {
  final bool isLoading;
  final StatisticOverviewModel statisticOverview;
  final String error;

  const DashboardState({
    this.isLoading,
    this.statisticOverview,
    this.error,
  });
  @override
  List<Object> get props => [
        isLoading,
        statisticOverview,
        error,
      ];

  factory DashboardState.initial() {
    return DashboardState(
      statisticOverview: null,
      isLoading: false,
      error: null,
    );
  }

  factory DashboardState.loading() {
    return DashboardState(
      statisticOverview: null,
      isLoading: true,
      error: null,
    );
  }

  factory DashboardState.success(StatisticOverviewModel statisticOverview) {
    return DashboardState(
      statisticOverview: statisticOverview,
      isLoading: false,
      error: null,
    );
  }

  factory DashboardState.error(String code) {
    return DashboardState(
      statisticOverview: null,
      isLoading: false,
      error: code,
    );
  }

  bool get hasLoading =>
      isLoading && error == null && statisticOverview == null;

  bool get hasData => !isLoading && error == null && statisticOverview != null;

  bool get isInitial =>
      !isLoading && error == null && statisticOverview == null;

  bool get hasError => !isLoading && error != null;

  @override
  String toString() {
    if (isInitial) {
      return 'DashboardState initial';
    }
    if (hasData) {
      return 'DashboardState {statisticOverview: ${statisticOverview.toString()}}';
    }
    if (hasLoading) {
      return 'DashboardState is loading';
    }

    if (hasError) {
      return 'DashboardState has error $error';
    }

    return '';
  }
}
