import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/di/di.dart';
import 'package:IGO/src/models/responsemodel/customer/customerresponsemodel/CustomerListResponseModel.dart';
import 'ICustomerListener.dart';
import 'IntractorCustomerList.dart';


class PresenterCustomerList {
  AllApiRepository _allApiRepository;
  ICustomerListener _customerListener;
  IntractorCustomerList _intractorCustomerList;

  PresenterCustomerList(this._customerListener) {
    _allApiRepository = new Injector().allApiRepository;
    _intractorCustomerList = new IntractorCustomerList(this);
  }

  void getCustomerList() {
    _intractorCustomerList.getCustomerList(
        _customerListener.parseGetCustomerDetailsRequestData());
  }

  void onSuccessResponseGetCustomerList(
      CustomerListResponseModel customerListResponseModel) {
    if (customerListResponseModel.isSuccess) {
      _customerListener
          .onSuccessResponseGetCustomerList(customerListResponseModel);
    } else {
      _customerListener
          .onFailureResponseGetCustomerList(customerListResponseModel.message);
    }
  }

  void onFailureResponseGetCustomerList(String statusCode) {
    _customerListener.onFailureResponseGetCustomerList(statusCode);
  }
}
