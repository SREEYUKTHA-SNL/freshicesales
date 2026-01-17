class PaymentTermModel {
  int? paymentTermsId;
  String? paymentTermsName;

  PaymentTermModel({this.paymentTermsId, this.paymentTermsName});

  PaymentTermModel.fromJson(Map<String, dynamic> json) {
    paymentTermsId = json['payment_terms_id'];
    paymentTermsName = json['payment_terms_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_terms_id'] = paymentTermsId;
    data['payment_terms_name'] = paymentTermsName;
    return data;
  }
}
