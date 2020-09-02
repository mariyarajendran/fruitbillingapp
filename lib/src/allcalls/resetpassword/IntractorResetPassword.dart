import 'package:IGO/src/allcalls/logout/PresenterLogout.dart';
import 'package:IGO/src/allcalls/resetpassword/PresenterResetPassword.dart';
import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/di/di.dart';

class IntractorResetPassword {
  PresenterResetPassword _presenterResetPassword;
  AllApiRepository _allApiRepository;

  IntractorResetPassword(PresenterResetPassword _presenterResetPassword) {
    _allApiRepository = new Injector().allApiRepository;
    this._presenterResetPassword = _presenterResetPassword;
  }

  void resetPassword(Map map) {
    _allApiRepository.postResetPasswordDatas(map, 0).then((data) {
      _presenterResetPassword.onSuccessResponseResetPassword(data);
    }).catchError((error) {
      _presenterResetPassword.onFailureResponseResetPassword(
          new FetchDataException(error.toString()).toString());
    });
  }
}
