import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/data/apis/dashboard/dashboarddetails/PresenterDashboardDetails.dart';
import 'package:IGO/src/data/apis/product/updateproduct/PresenterUpdateProduct.dart';
import 'package:IGO/src/di/di.dart';

class IntractorDashboardDetails {
  PresenterDashboardDetails _presenterDashboardDetails;
  AllApiRepository _allApiRepository;

  IntractorDashboardDetails(
      PresenterDashboardDetails _presenterDashboardDetails) {
    this._presenterDashboardDetails = _presenterDashboardDetails;
    _allApiRepository = new Injector().allApiRepository;
  }

  void hitGetDashboardDetailsDatas(Map mapProductData) {
    _allApiRepository.getDashboardDetailsDatas(mapProductData, 0).then((data) {
      if (data.isSuccess) {
        _presenterDashboardDetails
            .onSuccessResponseDashboardDetails(data.dashboardDetails);
      } else {
        _presenterDashboardDetails
            .onFailureMessageDashboardDetails(data.message);
      }
    }).catchError((error) {
      _presenterDashboardDetails.onFailureMessageDashboardDetails(
          FetchDataException(error).toString());
    });
  }
}
