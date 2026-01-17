class CustomerModel {
  String? id;
  String? name;
  String? phoneNo;

  CustomerModel({this.id, this.name, this.phoneNo});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    phoneNo = json['phone_no'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone_no'] = phoneNo;
    return data;
  }
}
