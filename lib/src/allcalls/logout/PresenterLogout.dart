import 'package:IGO/src/allcalls/logout/ILogoutListener.dart';
import 'package:IGO/src/allcalls/logout/IntractorLogout.dart';
import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/di/di.dart';
import 'package:IGO/src/models/responsemodel/logoutresponsemodel/LogoutResponseModel.dart';

class PresenterLogout {
  AllApiRepository _allApiRepository;
  ILogoutListener _iLogoutListener;
  IntractorLogout _intractorLogout;

  PresenterLogout(this._iLogoutListener) {
    _allApiRepository = new Injector().allApiRepository;
    _intractorLogout = new IntractorLogout(this);
  }

  void logoutUser() {
    _intractorLogout.logoutUser(_iLogoutListener.getUserId());
  }

  void onSuccessResponseUserLogout(LogoutResponseModel logoutResponseModel) {
    if (logoutResponseModel.success) {
      _iLogoutListener.onSuccessResponseUserLogout(logoutResponseModel);
    } else {
      onFailureResponseGetUserLogout(logoutResponseModel.errorMessage);
    }
  }

  void onFailureResponseGetUserLogout(String statusCode) {
    _iLogoutListener.onFailureResponseGetUserLogout(statusCode);
  }
}
