import 'package:IGO/src/data/apis/dashboard/dashboarddetails/IDashboardDetailsListener.dart';
import 'package:IGO/src/models/responsemodel/dashboard/dashboarddetails/DashboardDetailsResponseModel.dart';
import 'IntractorDashboardDetails.dart';

class PresenterDashboardDetails {
  IDashboardDetailsListener _dashboardDetailsListener;
  IntractorDashboardDetails _intractorDashboardDetails;

  PresenterDashboardDetails(this._dashboardDetailsListener) {
    _intractorDashboardDetails = new IntractorDashboardDetails(this);
  }

  void onSuccessResponseDashboardDetails(DashboardDetails dashboardDetails) {
    _dashboardDetailsListener
        .onSuccessResponseDashboardDetails(dashboardDetails);
  }

  void onFailureMessageDashboardDetails(String error) {
    _dashboardDetailsListener.onFailureMessageDashboardDetails(error);
  }

  void hitGetDashboardDetailsDatas() {
    _intractorDashboardDetails.hitGetDashboardDetailsDatas(
        _dashboardDetailsListener.parseDashboardDetailsData());
  }
}
