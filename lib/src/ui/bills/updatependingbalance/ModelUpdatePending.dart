class ModelUpdatePending {
  int totalCost;
  int receivedCost;
  int pendingCost;
  int orderSummaryPendingCost;
  int orderPendinghistoryReceivedCost;
  int orderPendinghistoryPendingCost;

  ModelUpdatePending(
      this.totalCost,
      this.receivedCost,
      this.pendingCost,
      this.orderSummaryPendingCost,
      this.orderPendinghistoryReceivedCost,
      this.orderPendinghistoryPendingCost);
}
