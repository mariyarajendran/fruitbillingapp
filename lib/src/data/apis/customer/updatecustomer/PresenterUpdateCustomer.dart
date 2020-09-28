import 'package:IGO/src/data/apis/customer/updatecustomer/IUpdateCustomerListener.dart';
import 'package:IGO/src/models/responsemodel/customer/updatecustomer/UpdateCustomerResponseModel.dart';
import 'IntractorUpdateCustomer.dart';
import 'file:///D:/CGS/PBXAPP/igo-flutter/lib/src/utils/localizations.dart';


class PresenterUpdateCustomer {
  IUpdateCustomerListener _updateCustomerListener;
  IntractorUpdateCustomer _intractorUpdateCustomer;

  PresenterUpdateCustomer(this._updateCustomerListener) {
    _intractorUpdateCustomer = new IntractorUpdateCustomer(this);
  }

  void onSuccessResponseUpdateCustomer(
      CustomerDetailsUpdate customerDetailsUpdate) {
    _updateCustomerListener
        .onSuccessResponseUpdateCustomer(customerDetailsUpdate);
  }

  void onFailureMessageUpdateCustomer(String error) {
    _updateCustomerListener.onFailureMessageUpdateCustomer(error);
  }

  void hitUpdateCustomerDataCall() {
    _intractorUpdateCustomer.hitCustomerUpdateCall(
        _updateCustomerListener.parseUpdateCustomerData());
  }

  void validateUpdateCustomerData() {
    if (_updateCustomerListener.getCustomerName().isEmpty) {
      _updateCustomerListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_name'));
    } else if (_updateCustomerListener.getCustomerBillingName().isEmpty) {
      _updateCustomerListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_cost'));
    } else if (_updateCustomerListener.getCustomerAddress().isEmpty) {
      _updateCustomerListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_code'));
    } else if (_updateCustomerListener.getCustomerMobileNo().isEmpty) {
      _updateCustomerListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_kg'));
    } else if (_updateCustomerListener.getCustomerWhatsAppNo().isEmpty) {
      _updateCustomerListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_kg'));
    } else if (_updateCustomerListener.getCustomerStatus().isEmpty) {
      _updateCustomerListener.errorValidationMgs(
          AppLocalizations.instance.text('key_product_status'));
    } else {
      _updateCustomerListener.postUpdateCustomerData();
    }
  }
}
