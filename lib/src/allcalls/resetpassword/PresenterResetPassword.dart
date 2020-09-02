import 'package:IGO/src/allcalls/logout/ILogoutListener.dart';
import 'package:IGO/src/allcalls/logout/IntractorLogout.dart';
import 'package:IGO/src/allcalls/resetpassword/IResetPasswordListener.dart';
import 'package:IGO/src/allcalls/resetpassword/IntractorResetPassword.dart';
import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/di/di.dart';
import 'file:///D:/CGS/PBXAPP/igo-flutter/lib/src/utils/localizations.dart';
import 'package:IGO/src/models/responsemodel/logoutresponsemodel/LogoutResponseModel.dart';
import 'package:IGO/src/models/responsemodel/resetpasswordresponsemodel/ResetResponseModel.dart';
import 'package:IGO/src/ui/forgotscreen/ModalForgotPassword.dart';

class PresenterResetPassword {
  AllApiRepository _allApiRepository;
  IResetPasswordListener _iResetPasswordListener;
  IntractorResetPassword intractorResetPassword;
  ModalForgotPassword _modalForgotPassword;

  PresenterResetPassword(this._iResetPasswordListener) {
    _allApiRepository = new Injector().allApiRepository;
    intractorResetPassword = new IntractorResetPassword(this);
    _modalForgotPassword = new ModalForgotPassword();
  }

  void resetPassword() {
    intractorResetPassword
        .resetPassword(_iResetPasswordListener.parseResetMapData());
  }

  void onSuccessResponseResetPassword(ResetResponseModel resetResponseModel) {
    if (resetResponseModel.success) {
      _iResetPasswordListener
          .onSuccessResponseResetPassword(resetResponseModel);
    } else {
      onFailureResponseResetPassword(
          AppLocalizations.instance.text('key_something_wrong_reset_password'));
    }
  }

  void onFailureResponseResetPassword(String statusCode) {
    _iResetPasswordListener.onFailureResponseResetPassword(statusCode);
  }

  void validateResetDataDatas() {
    RegExp regExp = new RegExp(_modalForgotPassword.emailPattern);
    if (_iResetPasswordListener.getEmailId().isEmpty) {
      _iResetPasswordListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_email_id'));
    } else if (!regExp.hasMatch(_iResetPasswordListener.getEmailId())) {
      _iResetPasswordListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_valid_mailid'));
    } else if (_iResetPasswordListener.getNewPassword().isEmpty) {
      _iResetPasswordListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_new_password'));
    } else {
      _iResetPasswordListener.postResetPassword();
    }
  }
}
