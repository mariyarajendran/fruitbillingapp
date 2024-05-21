import 'package:IGO/src/data/apis/bills/savebill/ISaveBillListener.dart';
import 'IntractorSaveBill.dart';

class PresenterSaveBillData {
  ISaveBillListener _saveBillListener;
  IntractorSaveBill _intractorSaveBill;

  PresenterSaveBillData(this._saveBillListener) {
    _intractorSaveBill = new IntractorSaveBill(this);
  }

  void onSuccessResponseSaveBill(String msg) {
    _saveBillListener.onSuccessResponseSaveBill(msg);
  }

  void onFailureMessageSaveBill(String error) {
    _saveBillListener.onFailureMessageSaveBill(error);
  }

  void hitPostSaveBillCall() {
    _intractorSaveBill.hitSaveBillCall(_saveBillListener.parseSaveBillData());
  }
}
