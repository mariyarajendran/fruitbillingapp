class DashboardDetailsResponseModel {
  int code;
  bool isSuccess;
  String message;
  dynamic dashboardDetails;

  DashboardDetailsResponseModel(
      {this.code, this.isSuccess, this.message, this.dashboardDetails});

  DashboardDetailsResponseModel.fromMap(Map<String, dynamic> map)
      : code = map['code'] ?? '',
        isSuccess = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        dashboardDetails = DashboardDetails.fromMap(map['dashboard_details']);
}

class DashboardDetails {
  int customerCount;
  int productCount;
  int totalIncome;
  int pendingIncome;
  int overallAmount;

  DashboardDetails({
    this.customerCount,
    this.productCount,
    this.totalIncome,
    this.pendingIncome,
    this.overallAmount,
  });

  DashboardDetails.fromMap(Map<String, dynamic> map)
      : customerCount = map['customer_count'] ?? 0,
        productCount = map['product_count'] ?? 0,
        totalIncome = map['total_income'] ?? 0,
        pendingIncome = map['pending_income'] ?? 0,
        overallAmount = map['overall_amount'] ?? 0;
}
