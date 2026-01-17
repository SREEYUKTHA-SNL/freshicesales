class InventoryModel {
  int? id;
  String? partNumber;
  String? description;
  int? brandId;
  String? brandName;
  int? genericId;
  String? genericName;
  String? availableQty;
  String? defaultUnitName;
  int? defaultUnitId;
  String? defaultUnitFactor;
  String? taxCode;
  String? costRate;
  String? sellingPrice;
  String? secAvailableQty;
  String? secUnitName;
  int? secUnitId;
  String? secUnitFactor;
  String? secCostRate;
  String? secSellingPrice;
  List<ArrUnits>? arrUnits;

  InventoryModel(
      {this.id,
      this.partNumber,
      this.description,
      this.brandId,
      this.brandName,
      this.genericId,
      this.genericName,
      this.availableQty,
      this.defaultUnitName,
      this.defaultUnitId,
      this.defaultUnitFactor,
      this.taxCode,
      this.costRate,
      this.sellingPrice,
      this.secAvailableQty,
      this.secUnitName,
      this.secUnitId,
      this.secUnitFactor,
      this.secCostRate,
      this.secSellingPrice,
      this.arrUnits});

  InventoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    partNumber = json['part_number'];
    description = json['description'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    genericId = json['generic_id'];
    genericName = json['generic_name'];
    availableQty = json['available_qty'];
    defaultUnitName = json['default_unit_name'];
    defaultUnitId = json['default_unit_id'];
    defaultUnitFactor = json['default_unit_factor'];
    taxCode = json['tax_code'];
    costRate = json['cost_rate'];
    sellingPrice = json['selling_price'];
    secAvailableQty = json['sec_available_qty'];
    secUnitName = json['sec_unit_name'];
    secUnitId = json['sec_unit_id'];
    secUnitFactor = json['sec_unit_factor'];
    secCostRate = json['sec_cost_rate'];
    secSellingPrice = json['sec_selling_price'];
    if (json['arr_units'] != null) {
      arrUnits = <ArrUnits>[];
      json['arr_units'].forEach((v) {
        arrUnits!.add( ArrUnits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = id;
    data['part_number'] = partNumber;
    data['description'] = description;
    data['brand_id'] = brandId;
    data['brand_name'] = brandName;
    data['generic_id'] = genericId;
    data['generic_name'] = genericName;
    data['available_qty'] = availableQty;
    data['default_unit_name'] = defaultUnitName;
    data['default_unit_id'] = defaultUnitId;
    data['default_unit_factor'] = defaultUnitFactor;
    data['tax_code'] = taxCode;
    data['cost_rate'] = costRate;
    data['selling_price'] = sellingPrice;
    data['sec_available_qty'] = secAvailableQty;
    data['sec_unit_name'] = secUnitName;
    data['sec_unit_id'] = secUnitId;
    data['sec_unit_factor'] = secUnitFactor;
    data['sec_cost_rate'] = secCostRate;
    data['sec_selling_price'] = secSellingPrice;
    if (arrUnits != null) {
      data['arr_units'] = arrUnits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ArrUnits {
  int? id;
  String? unitName;
  String? unitFactor;
  String? unitPrice;
  String? isSecondaryUnit;
  String? isBase;

  ArrUnits(
      {this.id,
      this.unitName,
      this.unitFactor,
      this.unitPrice,
      this.isSecondaryUnit,
      this.isBase});

  ArrUnits.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['unit_name'];
    unitFactor = json['unit_factor'];
    unitPrice = json['unit_price'];
    isSecondaryUnit = json['is_secondary_unit'];
    isBase = json['isBase'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['unit_name'] = unitName;
    data['unit_factor'] = unitFactor;
    data['unit_price'] = unitPrice;
    data['is_secondary_unit'] = isSecondaryUnit;
    data['isBase'] = isBase;
    return data;
  }
}
