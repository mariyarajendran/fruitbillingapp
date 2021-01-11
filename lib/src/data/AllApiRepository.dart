import 'package:IGO/src/models/responsemodel/bills/getallpendingbalance/GetPendingBalanceResponseModel.dart';
import 'package:IGO/src/models/responsemodel/bills/getallpendingbalancehistory/GetPendingBalanceHistoryResponseModel.dart';
import 'package:IGO/src/models/responsemodel/bills/savebill/SaveBillResponseModel.dart';
import 'package:IGO/src/models/responsemodel/bills/updatependingbalance/UpdatePendBalanceResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customer/addcustomer/AddCustomerResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customer/customerlist/CustomerListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/customer/updatecustomer/UpdateCustomerResponseModel.dart';
import 'package:IGO/src/models/responsemodel/dashboard/dashboarddetails/DashboardDetailsResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/addproduct/AddProductResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/productlist/ProductListResponseModel.dart';
import 'package:IGO/src/models/responsemodel/product/updateproduct/UpdateProductResponseModel.dart';
import 'package:IGO/src/models/responsemodel/report/orderdetailsreport/OrderDetailsReportResponseModel.dart';
import 'package:IGO/src/models/responsemodel/report/orderreport/OrderReportResponseModel.dart';

abstract class AllApiRepository {
  //////////////////////////////////////////////////////////////////////product
  Future<AddProductResponseModel> postAddProductDatas(
      Map loginDatas, int event);

  Future<UpdateProductResponseModel> postUpdateProductDatas(
      Map requestData, int event);

  Future<ProductListResponseModel> getProductListData(
      Map requestData, int event);

  /////////////////////////////////////////////////////////////////////product

  ////////////////////////////////////////////////////////////////////customer
  Future<CustomerListResponseModel> getCustomerListData(
      Map requestData, int event);

  Future<AddCustomerResponseModel> postAddCustomerDatas(
      Map customerDatas, int event);

  Future<UpdateCustomerResponseModel> postUpdateCustomerDatas(
      Map requestData, int event);

  ////////////////////////////////////////////////////////////////////////////customer

  //////////////////////////////////////////////////////////////////////////dashboard

  Future<DashboardDetailsResponseModel> getDashboardDetailsDatas(
      Map requestData, int event);

//////////////////////////////////////////////////////////////////////////dashboard

//////////////////////////////////////////////////////////////////////reports

  Future<OrderReportResponseModel> getOverAllOrderReports(
      Map requestData, int event);

  Future<OrderDetailsReportResponseModel> getOverAllOrderDetailedReports(
      Map requestData, int event);

//////////////////////////////////////////////////////////////////////reports

////////////////////////////////////////////////////////////////////////bills

  Future<SaveBillResponseModel> postPlaceOrder(Map requestData, int event);

  Future<UpdatePendBalanceResponseModel> updatePendingBalance(
      Map requestData, int event);

  Future<GetPendingBalanceResponseModel> getPendingBalance(
      Map requestData, int event);


  Future<GetPendingBalanceHistoryResponseModel> getPendingBalanceHistory(
      Map requestData, int event);

////////////////////////////////////////////////////////////////////////bills

}
