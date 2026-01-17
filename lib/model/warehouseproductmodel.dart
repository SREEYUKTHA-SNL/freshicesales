class WarehouseProductModel {
  String? id;
  String? rate;
  String? partNumber;
  String? barCode;
  String? description;
  String? uomId;
  String? uomUnitId;
  String? uomUnitName;
  String? uomUnitFactor;
  String? availableQty;
  String? label;
  List<ArrUnits>? arrUnits;

  WarehouseProductModel(
      {this.id,
      this.rate,
      this.partNumber,
      this.barCode,
      this.description,
      this.uomId,
      this.uomUnitId,
      this.uomUnitName,
      this.uomUnitFactor,
      this.availableQty,
      this.label,
      this.arrUnits});

  WarehouseProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    rate = json['rate'].toString();
    partNumber = json['part_number'].toString();
    barCode = json['bar_code'].toString();
    description = json['description'].toString();
    uomId = json['uom_id'].toString();
    uomUnitId = json['uom_unit_id'].toString();
    uomUnitName = json['uom_unit_name'].toString();
    uomUnitFactor = json['uom_unit_factor'].toString();
    availableQty = json['available_qty'].toString();
    label = json['label'].toString();
    if (json['arr_units'] != null) {
      arrUnits = <ArrUnits>[];
      json['arr_units'].forEach((v) {
        arrUnits!.add(ArrUnits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['rate'] = rate;
    data['part_number'] = partNumber;
    data['bar_code'] = barCode;
    data['description'] = description;
    data['uom_id'] = uomId;
    data['uom_unit_id'] = uomUnitId;
    data['uom_unit_name'] = uomUnitName;
    data['uom_unit_factor'] = uomUnitFactor;
    data['available_qty'] = availableQty;
    data['label'] = label;
    if (arrUnits != null) {
      data['arr_units'] = arrUnits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ArrUnits {
  String? id;
  String? unitName;
  String? unitFactor;
  String? isSecondaryUnit;
  String? isBase;

  ArrUnits(
      {this.id,
      this.unitName,
      this.unitFactor,
      this.isSecondaryUnit,
      this.isBase});

  ArrUnits.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    unitName = json['unit_name'].toString();
    unitFactor = json['unit_factor'].toString();
    isSecondaryUnit = json['is_secondary_unit'].toString();
    isBase = json['isBase'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['unit_name'] = unitName;
    data['unit_factor'] = unitFactor;
    data['is_secondary_unit'] = isSecondaryUnit;
    data['isBase'] = isBase;
    return data;
  }
}
