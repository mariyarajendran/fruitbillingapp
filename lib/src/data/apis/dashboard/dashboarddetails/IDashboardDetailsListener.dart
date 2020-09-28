import 'package:IGO/src/models/responsemodel/dashboard/dashboarddetails/DashboardDetailsResponseModel.dart';

abstract class IDashboardDetailsListener {
  String getFromDate();

  String getToDate();

  Map parseDashboardDetailsData();

  void onSuccessResponseDashboardDetails(DashboardDetails dashboardDetails);

  void onFailureMessageDashboardDetails(String error);
}
