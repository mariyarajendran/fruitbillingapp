import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/di/di.dart';
import 'IAddCustomerListener.dart';
import 'IntractorAddCustomer.dart';
import 'file:///D:/CGS/PBXAPP/igo-flutter/lib/src/utils/localizations.dart';

class PresenterAddCustomer {
  IAddCustomerListener _addCustomerListener;
  IntractorAddCustomer _intractorAddCustomer;

  PresenterAddCustomer(this._addCustomerListener) {
    _intractorAddCustomer = new IntractorAddCustomer(this);
  }

  void onSuccessResponseAddProduct(String msg) {
    _addCustomerListener.onSuccessResponseAddProduct(msg);
  }

  void onFailureMessageAddProduct(String error) {
    _addCustomerListener.onFailureMessageAddProduct(error);
  }

  void hitPostCustomerDataCall() {
    _intractorAddCustomer
        .hitCustomerAddCall(_addCustomerListener.parseAddCustomerData());
  }

  void validateAddCustomerData() {
    if (_addCustomerListener.getCustomerName().isEmpty) {
      _addCustomerListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_customer_name'));
    } else if (_addCustomerListener.getCustomerBillingName().isEmpty) {
      _addCustomerListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_customer_bill_name'));
    } else if (_addCustomerListener.getCustomerAddress().isEmpty) {
      _addCustomerListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_customer_address'));
    } else if (_addCustomerListener.getCustomerPhoneNumber().isEmpty) {
      _addCustomerListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_customer_phone_no'));
    } else if (_addCustomerListener.getCustomerWhatsAppNumberNumber().isEmpty) {
      _addCustomerListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_customer_whatsapp_no'));
    } else {
      _addCustomerListener.hitPostAddCustomerData();
    }
  }
}
