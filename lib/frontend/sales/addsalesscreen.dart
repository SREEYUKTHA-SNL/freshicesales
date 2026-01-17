// // ignore_for_file: prefer_const_constructors, use_build_context_synchronously

// import 'dart:convert';

// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:freshice/backend/api.dart';
// import 'package:freshice/frontend/common/customdrawerscreen.dart';
// import 'package:freshice/frontend/common/successpage.dart';
// import 'package:freshice/model/customermodel.dart';
// import 'package:freshice/model/inventorymodel.dart';
// import 'package:freshice/model/paymenttermmodel.dart';
// import 'package:route_transitions/route_transitions.dart';
// import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart' as bt;


// class AddSalesScreen extends StatefulWidget {
//   final Map<String, dynamic> userdetails;
//   final String userid;
//   final String warehouseid;
//   final String token;
//   const AddSalesScreen(
//       {super.key,  required this.userdetails,required this.userid,
//       required this.warehouseid,
//       required this.token});

//   @override
//   State<AddSalesScreen> createState() => _AddSalesScreenState();
// }

// class _AddSalesScreenState extends State<AddSalesScreen> {
//   PrinterBluetoothManager printerManager = PrinterBluetoothManager();

//   Map<String, dynamic> customer = {};
//   Map<String, dynamic> paymentterm = {};
//   Map<String, dynamic> companydetails = {};
//   List<dynamic> shoppingcart = [];
//   int rounding = 2;
//   String quantity = "";

//   bool loading = false;
//   bool sheetloading = false;
//   bool printneeded = false;

//   Map<String, dynamic> calculateProductItem(
//     Map<String, dynamic> product,
//   ) {
//     print("reached here");
//     String amount = (num.parse(product["selling_price"].toString()) *
//             num.parse(product["quantity"].toString()))
//         .toString();
//     String vat =
//         (num.parse(amount) * (num.parse(product["taxcode"].toString()) / 100))
//             .toString();
//     String net = (num.parse(amount) + num.parse(vat)).toString();
//     product["amount"] = amount;
//     product["vat"] = vat;
//     product["net"] = net;
//     return product;
//   }

//   void updateproductItem(List<dynamic> cart, int index) {
//     String amount = (num.parse(cart[index]["selling_price"].toString()) *
//             num.parse(cart[index]["quantity"].toString()))
//         .toString();
//     String vat = (num.parse(amount) *
//             (num.parse(cart[index]["taxcode"].toString()) / 100))
//         .toString();
//     String net = (num.parse(amount) + num.parse(vat)).toString();
//     cart[index]["amount"] = amount;
//     cart[index]["vat"] = vat;
//     cart[index]["net"] = net;
//   }

//   Future<Map<String, dynamic>> calculateTotal(List<dynamic> inputList) async {
//     double totalamount = 0.0;
//     double totalvat = 0.0;
//     double totalnet = 0.0;

//     for (var element in inputList) {
//       if (element.containsKey("amount") &&
//           element.containsKey("vat") &&
//           element.containsKey("net")) {
//         double amount = double.parse(element["amount"].toString());
//         double vat = double.parse(element["vat"].toString());
//         double net = double.parse(element["net"].toString());
//         totalamount = totalamount + amount;
//         totalvat = totalvat + vat;
//         totalnet = totalnet + net;
//       }
//     }

//     return {
//       "total_amount": totalamount,
//       "total_vat": totalvat,
//       "total_net": totalnet
//     };
//   }

//   Future<Map<String, dynamic>> checkQuantityCheck(
//     List<dynamic> shoppingcart,
//     String currentproductid,
//     String currentquantity,
//   ) async {
//     bool isavailable = false;
//     num quantity = 0;
//     for (int i = 0; i < shoppingcart.length; i++) {
//       if (shoppingcart[i]["id"].toString() == currentproductid) {
//         quantity = quantity + num.parse(shoppingcart[i]["quantity"].toString());
//       }
//     }
//     print("This is the total quantity");
//     print(quantity);

//     return {"status": "success", "is_available": isavailable};
//   }

//   Future<List<dynamic>> convertShoppingCart(
//     List<dynamic> shoppingcart
//   ) async {
//     List<dynamic> result = [];
//     for (int i = 0; i < shoppingcart.length; i++) {
//       final data = {
//         "part_number": shoppingcart[i]["part_number"].toString(),
//         "product_id": shoppingcart[i]["id"].toString(),
//         "description": shoppingcart[i]["description"].toString(),
//         "unit_id": shoppingcart[i]["unit_id"].toString(),
//         "tax_vat_percentage": shoppingcart[i]["taxcode"].toString(),
//         "tax_vat_amount": shoppingcart[i]["vat"].toString(),
//         "quantity":shoppingcart[i]["quantity"].toString(),
//         "rate": shoppingcart[i]["selling_price"].toString(),
//       };
//       result.add(data);
//     }
//     return result;
//   }

//   ArrUnits? getElementWithSecondaryUnitY(List<ArrUnits>? array) {
//     if (array!.isEmpty) return null;
//     return array.firstWhere((item) => item.isSecondaryUnit == 'Y',
//         orElse: () => array.first);
//   }

//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//   //     setState(() {
//   //       loading = true;
//   //     });
//   //     final dynamic response =
//   //         await FreshIceDatabase.instance.getCompanyById(1);
//   //     setState(() {
//   //       companydetails = response["status"] == 0 ? {} : response["data"];
//   //       printneeded =
//   //           widget.userdetails["default_print_check"].toString() == "Y"
//   //               ? true
//   //               : false;
//   //       loading = false;
//   //     });
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: FaIcon(
//               FontAwesomeIcons.arrowLeft,
//               color: API.buttoncolor,
//               size: 20,
//             )),
//         centerTitle: true,
//         title: Text(
//           "Add Sales",
//           style: TextStyle(
//               color: API.buttoncolor,
//               fontSize: 16,
//               fontWeight: FontWeight.w300),
//         ),
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         color: Colors.white,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 50,
//               child: Padding(
//                   padding: const EdgeInsets.only(
//                     top: 5,
//                     bottom: 0,
//                     left: 20,
//                     right: 20,
//                   ),
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     child: customer.isNotEmpty
//                         ? GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 customer = {};
//                                 shoppingcart.clear();
//                               });
//                             },
//                             child: SizedBox(
//                               height: 58,
//                               child: InputDecorator(
//                                 decoration: InputDecoration(
//                                     filled: true,
//                                     fillColor: Colors.white,
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                       borderSide: BorderSide(
//                                         width: 0.5,
//                                       ),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                       borderSide: const BorderSide(
//                                         color: Colors.green,
//                                         width: 0.5,
//                                       ),
//                                     ),
//                                     hintStyle: const TextStyle(
//                                         fontFamily: 'Montserrat',
//                                         color: Color.fromRGBO(181, 184, 203, 1),
//                                         fontWeight: FontWeight.w300,
//                                         fontSize: 11),
//                                     contentPadding: const EdgeInsets.fromLTRB(
//                                         20.0, 5.0, 20.0, 5.0),
//                                     hintText: "Select Customer",
//                                     border: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(8.0))),
//                                 child: Container(
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width /
//                                                 1.6,
//                                         child: Text(
//                                           "${customer["name"]} - ${customer["phone_no"]}",
//                                           style: TextStyle(
//                                             color: API.textcolor,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ),
//                                       Icon(
//                                         Icons.delete,
//                                         color: Colors.grey[400],
//                                         size: 18,
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         : SizedBox(
//                             child: TypeAheadField(
//                                 hideSuggestionsOnKeyboardHide: false,
//                                 textFieldConfiguration: TextFieldConfiguration(
//                                   style: TextStyle(
//                                       color: API.textcolor,
//                                       fontWeight: FontWeight.bold),
//                                   cursorColor: API.bordercolor,
//                                   decoration: InputDecoration(
//                                     border: const OutlineInputBorder(),
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide:
//                                             BorderSide(color: API.appcolor)),
//                                     filled: true,
//                                     fillColor: Colors.white,
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                       borderSide: BorderSide(
//                                         width: 0.5,
//                                       ),
//                                     ),
//                                     hintStyle: const TextStyle(
//                                         fontFamily: 'Montserrat',
//                                         color: Color.fromRGBO(181, 184, 203, 1),
//                                         fontWeight: FontWeight.w300,
//                                         fontSize: 11),
//                                     contentPadding: const EdgeInsets.fromLTRB(
//                                         20.0, 10.0, 20.0, 10.0),
//                                     hintText: "Customer",
//                                   ),
//                                 ),
//                                 suggestionsCallback: (value) async {
//                                   return await API.getCustomerQueryList(value, widget.token);
//                                 },
//                                 itemBuilder: (context,
//                                     CustomerModel? customerlist) {
//                                   final listdata = customerlist;
//                                   return ListTile(
//                                     dense: true,
//                                     title: Text(
//                                       listdata!.name.toString(),
//                                       overflow: TextOverflow.ellipsis,
//                                       softWrap: false,
//                                       maxLines: 1,
//                                       style: TextStyle(
//                                           color: API.textcolor,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w400),
//                                     ),
//                                   );
//                                 },
//                                 onSuggestionSelected: (CustomerModel?
//                                     customerlist) async {
//                                   final data = {
//                                     'id': customerlist!.id,
//                                     "name": customerlist.name,
//                                     "phone_no": customerlist.phoneNo
//                                   };
//                                   setState(() {
//                                     customer = data;
//                                   });
//                                 }),
//                           ),
//                   )),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
//               child: Container(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: const [
//                     Text(
//                       "Choose Items",
//                       style: TextStyle(
//                           color: Color(0xFF263238),
//                           fontWeight: FontWeight.w300,
//                           fontSize: 15),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             AbsorbPointer(
//               absorbing: customer.isEmpty ? true : false,
//               child: SizedBox(
//                 height: 50,
//                 child: Padding(
//                     padding: const EdgeInsets.only(
//                       top: 5,
//                       bottom: 0,
//                       left: 20,
//                       right: 20,
//                     ),
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: SizedBox(
//                         child: TypeAheadField(
//                             textFieldConfiguration: TextFieldConfiguration(
//                               style: TextStyle(
//                                   color: API.textcolor,
//                                   fontWeight: FontWeight.bold),
//                               cursorColor: API.bordercolor,
//                               decoration: InputDecoration(
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                     borderSide: BorderSide(
//                                       color: API.bordercolor,
//                                       width: 0.5,
//                                     ),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                     borderSide: const BorderSide(
//                                       color: Colors.green,
//                                       width: 0.5,
//                                     ),
//                                   ),
//                                   hintStyle: const TextStyle(
//                                       fontFamily: 'Montserrat',
//                                       color: Color.fromRGBO(181, 184, 203, 1),
//                                       fontWeight: FontWeight.w300,
//                                       fontSize: 11),
//                                   contentPadding: const EdgeInsets.fromLTRB(
//                                       20.0, 10.0, 20.0, 10.0),
//                                   hintText: "Product",
//                                   border: OutlineInputBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(8.0))),
//                             ),
//                             suggestionsCallback: (value) async {
//                               return await API.getInventoryQueryList(value, widget.warehouseid, widget.token);
//                             },
//                             itemBuilder: (context, productlist) {
//                               final listdata = productlist;
//                               return ListTile(
//                                 dense: true,
//                                 title: Text(
//                                   "${listdata.partNumber} / ${listdata.description}",
//                                   overflow: TextOverflow.ellipsis,
//                                   softWrap: false,
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                       color: API.textcolor,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400),
//                                 ),
//                               );
//                             },
//                             onSuggestionSelected: (productlist) {
//                               final data = {
//                                 "id": productlist.id.toString(),
//                                 "part_number":
//                                     productlist.partNumber.toString(),
//                                 "description":
//                                     productlist.description.toString(),
//                                 "brand_id": productlist.brandId.toString(),
//                                 "brand_name": productlist.brandName.toString(),
//                                 "generic_id": productlist.genericId.toString(),
//                                 "generic_name":
//                                     productlist.genericName.toString(),
//                                 "available_qty":
//                                     productlist.availableQty.toString(),
//                                 "unit_id": productlist.defaultUnitId.toString(),
//                                 "unit_name":
//                                     productlist.defaultUnitName.toString(),
//                                 "unit_factor":
//                                     productlist.defaultUnitFactor.toString(),
//                                 "taxcode": productlist.taxCode.toString(),
//                                 "cost_rate": productlist.costRate.toString(),
//                                 "selling_price":
//                                     productlist.sellingPrice.toString(),
//                                 "selling_price_controller":
//                                     TextEditingController(
//                                         text: productlist.sellingPrice
//                                             .toString()),
//                                 "arr_units": productlist.arrUnits,
//                                 "quantity": "1",
//                                 "quantity_controller":
//                                     TextEditingController(text: "1"),
//                                 "amount": "0",
//                                 "vat": "0",
//                                 "net": "0"
//                               };
//                               final ArrUnits? selectedunit =
//                                   getElementWithSecondaryUnitY(
//                                      productlist.arrUnits);
//                               setState(() {
//                                 data["unit_id"] =
//                                     selectedunit!.id.toString();
//                                 data["unit_name"] =
//                                     selectedunit.unitName.toString();
//                                 data["unit_factor"] =
//                                     selectedunit.unitFactor.toString();
//                                 data["selling_price"] =
//                                     selectedunit.unitPrice.toString();
//                                 data["selling_price_controller"] =
//                                     TextEditingController(
//                                         text: selectedunit.unitPrice
//                                             .toString());
//                                 shoppingcart.add(calculateProductItem(data));
//                               });
//                               print("This is shopping cart");
//                               print(shoppingcart);
//                             }),
//                       ),
//                     )),
//               ),
//             ),
//             Expanded(
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height,
//                   width: MediaQuery.of(context).size.width,
//                   child: loading
//                       ? const Center(
//                           child: CircularProgressIndicator(
//                             strokeWidth: 1,
//                             color: Colors.green,
//                           ),
//                         )
//                       : Column(
//                           children: [
//                             Expanded(
//                               child: Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 3),
//                                   child: shoppingcart.isEmpty
//                                       ? Center(
//                                           child: SizedBox(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width /
//                                                   2.3,
//                                               child: Image.asset(
//                                                   "assets/images/box.png")),
//                                         )
//                                       : ListView.builder(
//                                           itemCount: shoppingcart.length,
//                                           itemBuilder: (context, index) {
//                                             return SizedBox(
//                                               height: MediaQuery.of(context)
//                                                       .size
//                                                       .height /
//                                                   4.1,
//                                               width: MediaQuery.of(context)
//                                                   .size
//                                                   .width,
//                                               child: Card(
//                                                 elevation: 10,
//                                                 semanticContainer: true,
//                                                 child: Row(
//                                                   children: [
//                                                     SizedBox(
//                                                         width: 80,
//                                                         height:
//                                                             MediaQuery.of(context)
//                                                                     .size
//                                                                     .height /
//                                                                 5,
//                                                         // color: Colors.red,
//                                                         child: Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(20.0),
//                                                           child: Image.asset(
//                                                               'assets/images/noimage.jpg'),
//                                                         )),
//                                                     Expanded(
//                                                         child: Container(
//                                                       child: Column(
//                                                         children: [
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     top: 8,
//                                                                     bottom: 2),
//                                                             child: Row(
//                                                               children: [
//                                                                 Expanded(
//                                                                   child:
//                                                                       Container(
//                                                                     child:
//                                                                         Padding(
//                                                                       padding: const EdgeInsets
//                                                                               .symmetric(
//                                                                           horizontal:
//                                                                               8,
//                                                                           vertical:
//                                                                               0),
//                                                                       child: Text(
//                                                                         "${shoppingcart[(shoppingcart.length - 1) - index]["part_number"]} / ${shoppingcart[(shoppingcart.length - 1) - index]["description"]}",
//                                                                         maxLines:
//                                                                             1,
//                                                                         overflow:
//                                                                             TextOverflow
//                                                                                 .ellipsis,
//                                                                         style: const TextStyle(
//                                                                             color: Colors
//                                                                                 .black,
//                                                                             fontSize:
//                                                                                 13,
//                                                                             fontWeight:
//                                                                                 FontWeight.w500),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                           const Divider(
//                                                             height: 3,
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .symmetric(
//                                                                     horizontal: 8,
//                                                                     vertical: 2),
//                                                             child: Container(
//                                                               child: Row(
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .spaceBetween,
//                                                                 children: [
//                                                                   SizedBox(
//                                                                     width: MediaQuery.of(
//                                                                                 context)
//                                                                             .size
//                                                                             .width /
//                                                                         4.2,
//                                                                     child: Text(
//                                                                       "Amt : ${num.parse(shoppingcart[(shoppingcart.length - 1) - index]["amount"]).toStringAsFixed(rounding)}",
//                                                                       style: const TextStyle(
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontSize:
//                                                                               12,
//                                                                           fontWeight:
//                                                                               FontWeight.w400),
//                                                                     ),
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width: MediaQuery.of(
//                                                                                 context)
//                                                                             .size
//                                                                             .width /
//                                                                         5,
//                                                                     child: Text(
//                                                                       "VAT : ${num.parse(shoppingcart[(shoppingcart.length - 1) - index]["vat"]).toStringAsFixed(rounding)}",
//                                                                       style: const TextStyle(
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontSize:
//                                                                               12,
//                                                                           fontWeight:
//                                                                               FontWeight.w400),
//                                                                     ),
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width: MediaQuery.of(
//                                                                                 context)
//                                                                             .size
//                                                                             .width /
//                                                                         4.2,
//                                                                     child: Text(
//                                                                       "Net : ${num.parse(shoppingcart[(shoppingcart.length - 1) - index]["net"]).toStringAsFixed(rounding)}",
//                                                                       style: const TextStyle(
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontSize:
//                                                                               12,
//                                                                           fontWeight:
//                                                                               FontWeight.w400),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           const Divider(
//                                                             height: 3,
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .symmetric(
//                                                                     horizontal:
//                                                                         8),
//                                                             child: Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Padding(
//                                                                   padding:
//                                                                       const EdgeInsets
//                                                                               .only(
//                                                                           right:
//                                                                               10),
//                                                                   child: Column(
//                                                                     crossAxisAlignment:
//                                                                         CrossAxisAlignment
//                                                                             .start,
//                                                                     children: [
//                                                                       Text(
//                                                                         "Unit",
//                                                                         style: const TextStyle(
//                                                                             color: Colors
//                                                                                 .black,
//                                                                             fontSize:
//                                                                                 10,
//                                                                             fontWeight:
//                                                                                 FontWeight.w400),
//                                                                       ),
//                                                                       GestureDetector(
//                                                                         onTap:
//                                                                             () {
//                                                                           showModalBottomSheet(
//                                                                               context:
//                                                                                   context,
//                                                                               isScrollControlled:
//                                                                                   true,
//                                                                               isDismissible:
//                                                                                   false,
//                                                                               builder:
//                                                                                   (context) {
//                                                                                 return StatefulBuilder(builder: (BuildContext context, StateSetter setSheetState) {
//                                                                                   return Padding(
//                                                                                       padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                                                                                       child: SingleChildScrollView(
//                                                                                           child: Column(mainAxisSize: MainAxisSize.min, children: [
//                                                                                         SizedBox(
//                                                                                           height: 30,
//                                                                                           width: MediaQuery.of(context).size.width,
//                                                                                           child: Row(
//                                                                                             mainAxisAlignment: MainAxisAlignment.center,
//                                                                                             children: [
//                                                                                               Text(
//                                                                                                 "Choose unit",
//                                                                                                 style: TextStyle(color: API.buttoncolor, fontSize: 14, fontWeight: FontWeight.w300),
//                                                                                               ),
//                                                                                             ],
//                                                                                           ),
//                                                                                         ),
//                                                                                         Divider(
//                                                                                           height: 5,
//                                                                                           indent: 30,
//                                                                                           endIndent: 30,
//                                                                                         ),
//                                                                                         Wrap(
//                                                                                           children: (shoppingcart[(shoppingcart.length - 1) - index]["arr_units"] as List<ArrUnits>).map<Widget>((e) {
//                                                                                             return Column(
//                                                                                               children: [
//                                                                                                 SizedBox(
//                                                                                                   width: MediaQuery.of(context).size.width,
//                                                                                                   child: ListTile(
//                                                                                                     onTap: () {
//                                                                                                       setSheetState(() {
//                                                                                                         shoppingcart[(shoppingcart.length - 1) - index]["unit_id"] = e.id.toString();
//                                                                                                         shoppingcart[(shoppingcart.length - 1) - index]["unit_name"] = e.unitName.toString();
//                                                                                                         shoppingcart[(shoppingcart.length - 1) - index]["unit_factor"] = e.unitFactor.toString();
//                                                                                                         shoppingcart[(shoppingcart.length - 1) - index]["selling_price"] = e.unitPrice.toString();
//                                                                                                         shoppingcart[(shoppingcart.length - 1) - index]["selling_price_controller"] = TextEditingController(text: e.unitPrice.toString());
//                                                                                                       });
//                                                                                                       Navigator.pop(context);
//                                                                                                       setState(() {
//                                                                                                         updateproductItem(shoppingcart, (shoppingcart.length - 1) - index);
//                                                                                                       });
//                                                                                                     },
//                                                                                                     title: Column(
//                                                                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                                       children: [
//                                                                                                         Text(
//                                                                                                           "Unit".toString(),
//                                                                                                           style: TextStyle(color: API.buttoncolor, fontSize: 11, fontWeight: FontWeight.w300),
//                                                                                                         ),
//                                                                                                         Text(
//                                                                                                           e.unitName.toString(),
//                                                                                                           style: TextStyle(color: API.buttoncolor, fontSize: 14, fontWeight: FontWeight.w500),
//                                                                                                         ),
//                                                                                                         SizedBox(
//                                                                                                           height: 3,
//                                                                                                         )
//                                                                                                       ],
//                                                                                                     ),
//                                                                                                     subtitle: Row(
//                                                                                                       children: [
//                                                                                                         SizedBox(
//                                                                                                           width: MediaQuery.of(context).size.width / 3.5,
//                                                                                                           child: Column(
//                                                                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                                             children: [
//                                                                                                               Text(
//                                                                                                                 "Factor".toString(),
//                                                                                                                 style: TextStyle(color: API.buttoncolor, fontSize: 11, fontWeight: FontWeight.w300),
//                                                                                                               ),
//                                                                                                               Text(
//                                                                                                                 e.unitFactor.toString(),
//                                                                                                                 style: TextStyle(color: API.buttoncolor, fontSize: 13, fontWeight: FontWeight.w400),
//                                                                                                               ),
//                                                                                                             ],
//                                                                                                           ),
//                                                                                                         ),
//                                                                                                         SizedBox(
//                                                                                                           width: MediaQuery.of(context).size.width / 3.5,
//                                                                                                           child: Column(
//                                                                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                                             children: [
//                                                                                                               Text(
//                                                                                                                 "Price".toString(),
//                                                                                                                 style: TextStyle(color: API.buttoncolor, fontSize: 11, fontWeight: FontWeight.w300),
//                                                                                                               ),
//                                                                                                               Text(
//                                                                                                                 e.unitPrice.toString(),
//                                                                                                                 style: TextStyle(color: API.buttoncolor, fontSize: 13, fontWeight: FontWeight.w400),
//                                                                                                               ),
//                                                                                                             ],
//                                                                                                           ),
//                                                                                                         )
//                                                                                                       ],
//                                                                                                     ),
//                                                                                                     trailing: shoppingcart[(shoppingcart.length - 1) - index]["unit_id"].toString() == e.id.toString()
//                                                                                                         ? Icon(
//                                                                                                             Icons.check_circle_outline_rounded,
//                                                                                                             color: Colors.green,
//                                                                                                           )
//                                                                                                         : Icon(
//                                                                                                             Icons.keyboard_arrow_right_rounded,
//                                                                                                             color: Colors.grey,
//                                                                                                           ),
//                                                                                                   ),
//                                                                                                 ),
//                                                                                                 Divider(
//                                                                                                   height: 5,
//                                                                                                 )
//                                                                                               ],
//                                                                                             );
//                                                                                           }).toList(),
//                                                                                         )
//                                                                                       ])));
//                                                                                 });
//                                                                               });
//                                                                         },
//                                                                         child:
//                                                                             Container(
//                                                                           width:
//                                                                               MediaQuery.of(context).size.width /
//                                                                                   4,
//                                                                           height:
//                                                                               30,
//                                                                           decoration:
//                                                                               BoxDecoration(
//                                                                             color: Color.fromRGBO(
//                                                                                 248,
//                                                                                 248,
//                                                                                 253,
//                                                                                 1),
//                                                                             border:
//                                                                                 Border.all(
//                                                                               color:
//                                                                                   API.bordercolor,
//                                                                             ),
//                                                                           ),
//                                                                           child:
//                                                                               Row(
//                                                                             children: [
//                                                                               Expanded(
//                                                                                   child: Container(
//                                                                                 child: Padding(
//                                                                                   padding: const EdgeInsets.only(left: 5),
//                                                                                   child: Text(
//                                                                                     shoppingcart[(shoppingcart.length - 1) - index]["unit_name"].toString(),
//                                                                                     overflow: TextOverflow.ellipsis,
//                                                                                     style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
//                                                                                   ),
//                                                                                 ),
//                                                                               )),
//                                                                               Icon(
//                                                                                 Icons.keyboard_arrow_down_outlined,
//                                                                                 size: 23,
//                                                                               )
//                                                                             ],
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                                 Column(
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     Text(
//                                                                       "Price",
//                                                                       style: const TextStyle(
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontSize:
//                                                                               10,
//                                                                           fontWeight:
//                                                                               FontWeight.w400),
//                                                                     ),
//                                                                     SizedBox(
//                                                                       width: MediaQuery.of(context)
//                                                                               .size
//                                                                               .width /
//                                                                           4,
//                                                                       height: 30,
//                                                                       child: TextFormField(
//                                                                           key: ValueKey(((shoppingcart.length - 1) - index).toString()),
//                                                                           controller: shoppingcart[(shoppingcart.length - 1) - index]["selling_price_controller"],
//                                                                           keyboardType: TextInputType.number,
//                                                                           cursorColor: Colors.grey[400],
//                                                                           textAlign: TextAlign.center,
//                                                                           inputFormatters: <TextInputFormatter>[
//                                                                             FilteringTextInputFormatter.allow(
//                                                                                 RegExp(r'^\d+\.?\d{0,4}')),
//                                                                             LengthLimitingTextInputFormatter(
//                                                                                 6)
//                                                                           ],
//                                                                           style: TextStyle(
//                                                                             color:
//                                                                                 API.textcolor,
//                                                                             fontSize:
//                                                                                 14,
//                                                                           ),
//                                                                           decoration: InputDecoration(
//                                                                               filled: true,
//                                                                               fillColor: const Color.fromRGBO(248, 248, 253, 1),
//                                                                               enabledBorder: OutlineInputBorder(
//                                                                                 borderRadius: BorderRadius.circular(0.0),
//                                                                                 borderSide: BorderSide(
//                                                                                   color: API.bordercolor,
//                                                                                   width: 1.0,
//                                                                                 ),
//                                                                               ),
//                                                                               focusedBorder: OutlineInputBorder(
//                                                                                 borderRadius: BorderRadius.circular(0.0),
//                                                                                 borderSide: const BorderSide(
//                                                                                   color: Colors.green,
//                                                                                   width: 1.0,
//                                                                                 ),
//                                                                               ),
//                                                                               hintStyle: const TextStyle(color: Color.fromRGBO(181, 184, 203, 1), fontWeight: FontWeight.w300, fontSize: 11),
//                                                                               contentPadding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
//                                                                               hintText: "Price",
//                                                                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
//                                                                           onChanged: (val) {
//                                                                             if (val
//                                                                                 .isEmpty) {
//                                                                               API.showSnackBar(
//                                                                                   "failed",
//                                                                                   "Price should not be empty",
//                                                                                   context);
//                                                                             } else {
//                                                                               setState(() {
//                                                                                 shoppingcart[(shoppingcart.length - 1) - index]["selling_price"] = val.toString();
//                                                                                 updateproductItem(shoppingcart, (shoppingcart.length - 1) - index);
//                                                                               });
//                                                                             }
//                                                                           }),
//                                                                     ),
//                                                                   ],
//                                                                 )
//                                                               ],
//                                                             ),
//                                                           ),
//                                                           Divider(
//                                                             thickness: 0.5,
//                                                             height: 10,
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .symmetric(
//                                                                     horizontal:
//                                                                         8),
//                                                             child: Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .end,
//                                                               children: [
//                                                                 Column(
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .center,
//                                                                   children: [
//                                                                     Text(
//                                                                       "Qty",
//                                                                       style: const TextStyle(
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontSize:
//                                                                               10,
//                                                                           fontWeight:
//                                                                               FontWeight.w400),
//                                                                     ),
//                                                                     SizedBox(
//                                                                       width: 120,
//                                                                       height: 35,
//                                                                       child: Row(
//                                                                         children: [
//                                                                           GestureDetector(
//                                                                             onTap:
//                                                                                 () {
//                                                                               if (int.parse(shoppingcart[(shoppingcart.length - 1) - index]["quantity"]) >
//                                                                                   0) {
//                                                                                 if (int.parse(shoppingcart[(shoppingcart.length - 1) - index]["quantity"]) == 1) {
//                                                                                   setState(() {
//                                                                                     shoppingcart.remove(shoppingcart[(shoppingcart.length - 1) - index]);
//                                                                                   });
//                                                                                 } else {
//                                                                                   setState(() {
//                                                                                     shoppingcart[(shoppingcart.length - 1) - index]["quantity"] = (int.parse(shoppingcart[(shoppingcart.length - 1) - index]["quantity"]) - 1).toString();
//                                                                                     shoppingcart[(shoppingcart.length - 1) - index]["quantity_controller"].text = shoppingcart[(shoppingcart.length - 1) - index]["quantity"].toString();
//                                                                                     updateproductItem(shoppingcart, (shoppingcart.length - 1) - index);
//                                                                                   });
//                                                                                 }
//                                                                               }
//                                                                             },
//                                                                             child:
//                                                                                 const Icon(
//                                                                               Icons.remove,
//                                                                               color:
//                                                                                   Colors.black,
//                                                                               size:
//                                                                                   23,
//                                                                             ),
//                                                                           ),
//                                                                           Expanded(
//                                                                               child:
//                                                                                   Padding(
//                                                                             padding:
//                                                                                 const EdgeInsets.symmetric(vertical: 3),
//                                                                             child:
//                                                                                 Container(
//                                                                               child: TextFormField(
//                                                                                   key: ValueKey(((shoppingcart.length - 1) - index).toString()),
//                                                                                   controller: shoppingcart[(shoppingcart.length - 1) - index]["quantity_controller"],
//                                                                                   keyboardType: TextInputType.number,
//                                                                                   cursorColor: Colors.grey[400],
//                                                                                   textAlign: TextAlign.center,
//                                                                                   inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
//                                                                                   style: TextStyle(
//                                                                                     color: API.textcolor,
//                                                                                     fontSize: 14,
//                                                                                   ),
//                                                                                   decoration: InputDecoration(
//                                                                                       filled: true,
//                                                                                       fillColor: const Color.fromRGBO(248, 248, 253, 1),
//                                                                                       enabledBorder: OutlineInputBorder(
//                                                                                         borderRadius: BorderRadius.circular(0.0),
//                                                                                         borderSide: BorderSide(
//                                                                                           color: API.bordercolor,
//                                                                                           width: 1.0,
//                                                                                         ),
//                                                                                       ),
//                                                                                       focusedBorder: OutlineInputBorder(
//                                                                                         borderRadius: BorderRadius.circular(0.0),
//                                                                                         borderSide: const BorderSide(
//                                                                                           color: Colors.green,
//                                                                                           width: 1.0,
//                                                                                         ),
//                                                                                       ),
//                                                                                       hintStyle: const TextStyle(color: Color.fromRGBO(181, 184, 203, 1), fontWeight: FontWeight.w300, fontSize: 11),
//                                                                                       contentPadding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
//                                                                                       hintText: "Qty",
//                                                                                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
//                                                                                   onChanged: (val) {
//                                                                                     if (val.isEmpty) {
//                                                                                       API.showSnackBar("failed", "Quantity should not be empty", context);
//                                                                                     } else {
//                                                                                       setState(() {
//                                                                                         shoppingcart[(shoppingcart.length - 1) - index]["quantity"] = val.toString();
//                                                                                         updateproductItem(shoppingcart, (shoppingcart.length - 1) - index);
//                                                                                       });
//                                                                                     }
//                                                                                   }),
//                                                                             ),
//                                                                           )),
//                                                                           GestureDetector(
//                                                                             onTap:
//                                                                                 () {
//                                                                               setState(() {
//                                                                                 shoppingcart[(shoppingcart.length - 1) - index]["quantity"] = (int.parse(shoppingcart[(shoppingcart.length - 1) - index]["quantity"]) + 1).toString();
//                                                                                 shoppingcart[(shoppingcart.length - 1) - index]["quantity_controller"].text = shoppingcart[(shoppingcart.length - 1) - index]["quantity"].toString();
//                                                                                 updateproductItem(
//                                                                                   shoppingcart,
//                                                                                   (shoppingcart.length - 1) - index,
//                                                                                 );
//                                                                               });
//                                                                             },
//                                                                             child:
//                                                                                 const Icon(
//                                                                               Icons.add,
//                                                                               color:
//                                                                                   Colors.black,
//                                                                               size:
//                                                                                   23,
//                                                                             ),
//                                                                           )
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 )
//                                                               ],
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ))
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           })),
//                             ),
//                             SizedBox(
//                               height: 60,
//                               width: MediaQuery.of(context).size.width,
//                               // color: Colors.green,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.symmetric(horizontal: 5),
//                                     child: FutureBuilder(
//                                         future: calculateTotal(shoppingcart),
//                                         builder: (context, snapshot) {
//                                           if (snapshot.connectionState ==
//                                               ConnectionState.done) {
//                                             Map<String, dynamic>? details =
//                                                 snapshot.data;
//                                             return Padding(
//                                               padding: const EdgeInsets.symmetric(
//                                                   horizontal: 20),
//                                               child: Text(
//                                                 "Total : ${double.parse((details!["total_net"]).toString()).toStringAsFixed(rounding)}",
//                                                 style: const TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 13,
//                                                     fontWeight: FontWeight.w300),
//                                               ),
//                                             );
//                                           } else {
//                                             return const SizedBox();
//                                           }
//                                         }),
//                                   ),
//                                   Text(
//                                     "Items ( ${shoppingcart.length} )",
//                                     style: const TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w300),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       if (shoppingcart.isEmpty) {
//                                         API.showSnackBar(
//                                             "failed",
//                                             "Please add atleast a item to continue",
//                                             context);
//                                       } else {
//                                         showModalBottomSheet(
//                                             context: context,
//                                             isScrollControlled: true,
//                                             isDismissible: false,
//                                             builder: (context) {
//                                               return StatefulBuilder(builder:
//                                                   (BuildContext context,
//                                                       StateSetter setSheetState) {
//                                                 return sheetloading
//                                                     ? Container(
//                                                         height:
//                                                             MediaQuery.of(context)
//                                                                     .size
//                                                                     .height /
//                                                                 4,
//                                                         width:
//                                                             MediaQuery.of(context)
//                                                                 .size
//                                                                 .width,
//                                                         child: API.loadingScreen(
//                                                             context),
//                                                       )
//                                                     : Padding(
//                                                         padding: EdgeInsets.only(
//                                                             bottom: MediaQuery.of(
//                                                                     context)
//                                                                 .viewInsets
//                                                                 .bottom),
//                                                         child:
//                                                             SingleChildScrollView(
//                                                                 child: Column(
//                                                                     mainAxisSize:
//                                                                         MainAxisSize
//                                                                             .min,
//                                                                     children: [
//                                                               const Divider(),
//                                                               SizedBox(
//                                                                 height: 50,
//                                                                 child: Padding(
//                                                                     padding:
//                                                                         const EdgeInsets
//                                                                             .only(
//                                                                       top: 5,
//                                                                       bottom: 0,
//                                                                       left: 20,
//                                                                       right: 20,
//                                                                     ),
//                                                                     child:
//                                                                         SizedBox(
//                                                                       width: MediaQuery.of(
//                                                                               context)
//                                                                           .size
//                                                                           .width,
//                                                                       child: paymentterm
//                                                                               .isNotEmpty
//                                                                           ? GestureDetector(
//                                                                               onTap:
//                                                                                   () {
//                                                                                 setSheetState(() {
//                                                                                   paymentterm = {};
//                                                                                 });
//                                                                               },
//                                                                               child:
//                                                                                   SizedBox(
//                                                                                 height: 58,
//                                                                                 child: InputDecorator(
//                                                                                   decoration: InputDecoration(
//                                                                                       filled: true,
//                                                                                       fillColor: Colors.white,
//                                                                                       enabledBorder: OutlineInputBorder(
//                                                                                         borderRadius: BorderRadius.circular(5.0),
//                                                                                         borderSide: BorderSide(
//                                                                                           width: 0.5,
//                                                                                         ),
//                                                                                       ),
//                                                                                       focusedBorder: OutlineInputBorder(
//                                                                                         borderRadius: BorderRadius.circular(5.0),
//                                                                                         borderSide: const BorderSide(
//                                                                                           color: Colors.green,
//                                                                                           width: 0.5,
//                                                                                         ),
//                                                                                       ),
//                                                                                       hintStyle: const TextStyle(fontFamily: 'Montserrat', color: Color.fromRGBO(181, 184, 203, 1), fontWeight: FontWeight.w300, fontSize: 11),
//                                                                                       contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                                                                                       hintText: "Payment Term",
//                                                                                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
//                                                                                   child: Container(
//                                                                                     width: MediaQuery.of(context).size.width,
//                                                                                     decoration: const BoxDecoration(
//                                                                                       color: Colors.white,
//                                                                                     ),
//                                                                                     child: Row(
//                                                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                                       children: [
//                                                                                         SizedBox(
//                                                                                           width: MediaQuery.of(context).size.width / 1.6,
//                                                                                           child: Text(
//                                                                                             "${paymentterm["payment_terms_name"]}",
//                                                                                             style: TextStyle(
//                                                                                               color: API.textcolor,
//                                                                                               fontSize: 14,
//                                                                                             ),
//                                                                                           ),
//                                                                                         ),
//                                                                                         Icon(
//                                                                                           Icons.delete,
//                                                                                           color: Colors.grey[400],
//                                                                                           size: 18,
//                                                                                         )
//                                                                                       ],
//                                                                                     ),
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                             )
//                                                                           : SizedBox(
//                                                                               child: TypeAheadField(
//                                                                                   hideSuggestionsOnKeyboardHide: false,
//                                                                                   textFieldConfiguration: TextFieldConfiguration(
//                                                                                     style: TextStyle(color: API.textcolor, fontWeight: FontWeight.bold),
//                                                                                     cursorColor: API.bordercolor,
//                                                                                     decoration: InputDecoration(
//                                                                                       border: const OutlineInputBorder(),
//                                                                                       focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: API.appcolor)),
//                                                                                       filled: true,
//                                                                                       fillColor: Colors.white,
//                                                                                       enabledBorder: OutlineInputBorder(
//                                                                                         borderRadius: BorderRadius.circular(5.0),
//                                                                                         borderSide: BorderSide(
//                                                                                           width: 0.5,
//                                                                                         ),
//                                                                                       ),
//                                                                                       hintStyle: const TextStyle(fontFamily: 'Montserrat', color: Color.fromRGBO(181, 184, 203, 1), fontWeight: FontWeight.w300, fontSize: 11),
//                                                                                       contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                                                                                       hintText: "Payment Term",
//                                                                                     ),
//                                                                                   ),
//                                                                                   suggestionsCallback: (value) async {
//                                                                                     return await API.getPaymentTermQueryList(value, widget.token);
//                                                                                   },
//                                                                                   itemBuilder: (context, PaymentTermModel? paymenttermlist) {
//                                                                                     final listdata = paymenttermlist;
//                                                                                     return ListTile(
//                                                                                       dense: true,
//                                                                                       title: Text(
//                                                                                         listdata!.paymentTermsName.toString(),
//                                                                                         overflow: TextOverflow.ellipsis,
//                                                                                         softWrap: false,
//                                                                                         maxLines: 1,
//                                                                                         style: TextStyle(color: API.textcolor, fontSize: 14, fontWeight: FontWeight.w400),
//                                                                                       ),
//                                                                                     );
//                                                                                   },
//                                                                                   onSuggestionSelected: (PaymentTermModel? paymenttermlist) async {
//                                                                                     final data = {
//                                                                                     "payment_terms_id": paymenttermlist!.paymentTermsId,
//                                                                                     "payment_terms_name": paymenttermlist.paymentTermsName
//                                                                                     };
//                                                                                     print(data);
//                                                                                     setState(() {
//                                                                                       paymentterm = data;
//                                                                                     });
//                                                                                     print(paymentterm);
//                                                                                   }),
//                                                                             ),
//                                                                     )),
//                                                               ),
//                                                               const Divider(
//                                                                 height: 5,
//                                                               ),
//                                                               Row(
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .spaceBetween,
//                                                                 children: [
//                                                                   const Padding(
//                                                                     padding: EdgeInsets
//                                                                         .symmetric(
//                                                                             horizontal:
//                                                                                 20),
//                                                                     child: Text(
//                                                                       "Total Item(s)",
//                                                                       style: TextStyle(
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontSize:
//                                                                               12,
//                                                                           fontWeight:
//                                                                               FontWeight.w500),
//                                                                     ),
//                                                                   ),
//                                                                   Padding(
//                                                                     padding: const EdgeInsets
//                                                                             .symmetric(
//                                                                         horizontal:
//                                                                             20),
//                                                                     child: Text(
//                                                                       shoppingcart
//                                                                           .length
//                                                                           .toString(),
//                                                                       style: const TextStyle(
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontSize:
//                                                                               12,
//                                                                           fontWeight:
//                                                                               FontWeight.w500),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                               const Divider(
//                                                                 height: 5,
//                                                               ),
//                                                               Row(
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .spaceBetween,
//                                                                 children: [
//                                                                   const Padding(
//                                                                     padding: EdgeInsets
//                                                                         .symmetric(
//                                                                             horizontal:
//                                                                                 20),
//                                                                     child: Text(
//                                                                       "Amount",
//                                                                       style: TextStyle(
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontSize:
//                                                                               12,
//                                                                           fontWeight:
//                                                                               FontWeight.w500),
//                                                                     ),
//                                                                   ),
//                                                                   FutureBuilder(
//                                                                       future: calculateTotal(
//                                                                           shoppingcart),
//                                                                       builder:
//                                                                           (context,
//                                                                               snapshot) {
//                                                                         if (snapshot
//                                                                                 .connectionState ==
//                                                                             ConnectionState
//                                                                                 .done) {
//                                                                           Map<String,
//                                                                                   dynamic>?
//                                                                               details =
//                                                                               snapshot.data;
//                                                                           return Padding(
//                                                                             padding:
//                                                                                 const EdgeInsets.symmetric(horizontal: 20),
//                                                                             child:
//                                                                                 Text(
//                                                                               double.parse((details!["total_amount"]).toString()).toStringAsFixed(2),
//                                                                               style: const TextStyle(
//                                                                                   color: Colors.black,
//                                                                                   fontSize: 12,
//                                                                                   fontWeight: FontWeight.w500),
//                                                                             ),
//                                                                           );
//                                                                         } else {
//                                                                           return const Padding(
//                                                                             padding:
//                                                                                 EdgeInsets.symmetric(horizontal: 20),
//                                                                             child:
//                                                                                 Text(
//                                                                               "0",
//                                                                               style: TextStyle(
//                                                                                   color: Colors.black,
//                                                                                   fontSize: 12,
//                                                                                   fontWeight: FontWeight.w500),
//                                                                             ),
//                                                                           );
//                                                                         }
//                                                                       })
//                                                                 ],
//                                                               ),
//                                                               const Divider(
//                                                                 height: 5,
//                                                               ),
//                                                               Row(
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .spaceBetween,
//                                                                 children: [
//                                                                   const Padding(
//                                                                     padding: EdgeInsets
//                                                                         .symmetric(
//                                                                             horizontal:
//                                                                                 20),
//                                                                     child: Text(
//                                                                       "VAT",
//                                                                       style: TextStyle(
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontSize:
//                                                                               12,
//                                                                           fontWeight:
//                                                                               FontWeight.w500),
//                                                                     ),
//                                                                   ),
//                                                                   FutureBuilder(
//                                                                       future: calculateTotal(
//                                                                           shoppingcart),
//                                                                       builder:
//                                                                           (context,
//                                                                               snapshot) {
//                                                                         if (snapshot
//                                                                                 .connectionState ==
//                                                                             ConnectionState
//                                                                                 .done) {
//                                                                           Map<String,
//                                                                                   dynamic>?
//                                                                               details =
//                                                                               snapshot.data;
//                                                                           return Padding(
//                                                                             padding:
//                                                                                 const EdgeInsets.symmetric(horizontal: 20),
//                                                                             child:
//                                                                                 Text(
//                                                                               double.parse((details!["total_vat"]).toString()).toStringAsFixed(2),
//                                                                               style: const TextStyle(
//                                                                                   color: Colors.black,
//                                                                                   fontSize: 12,
//                                                                                   fontWeight: FontWeight.w500),
//                                                                             ),
//                                                                           );
//                                                                         } else {
//                                                                           return const Padding(
//                                                                             padding:
//                                                                                 EdgeInsets.symmetric(horizontal: 20),
//                                                                             child:
//                                                                                 Text(
//                                                                               "0",
//                                                                               style: TextStyle(
//                                                                                   color: Colors.black,
//                                                                                   fontSize: 12,
//                                                                                   fontWeight: FontWeight.w500),
//                                                                             ),
//                                                                           );
//                                                                         }
//                                                                       })
//                                                                 ],
//                                                               ),
//                                                               const Divider(
//                                                                 height: 5,
//                                                               ),
//                                                               Container(
//                                                                 color: Colors
//                                                                     .green[100],
//                                                                 height: 20,
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .spaceBetween,
//                                                                   children: [
//                                                                     const Padding(
//                                                                       padding: EdgeInsets.symmetric(
//                                                                           horizontal:
//                                                                               20),
//                                                                       child: Text(
//                                                                         "Net",
//                                                                         style: TextStyle(
//                                                                             color: Colors
//                                                                                 .black,
//                                                                             fontSize:
//                                                                                 12,
//                                                                             fontWeight:
//                                                                                 FontWeight.w500),
//                                                                       ),
//                                                                     ),
//                                                                     FutureBuilder(
//                                                                         future: calculateTotal(
//                                                                             shoppingcart),
//                                                                         builder:
//                                                                             (context,
//                                                                                 snapshot) {
//                                                                           if (snapshot.connectionState ==
//                                                                               ConnectionState.done) {
//                                                                             Map<String, dynamic>?
//                                                                                 details =
//                                                                                 snapshot.data;
//                                                                             return Padding(
//                                                                               padding:
//                                                                                   const EdgeInsets.symmetric(horizontal: 20),
//                                                                               child:
//                                                                                   Text(
//                                                                                 double.parse((details!["total_net"]).toString()).toStringAsFixed(2),
//                                                                                 style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
//                                                                               ),
//                                                                             );
//                                                                           } else {
//                                                                             return const Padding(
//                                                                               padding:
//                                                                                   EdgeInsets.symmetric(horizontal: 20),
//                                                                               child:
//                                                                                   Text(
//                                                                                 "0",
//                                                                                 style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
//                                                                               ),
//                                                                             );
//                                                                           }
//                                                                         })
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               const SizedBox(
//                                                                 height: 10,
//                                                               ),
//                                                               CheckboxListTile(
//                                                                 title: const Text(
//                                                                   'Need invoice print?',
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .black,
//                                                                       fontSize:
//                                                                           12,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w500),
//                                                                 ),
//                                                                 secondary:
//                                                                     const Icon(Icons
//                                                                         .print),
//                                                                 autofocus: false,
//                                                                 activeColor:
//                                                                     Colors.green,
//                                                                 checkColor:
//                                                                     Colors.white,
//                                                                 selected:
//                                                                     printneeded,
//                                                                 value:
//                                                                     printneeded,
//                                                                 onChanged:
//                                                                     (value) {
//                                                                   setSheetState(
//                                                                       () {
//                                                                     printneeded =
//                                                                         value!;
//                                                                   });
//                                                                   print(
//                                                                       "This is the print needed");
//                                                                   print(
//                                                                       printneeded);
//                                                                 },
//                                                               ),
//                                                               const SizedBox(
//                                                                 height: 10,
//                                                               ),
//                                                               GestureDetector(
//                                                                 onTap: () async {
//                                                                   if (paymentterm
//                                                                       .isEmpty) {
//                                                                     API.showSnackBar(
//                                                                         'failed',
//                                                                         'Please select payment term',
//                                                                         context);
//                                                                   } else {
//                                                                     setSheetState(() {
//                                                                       sheetloading = true;
//                                                                     });
//                                                                     final dynamic
//                                                                         shoppingresponse =
//                                                                         await convertShoppingCart(
//                                                                             shoppingcart
//                                                                          );
//                                                                     print(
//                                                                         "this is the shopping response");
//                                                                     print(
//                                                                         shoppingresponse);
//                                                                       final dynamic salesresponse = await API.postSalesSaveAPI(customer["id"]
//                                                                               .toString(), paymentterm["payment_terms_id"]
//                                                                               .toString(), "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}", shoppingresponse,widget.token, context);
//                                                                       if (salesresponse["status"]
//                                                                               .toString() ==
//                                                                           "success") {
//                                                                         if (printneeded) {
//                                                                           final Map<String, dynamic>
//                                                       response =
//                                                       await API
//                                                           .getInvoicesDetailsByIDAPI(
//                                                               salesresponse["invoice_id"].toString(),
//                                                               widget.token,
//                                                               context
//                                                                 );
//                                                   if (response.isEmpty) {
//                                                     API.showSnackBar(
//                                                         "failed",
//                                                         "Failed to fetch sales details",
//                                                         context);
//                                                   } else {
//                                                       final dynamic
//                                                           printerdetailsresponse =
//                                                           await API
//                                                               .getPrinterDetails();
//                                                       if (printerdetailsresponse[
//                                                               "status"] ==
//                                                           "success") {
//                                                         printerManager.selectPrinter(
//                                                             PrinterBluetooth(
//                                                                 bt.BluetoothDevice
//                                                                     .fromJson({
//                                                           "name":
//                                                               printerdetailsresponse[
//                                                                       "btname"]
//                                                                   .toString(),
//                                                           "address":
//                                                               printerdetailsresponse[
//                                                                       "btaddress"]
//                                                                   .toString()
//                                                         })));
//                                                         const PaperSize paper =
//                                                             PaperSize.mm80;
//                                                         final profile =
//                                                             await CapabilityProfile
//                                                                 .load(
//                                                                     name:
//                                                                         'default');
//                                                         final PosPrintResult
//                                                             printerresponse =
//                                                             await printerManager
//                                                                 .printTicket(
//                                                                     (await API
//                                                                         .printWithDevice(
//                                                           paper,
//                                                           profile,
//                                                           {
//                                                             "company_name": widget
//                                                                 .userdetails[
//                                                                     "companyname"]
//                                                                 .toString(),
//                                                             "company_address": widget
//                                                                 .userdetails[
//                                                                     "companyaddress"]
//                                                                 .toString(),
//                                                             "company_phone": widget
//                                                                 .userdetails[
//                                                                     "companyphone"]
//                                                                 .toString(),
//                                                             "company_trn": widget
//                                                                 .userdetails[
//                                                                     "companytrn"]
//                                                                 .toString(),
//                                                             "invoice_no": response[
//                                                                     "invoice_no"]
//                                                                 .toString(),
//                                                             "invoice_date": response["invoice_created_date_time"].toString(),
//                                                             "customer_name":
//                                                                 response[
//                                                                         "customer_name"]
//                                                                     .toString(),
//                                                             "customer_trn_no":
//                                                                 response["customer_trn"]
//                                                                     .toString(),
//                                                             "salesman":
//                                                                  response["sales_man"]
//                                                                     .toString(),
//                                                             "invoice_item_list":
//                                                                 response[
//                                                                     "invoice_item_list"],
//                                                             "total_amount": num.parse(response[
//                                                                         "sub_total"]
//                                                                     .toString())
//                                                                 .toStringAsFixed(
//                                                                     2),
//                                                             "tax_total": num.parse(response[
//                                                                         "vat_amount"]
//                                                                     .toString())
//                                                                 .toStringAsFixed(
//                                                                     2),
//                                                             "grand_total": num.parse(response[
//                                                                         "grand_total"]
//                                                                     .toString())
//                                                                 .toStringAsFixed(
//                                                                     2),
//                                                             "payment_type":response["payment_term_name"].toString()
//                                                           },
//                                                         )));
//                                                         print(
//                                                             "This is the printer response");
//                                                         print(printerresponse
//                                                             .msg);
//                                                       } else {
//                                                          setSheetState(() {
//                                                                       sheetloading = true;
//                                                                     });
//                                                         API.showSnackBar(
//                                                             "failed",
//                                                             printerdetailsresponse[
//                                                                     "msg"]
//                                                                 .toString(),
//                                                             context);
//                                                                 pushWidgetWhileRemove(
//                                                                               newPage:
//                                                                                   const SuccessPage(screen: CustomDrawerScreen()),
//                                                                               context: context);
//                                                       }
//                                                   }
//                                                                         } else {
//                                                                           print(
//                                                                               "This is not printing");
//                                                                           pushWidgetWhileRemove(
//                                                                               newPage:
//                                                                                   const SuccessPage(screen: CustomDrawerScreen()),
//                                                                               context: context);
//                                                                         }
//                                                                       } else {
//                                                                          setSheetState(() {
//                                                                       sheetloading = false;
//                                                                     });
//                                                                         API.showSnackBar(
//                                                                             "failed",
//                                                                             salesresponse["message"]
//                                                                                 .toString(),
//                                                                             context);
//                                                                       }
//                                                                   }
//                                                                 },
//                                                                 child: Container(
//                                                                   height: 60,
//                                                                   width: MediaQuery.of(
//                                                                           context)
//                                                                       .size
//                                                                       .width,
//                                                                   child: Card(
//                                                                     elevation: 10,
//                                                                     semanticContainer:
//                                                                         true,
//                                                                     color: Colors
//                                                                         .indigo,
//                                                                     child: Row(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .center,
//                                                                       children: const [
//                                                                         Text(
//                                                                           "Submit",
//                                                                           style: TextStyle(
//                                                                               color: Colors
//                                                                                   .white,
//                                                                               fontSize:
//                                                                                   14,
//                                                                               fontWeight:
//                                                                                   FontWeight.w500),
//                                                                         ),
//                                                                         Padding(
//                                                                           padding:
//                                                                               EdgeInsets.symmetric(horizontal: 5),
//                                                                           child:
//                                                                               Text(
//                                                                             "",
//                                                                             style: TextStyle(
//                                                                                 color: Colors.white,
//                                                                                 fontSize: 14,
//                                                                                 fontWeight: FontWeight.w500),
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               )
//                                                             ])),
//                                                       );
//                                               });
//                                             }).then((value) {
//                                           print("This is running");
//                                           setState(() {});
//                                         });
//                                       }
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(right: 10),
//                                       child: Stack(
//                                         children: [
//                                           SizedBox(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 2.5,
//                                             height: 50,
//                                             child: Card(
//                                               elevation: 10,
//                                               color: API.appcolor,
//                                               semanticContainer: true,
//                                               shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(6)),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.spaceAround,
//                                                 children: const [
//                                                   Text(
//                                                     "Shopping Cart",
//                                                     style: TextStyle(
//                                                         color: Colors.white,
//                                                         fontSize: 12,
//                                                         fontWeight:
//                                                             FontWeight.w300),
//                                                   ),
//                                                   Icon(
//                                                     Icons.shopping_bag,
//                                                     color: Colors.white,
//                                                     size: 20,
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshice/backend/api.dart';
import 'package:freshice/frontend/common/customdrawerscreen.dart';
import 'package:freshice/frontend/common/successpage.dart';
import 'package:freshice/model/customermodel.dart';
import 'package:freshice/model/inventorymodel.dart';
import 'package:freshice/model/paymenttermmodel.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart' as bt;

class AddSalesScreen extends StatefulWidget {
  final Map<String, dynamic> userdetails;
  final String userid;
  final String warehouseid;
  final String token;
  const AddSalesScreen(
      {super.key,
      required this.userdetails,
      required this.userid,
      required this.warehouseid,
      required this.token});

  @override
  State<AddSalesScreen> createState() => _AddSalesScreenState();
}

class _AddSalesScreenState extends State<AddSalesScreen> {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();

  Map<String, dynamic> customer = {};
  Map<String, dynamic> paymentterm = {};
  Map<String, dynamic> companydetails = {};
  List<dynamic> shoppingcart = [];
  int rounding = 2;
  String quantity = "";

  bool loading = false;
  bool sheetloading = false;
  bool printneeded = false;

  Map<String, dynamic> calculateProductItem(
    Map<String, dynamic> product,
  ) {
    print("reached here");
    String amount = (num.parse(product["selling_price"].toString()) *
            num.parse(product["quantity"].toString()))
        .toString();
    String vat =
        (num.parse(amount) * (num.parse(product["taxcode"].toString()) / 100))
            .toString();
    String net = (num.parse(amount) + num.parse(vat)).toString();
    product["amount"] = amount;
    product["vat"] = vat;
    product["net"] = net;
    return product;
  }

  void updateproductItem(List<dynamic> cart, int index) {
    String amount = (num.parse(cart[index]["selling_price"].toString()) *
            num.parse(cart[index]["quantity"].toString()))
        .toString();
    String vat = (num.parse(amount) *
            (num.parse(cart[index]["taxcode"].toString()) / 100))
        .toString();
    String net = (num.parse(amount) + num.parse(vat)).toString();
    cart[index]["amount"] = amount;
    cart[index]["vat"] = vat;
    cart[index]["net"] = net;
  }

  Future<Map<String, dynamic>> calculateTotal(List<dynamic> inputList) async {
    double totalamount = 0.0;
    double totalvat = 0.0;
    double totalnet = 0.0;

    for (var element in inputList) {
      if (element.containsKey("amount") &&
          element.containsKey("vat") &&
          element.containsKey("net")) {
        double amount = double.parse(element["amount"].toString());
        double vat = double.parse(element["vat"].toString());
        double net = double.parse(element["net"].toString());
        totalamount = totalamount + amount;
        totalvat = totalvat + vat;
        totalnet = totalnet + net;
      }
    }

    return {
      "total_amount": totalamount,
      "total_vat": totalvat,
      "total_net": totalnet
    };
  }

  Future<Map<String, dynamic>> checkQuantityCheck(
    List<dynamic> shoppingcart,
    String currentproductid,
    String currentquantity,
  ) async {
    bool isavailable = false;
    num quantity = 0;
    for (int i = 0; i < shoppingcart.length; i++) {
      if (shoppingcart[i]["id"].toString() == currentproductid) {
        quantity = quantity + num.parse(shoppingcart[i]["quantity"].toString());
      }
    }
    print("This is the total quantity");
    print(quantity);

    return {"status": "success", "is_available": isavailable};
  }

  Future<List<dynamic>> convertShoppingCart(List<dynamic> shoppingcart) async {
    List<dynamic> result = [];
    for (int i = 0; i < shoppingcart.length; i++) {
      final data = {
        "part_number": shoppingcart[i]["part_number"].toString(),
        "product_id": shoppingcart[i]["id"].toString(),
        "description": shoppingcart[i]["description"].toString(),
        "unit_id": shoppingcart[i]["unit_id"].toString(),
        "tax_vat_percentage": shoppingcart[i]["taxcode"].toString(),
        "tax_vat_amount": shoppingcart[i]["vat"].toString(),
        "quantity": shoppingcart[i]["quantity"].toString(),
        "rate": shoppingcart[i]["selling_price"].toString(),
      };
      result.add(data);
    }
    return result;
  }

  ArrUnits? getElementWithSecondaryUnitY(List<ArrUnits>? array) {
    if (array!.isEmpty) return null;
    return array.firstWhere((item) => item.isSecondaryUnit == 'Y',
        orElse: () => array.first);
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //     setState(() {
  //       loading = true;
  //     });
  //     final dynamic response =
  //         await FreshIceDatabase.instance.getCompanyById(1);
  //     setState(() {
  //       companydetails = response["status"] == 0 ? {} : response["data"];
  //       printneeded =
  //           widget.userdetails["default_print_check"].toString() == "Y"
  //               ? true
  //               : false;
  //       loading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: API.buttoncolor,
              size: 20,
            )),
        centerTitle: true,
        title: Text(
          "Add Sales",
          style: TextStyle(
              color: API.buttoncolor,
              fontSize: 16,
              fontWeight: FontWeight.w300),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 0,
                      left: 20,
                      right: 20,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: customer.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  customer = {};
                                  shoppingcart.clear();
                                });
                              },
                              child: SizedBox(
                                height: 58,
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          width: 0.5,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: Colors.green,
                                          width: 0.5,
                                        ),
                                      ),
                                      hintStyle: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color.fromRGBO(181, 184, 203, 1),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 11),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 5.0, 20.0, 5.0),
                                      hintText: "Select Customer",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0))),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width /
                                                  1.6,
                                          child: Text(
                                            "${customer["name"]} - ${customer["phone_no"]}",
                                            style: TextStyle(
                                              color: API.textcolor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.delete,
                                          color: Colors.grey[400],
                                          size: 18,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              child: TypeAheadField(
                                  hideSuggestionsOnKeyboardHide: false,
                                  textFieldConfiguration: TextFieldConfiguration(
                                    style: TextStyle(
                                        color: API.textcolor,
                                        fontWeight: FontWeight.bold),
                                    cursorColor: API.bordercolor,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: API.appcolor)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          width: 0.5,
                                        ),
                                      ),
                                      hintStyle: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color.fromRGBO(181, 184, 203, 1),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 11),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      hintText: "Customer",
                                    ),
                                  ),
                                  suggestionsCallback: (value) async {
                                    return await API.getCustomerQueryList(
                                        value, widget.token);
                                  },
                                  itemBuilder:
                                      (context, CustomerModel? customerlist) {
                                    final listdata = customerlist;
                                    return ListTile(
                                      dense: true,
                                      title: Text(
                                        listdata!.name.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: API.textcolor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (CustomerModel? customerlist) async {
                                    final data = {
                                      'id': customerlist!.id,
                                      "name": customerlist.name,
                                      "phone_no": customerlist.phoneNo
                                    };
                                    setState(() {
                                      customer = data;
                                    });
                                  }),
                            ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Choose Items",
                        style: TextStyle(
                            color: Color(0xFF263238),
                            fontWeight: FontWeight.w300,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              AbsorbPointer(
                absorbing: customer.isEmpty ? true : false,
                child: SizedBox(
                  height: 50,
                  child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 0,
                        left: 20,
                        right: 20,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SizedBox(
                          child: TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                style: TextStyle(
                                    color: API.textcolor,
                                    fontWeight: FontWeight.bold),
                                cursorColor: API.bordercolor,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: API.bordercolor,
                                        width: 0.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: Colors.green,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintStyle: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Color.fromRGBO(181, 184, 203, 1),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 11),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    hintText: "Product",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0))),
                              ),
                              suggestionsCallback: (value) async {
                                return await API.getInventoryQueryList(
                                    value, widget.warehouseid, widget.token);
                              },
                              itemBuilder: (context, productlist) {
                                final listdata = productlist;
                                return ListTile(
                                  dense: true,
                                  title: Text(
                                    "${listdata.partNumber} / ${listdata.description}",
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: API.textcolor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                );
                              },
                              onSuggestionSelected: (productlist) {
                                final data = {
                                  "id": productlist.id.toString(),
                                  "part_number":
                                      productlist.partNumber.toString(),
                                  "description":
                                      productlist.description.toString(),
                                  "brand_id": productlist.brandId.toString(),
                                  "brand_name": productlist.brandName.toString(),
                                  "generic_id": productlist.genericId.toString(),
                                  "generic_name":
                                      productlist.genericName.toString(),
                                  "available_qty":
                                      productlist.availableQty.toString(),
                                  "unit_id": productlist.defaultUnitId.toString(),
                                  "unit_name":
                                      productlist.defaultUnitName.toString(),
                                  "unit_factor":
                                      productlist.defaultUnitFactor.toString(),
                                  "taxcode": productlist.taxCode.toString(),
                                  "cost_rate": productlist.costRate.toString(),
                                  "selling_price":
                                      productlist.sellingPrice.toString(),
                                  "selling_price_controller":
                                      TextEditingController(
                                          text: productlist.sellingPrice
                                              .toString()),
                                  "arr_units": productlist.arrUnits,
                                  "quantity": "1",
                                  "quantity_controller":
                                      TextEditingController(text: "1"),
                                  "amount": "0",
                                  "vat": "0",
                                  "net": "0"
                                };
                                final ArrUnits? selectedunit =
                                    getElementWithSecondaryUnitY(
                                        productlist.arrUnits);
                                setState(() {
                                  data["unit_id"] = selectedunit!.id.toString();
                                  data["unit_name"] =
                                      selectedunit.unitName.toString();
                                  data["unit_factor"] =
                                      selectedunit.unitFactor.toString();
                                  data["selling_price"] =
                                      selectedunit.unitPrice.toString();
                                  data["selling_price_controller"] =
                                      TextEditingController(
                                          text:
                                              selectedunit.unitPrice.toString());
                                  shoppingcart.add(calculateProductItem(data));
                                });
                                print("This is shopping cart");
                                print(shoppingcart);
                              }),
                        ),
                      )),
                ),
              ),
              Expanded(
                  child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Colors.green,
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: shoppingcart.isEmpty
                                    ? Center(
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.3,
                                            child: Image.asset(
                                                "assets/images/box.png")),
                                      )
                                    : ListView.builder(
                                        itemCount: shoppingcart.length,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4.1,
                                            width:
                                                MediaQuery.of(context).size.width,
                                            child: Card(
                                              elevation: 10,
                                              semanticContainer: true,
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                      width: 80,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              5,
                                                      // color: Colors.red,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                20.0),
                                                        child: Image.asset(
                                                            'assets/images/noimage.jpg'),
                                                      )),
                                                  Expanded(
                                                      child: Container(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8,
                                                                  bottom: 2),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            0),
                                                                    child: Text(
                                                                      "${shoppingcart[(shoppingcart.length - 1) - index]["part_number"]} / ${shoppingcart[(shoppingcart.length - 1) - index]["description"]}",
                                                                      maxLines: 1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Divider(
                                                          height: 3,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 2),
                                                          child: Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      4.2,
                                                                  child: Text(
                                                                    "Amt : ${num.parse(shoppingcart[(shoppingcart.length - 1) - index]["amount"]).toStringAsFixed(rounding)}",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      5,
                                                                  child: Text(
                                                                    "VAT : ${num.parse(shoppingcart[(shoppingcart.length - 1) - index]["vat"]).toStringAsFixed(rounding)}",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      4.2,
                                                                  child: Text(
                                                                    "Net : ${num.parse(shoppingcart[(shoppingcart.length - 1) - index]["net"]).toStringAsFixed(rounding)}",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const Divider(
                                                          height: 3,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Unit",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        showModalBottomSheet(
                                                                            context:
                                                                                context,
                                                                            isScrollControlled:
                                                                                true,
                                                                            isDismissible:
                                                                                false,
                                                                            builder:
                                                                                (context) {
                                                                              return StatefulBuilder(builder:
                                                                                  (BuildContext context, StateSetter setSheetState) {
                                                                                return SafeArea(
                                                                                  child: Padding(
                                                                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                                      child: SingleChildScrollView(
                                                                                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                                                                                        SizedBox(
                                                                                          height: 30,
                                                                                          width: MediaQuery.of(context).size.width,
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                "Choose unit",
                                                                                                style: TextStyle(color: API.buttoncolor, fontSize: 14, fontWeight: FontWeight.w300),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Divider(
                                                                                          height: 5,
                                                                                          indent: 30,
                                                                                          endIndent: 30,
                                                                                        ),
                                                                                        Wrap(
                                                                                          children: (shoppingcart[(shoppingcart.length - 1) - index]["arr_units"] as List<ArrUnits>).map<Widget>((e) {
                                                                                            return Column(
                                                                                              children: [
                                                                                                SizedBox(
                                                                                                  width: MediaQuery.of(context).size.width,
                                                                                                  child: ListTile(
                                                                                                    onTap: () {
                                                                                                      setSheetState(() {
                                                                                                        shoppingcart[(shoppingcart.length - 1) - index]["unit_id"] = e.id.toString();
                                                                                                        shoppingcart[(shoppingcart.length - 1) - index]["unit_name"] = e.unitName.toString();
                                                                                                        shoppingcart[(shoppingcart.length - 1) - index]["unit_factor"] = e.unitFactor.toString();
                                                                                                        shoppingcart[(shoppingcart.length - 1) - index]["selling_price"] = e.unitPrice.toString();
                                                                                                        shoppingcart[(shoppingcart.length - 1) - index]["selling_price_controller"] = TextEditingController(text: e.unitPrice.toString());
                                                                                                      });
                                                                                                      Navigator.pop(context);
                                                                                                      setState(() {
                                                                                                        updateproductItem(shoppingcart, (shoppingcart.length - 1) - index);
                                                                                                      });
                                                                                                    },
                                                                                                    title: Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          "Unit".toString(),
                                                                                                          style: TextStyle(color: API.buttoncolor, fontSize: 11, fontWeight: FontWeight.w300),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          e.unitName.toString(),
                                                                                                          style: TextStyle(color: API.buttoncolor, fontSize: 14, fontWeight: FontWeight.w500),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          height: 3,
                                                                                                        )
                                                                                                      ],
                                                                                                    ),
                                                                                                    subtitle: Row(
                                                                                                      children: [
                                                                                                        SizedBox(
                                                                                                          width: MediaQuery.of(context).size.width / 3.5,
                                                                                                          child: Column(
                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                "Factor".toString(),
                                                                                                                style: TextStyle(color: API.buttoncolor, fontSize: 11, fontWeight: FontWeight.w300),
                                                                                                              ),
                                                                                                              Text(
                                                                                                                e.unitFactor.toString(),
                                                                                                                style: TextStyle(color: API.buttoncolor, fontSize: 13, fontWeight: FontWeight.w400),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: MediaQuery.of(context).size.width / 3.5,
                                                                                                          child: Column(
                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                "Price".toString(),
                                                                                                                style: TextStyle(color: API.buttoncolor, fontSize: 11, fontWeight: FontWeight.w300),
                                                                                                              ),
                                                                                                              Text(
                                                                                                                e.unitPrice.toString(),
                                                                                                                style: TextStyle(color: API.buttoncolor, fontSize: 13, fontWeight: FontWeight.w400),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    ),
                                                                                                    trailing: shoppingcart[(shoppingcart.length - 1) - index]["unit_id"].toString() == e.id.toString()
                                                                                                        ? Icon(
                                                                                                            Icons.check_circle_outline_rounded,
                                                                                                            color: Colors.green,
                                                                                                          )
                                                                                                        : Icon(
                                                                                                            Icons.keyboard_arrow_right_rounded,
                                                                                                            color: Colors.grey,
                                                                                                          ),
                                                                                                  ),
                                                                                                ),
                                                                                                Divider(
                                                                                                  height: 5,
                                                                                                )
                                                                                              ],
                                                                                            );
                                                                                          }).toList(),
                                                                                        )
                                                                                      ]))),
                                                                                );
                                                                              });
                                                                            });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.of(context)
                                                                                .size
                                                                                .width /
                                                                            4,
                                                                        height:
                                                                            30,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Color.fromRGBO(
                                                                              248,
                                                                              248,
                                                                              253,
                                                                              1),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                API.bordercolor,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Expanded(
                                                                                child: Container(
                                                                              child:
                                                                                  Padding(
                                                                                padding: const EdgeInsets.only(left: 5),
                                                                                child: Text(
                                                                                  shoppingcart[(shoppingcart.length - 1) - index]["unit_name"].toString(),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                            Icon(
                                                                              Icons.keyboard_arrow_down_outlined,
                                                                              size:
                                                                                  23,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Price",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400),
                                                                  ),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width /
                                                                        4,
                                                                    height: 30,
                                                                    child: TextFormField(
                                                                        key: ValueKey(((shoppingcart.length - 1) - index).toString()),
                                                                        controller: shoppingcart[(shoppingcart.length - 1) - index]["selling_price_controller"],
                                                                        keyboardType: TextInputType.number,
                                                                        cursorColor: Colors.grey[400],
                                                                        textAlign: TextAlign.center,
                                                                        inputFormatters: <TextInputFormatter>[
                                                                          FilteringTextInputFormatter.allow(
                                                                              RegExp(r'^\d+\.?\d{0,4}')),
                                                                          LengthLimitingTextInputFormatter(
                                                                              6)
                                                                        ],
                                                                        style: TextStyle(
                                                                          color: API
                                                                              .textcolor,
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                        decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: const Color.fromRGBO(248, 248, 253, 1),
                                                                            enabledBorder: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(0.0),
                                                                              borderSide:
                                                                                  BorderSide(
                                                                                color: API.bordercolor,
                                                                                width: 1.0,
                                                                              ),
                                                                            ),
                                                                            focusedBorder: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(0.0),
                                                                              borderSide:
                                                                                  const BorderSide(
                                                                                color: Colors.green,
                                                                                width: 1.0,
                                                                              ),
                                                                            ),
                                                                            hintStyle: const TextStyle(color: Color.fromRGBO(181, 184, 203, 1), fontWeight: FontWeight.w300, fontSize: 11),
                                                                            contentPadding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
                                                                            hintText: "Price",
                                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
                                                                        onChanged: (val) {
                                                                          if (val
                                                                              .isEmpty) {
                                                                            API.showSnackBar(
                                                                                "failed",
                                                                                "Price should not be empty",
                                                                                context);
                                                                          } else {
                                                                            setState(
                                                                                () {
                                                                              shoppingcart[(shoppingcart.length - 1) - index]["selling_price"] =
                                                                                  val.toString();
                                                                              updateproductItem(shoppingcart,
                                                                                  (shoppingcart.length - 1) - index);
                                                                            });
                                                                          }
                                                                        }),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          thickness: 0.5,
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Qty",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 120,
                                                                    height: 35,
                                                                    child: Row(
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            if (int.parse(shoppingcart[(shoppingcart.length - 1) - index]["quantity"]) >
                                                                                0) {
                                                                              if (int.parse(shoppingcart[(shoppingcart.length - 1) - index]["quantity"]) ==
                                                                                  1) {
                                                                                setState(() {
                                                                                  shoppingcart.remove(shoppingcart[(shoppingcart.length - 1) - index]);
                                                                                });
                                                                              } else {
                                                                                setState(() {
                                                                                  shoppingcart[(shoppingcart.length - 1) - index]["quantity"] = (int.parse(shoppingcart[(shoppingcart.length - 1) - index]["quantity"]) - 1).toString();
                                                                                  shoppingcart[(shoppingcart.length - 1) - index]["quantity_controller"].text = shoppingcart[(shoppingcart.length - 1) - index]["quantity"].toString();
                                                                                  updateproductItem(shoppingcart, (shoppingcart.length - 1) - index);
                                                                                });
                                                                              }
                                                                            }
                                                                          },
                                                                          child:
                                                                              const Icon(
                                                                            Icons
                                                                                .remove,
                                                                            color:
                                                                                Colors.black,
                                                                            size:
                                                                                23,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical:
                                                                                  3),
                                                                          child:
                                                                              Container(
                                                                            child: TextFormField(
                                                                                key: ValueKey(((shoppingcart.length - 1) - index).toString()),
                                                                                controller: shoppingcart[(shoppingcart.length - 1) - index]["quantity_controller"],
                                                                                keyboardType: TextInputType.number,
                                                                                cursorColor: Colors.grey[400],
                                                                                textAlign: TextAlign.center,
                                                                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                                                                                style: TextStyle(
                                                                                  color: API.textcolor,
                                                                                  fontSize: 14,
                                                                                ),
                                                                                decoration: InputDecoration(
                                                                                    filled: true,
                                                                                    fillColor: const Color.fromRGBO(248, 248, 253, 1),
                                                                                    enabledBorder: OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.circular(0.0),
                                                                                      borderSide: BorderSide(
                                                                                        color: API.bordercolor,
                                                                                        width: 1.0,
                                                                                      ),
                                                                                    ),
                                                                                    focusedBorder: OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.circular(0.0),
                                                                                      borderSide: const BorderSide(
                                                                                        color: Colors.green,
                                                                                        width: 1.0,
                                                                                      ),
                                                                                    ),
                                                                                    hintStyle: const TextStyle(color: Color.fromRGBO(181, 184, 203, 1), fontWeight: FontWeight.w300, fontSize: 11),
                                                                                    contentPadding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
                                                                                    hintText: "Qty",
                                                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
                                                                                onChanged: (val) {
                                                                                  if (val.isEmpty) {
                                                                                    API.showSnackBar("failed", "Quantity should not be empty", context);
                                                                                  } else {
                                                                                    setState(() {
                                                                                      shoppingcart[(shoppingcart.length - 1) - index]["quantity"] = val.toString();
                                                                                      updateproductItem(shoppingcart, (shoppingcart.length - 1) - index);
                                                                                    });
                                                                                  }
                                                                                }),
                                                                          ),
                                                                        )),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            setState(
                                                                                () {
                                                                              shoppingcart[(shoppingcart.length - 1) - index]["quantity"] =
                                                                                  (int.parse(shoppingcart[(shoppingcart.length - 1) - index]["quantity"]) + 1).toString();
                                                                              shoppingcart[(shoppingcart.length - 1) - index]["quantity_controller"].text =
                                                                                  shoppingcart[(shoppingcart.length - 1) - index]["quantity"].toString();
                                                                              updateproductItem(
                                                                                shoppingcart,
                                                                                (shoppingcart.length - 1) - index,
                                                                              );
                                                                            });
                                                                          },
                                                                          child:
                                                                              const Icon(
                                                                            Icons
                                                                                .add,
                                                                            color:
                                                                                Colors.black,
                                                                            size:
                                                                                23,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          );
                                        })),
                          ),
                          SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            // color: Colors.green,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: FutureBuilder(
                                      future: calculateTotal(shoppingcart),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          Map<String, dynamic>? details =
                                              snapshot.data;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                              "Total : ${double.parse((details!["total_net"]).toString()).toStringAsFixed(rounding)}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      }),
                                ),
                                Text(
                                  "Items ( ${shoppingcart.length} )",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (shoppingcart.isEmpty) {
                                      API.showSnackBar(
                                          "failed",
                                          "Please add atleast a item to continue",
                                          context);
                                    } else {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          isDismissible: false,
                                          builder: (context) {
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setSheetState) {
                                              return sheetloading
                                                  ?printneeded?Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              4,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child:Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            height: 50,
                                                            width: 50,
                                                            child: Image.asset("assets/images/photo-print.png"),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 15),
                                                            child: Text("Printing... Please wait!",
                                                            style: const TextStyle(
                                                                                              color: Colors.black,
                                                                                              fontSize: 13,
                                                                                              fontWeight: FontWeight.w300),
                                                                                                                ),
                                                          )
                                                        ],
                                                      )
                                                    ): Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              4,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: API
                                                          .loadingScreen(context),
                                                    )
                                                  : Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      child:
                                                          SafeArea(
                                                            child: SingleChildScrollView(
                                                                child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                              const Divider(),
                                                              SizedBox(
                                                                height: 50,
                                                                child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 5,
                                                                      bottom: 0,
                                                                      left: 20,
                                                                      right: 20,
                                                                    ),
                                                                    child: SizedBox(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      child: paymentterm
                                                                              .isNotEmpty
                                                                          ? GestureDetector(
                                                                              onTap:
                                                                                  () {
                                                                                setSheetState(() {
                                                                                  paymentterm = {};
                                                                                });
                                                                              },
                                                                              child:
                                                                                  SizedBox(
                                                                                height:
                                                                                    58,
                                                                                child:
                                                                                    InputDecorator(
                                                                                  decoration: InputDecoration(
                                                                                      filled: true,
                                                                                      fillColor: Colors.white,
                                                                                      enabledBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(5.0),
                                                                                        borderSide: BorderSide(
                                                                                          width: 0.5,
                                                                                        ),
                                                                                      ),
                                                                                      focusedBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(5.0),
                                                                                        borderSide: const BorderSide(
                                                                                          color: Colors.green,
                                                                                          width: 0.5,
                                                                                        ),
                                                                                      ),
                                                                                      hintStyle: const TextStyle(fontFamily: 'Montserrat', color: Color.fromRGBO(181, 184, 203, 1), fontWeight: FontWeight.w300, fontSize: 11),
                                                                                      contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                                                                      hintText: "Payment Term",
                                                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
                                                                                  child: Container(
                                                                                    width: MediaQuery.of(context).size.width,
                                                                                    decoration: const BoxDecoration(
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          width: MediaQuery.of(context).size.width / 1.6,
                                                                                          child: Text(
                                                                                            "${paymentterm["payment_terms_name"]}",
                                                                                            style: TextStyle(
                                                                                              color: API.textcolor,
                                                                                              fontSize: 14,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Icon(
                                                                                          Icons.delete,
                                                                                          color: Colors.grey[400],
                                                                                          size: 18,
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : SizedBox(
                                                                              child: TypeAheadField(
                                                                                  hideSuggestionsOnKeyboardHide: false,
                                                                                  textFieldConfiguration: TextFieldConfiguration(
                                                                                    style: TextStyle(color: API.textcolor, fontWeight: FontWeight.bold),
                                                                                    cursorColor: API.bordercolor,
                                                                                    decoration: InputDecoration(
                                                                                      border: const OutlineInputBorder(),
                                                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: API.appcolor)),
                                                                                      filled: true,
                                                                                      fillColor: Colors.white,
                                                                                      enabledBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(5.0),
                                                                                        borderSide: BorderSide(
                                                                                          width: 0.5,
                                                                                        ),
                                                                                      ),
                                                                                      hintStyle: const TextStyle(fontFamily: 'Montserrat', color: Color.fromRGBO(181, 184, 203, 1), fontWeight: FontWeight.w300, fontSize: 11),
                                                                                      contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                                                                      hintText: "Payment Term",
                                                                                    ),
                                                                                  ),
                                                                                  suggestionsCallback: (value) async {
                                                                                    return await API.getPaymentTermQueryList(value, widget.token);
                                                                                  },
                                                                                  itemBuilder: (context, PaymentTermModel? paymenttermlist) {
                                                                                    final listdata = paymenttermlist;
                                                                                    return ListTile(
                                                                                      dense: true,
                                                                                      title: Text(
                                                                                        listdata!.paymentTermsName.toString(),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        softWrap: false,
                                                                                        maxLines: 1,
                                                                                        style: TextStyle(color: API.textcolor, fontSize: 14, fontWeight: FontWeight.w400),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                  onSuggestionSelected: (PaymentTermModel? paymenttermlist) async {
                                                                                    final data = {
                                                                                      "payment_terms_id": paymenttermlist!.paymentTermsId,
                                                                                      "payment_terms_name": paymenttermlist.paymentTermsName
                                                                                    };
                                                                                    print(data);
                                                                                    setState(() {
                                                                                      paymentterm = data;
                                                                                    });
                                                                                    print(paymentterm);
                                                                                  }),
                                                                            ),
                                                                    )),
                                                              ),
                                                              const Divider(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Padding(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                20),
                                                                    child: Text(
                                                                      "Total Item(s)",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            20),
                                                                    child: Text(
                                                                      shoppingcart
                                                                          .length
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Divider(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Padding(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                20),
                                                                    child: Text(
                                                                      "Amount",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500),
                                                                    ),
                                                                  ),
                                                                  FutureBuilder(
                                                                      future: calculateTotal(
                                                                          shoppingcart),
                                                                      builder: (context,
                                                                          snapshot) {
                                                                        if (snapshot
                                                                                .connectionState ==
                                                                            ConnectionState
                                                                                .done) {
                                                                          Map<String,
                                                                                  dynamic>?
                                                                              details =
                                                                              snapshot
                                                                                  .data;
                                                                          return Padding(
                                                                            padding: const EdgeInsets
                                                                                .symmetric(
                                                                                horizontal:
                                                                                    20),
                                                                            child:
                                                                                Text(
                                                                              double.parse((details!["total_amount"]).toString())
                                                                                  .toStringAsFixed(2),
                                                                              style: const TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w500),
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          return const Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 20),
                                                                            child:
                                                                                Text(
                                                                              "0",
                                                                              style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w500),
                                                                            ),
                                                                          );
                                                                        }
                                                                      })
                                                                ],
                                                              ),
                                                              const Divider(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Padding(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                20),
                                                                    child: Text(
                                                                      "VAT",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500),
                                                                    ),
                                                                  ),
                                                                  FutureBuilder(
                                                                      future: calculateTotal(
                                                                          shoppingcart),
                                                                      builder: (context,
                                                                          snapshot) {
                                                                        if (snapshot
                                                                                .connectionState ==
                                                                            ConnectionState
                                                                                .done) {
                                                                          Map<String,
                                                                                  dynamic>?
                                                                              details =
                                                                              snapshot
                                                                                  .data;
                                                                          return Padding(
                                                                            padding: const EdgeInsets
                                                                                .symmetric(
                                                                                horizontal:
                                                                                    20),
                                                                            child:
                                                                                Text(
                                                                              double.parse((details!["total_vat"]).toString())
                                                                                  .toStringAsFixed(2),
                                                                              style: const TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w500),
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          return const Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 20),
                                                                            child:
                                                                                Text(
                                                                              "0",
                                                                              style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w500),
                                                                            ),
                                                                          );
                                                                        }
                                                                      })
                                                                ],
                                                              ),
                                                              const Divider(
                                                                height: 5,
                                                              ),
                                                              Container(
                                                                color: Colors
                                                                    .green[100],
                                                                height: 20,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Padding(
                                                                      padding: EdgeInsets
                                                                          .symmetric(
                                                                              horizontal:
                                                                                  20),
                                                                      child: Text(
                                                                        "Net",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                    FutureBuilder(
                                                                        future: calculateTotal(
                                                                            shoppingcart),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          if (snapshot
                                                                                  .connectionState ==
                                                                              ConnectionState
                                                                                  .done) {
                                                                            Map<String,
                                                                                    dynamic>?
                                                                                details =
                                                                                snapshot.data;
                                                                            return Padding(
                                                                              padding: const EdgeInsets
                                                                                  .symmetric(
                                                                                  horizontal: 20),
                                                                              child:
                                                                                  Text(
                                                                                double.parse((details!["total_net"]).toString()).toStringAsFixed(2),
                                                                                style: const TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500),
                                                                              ),
                                                                            );
                                                                          } else {
                                                                            return const Padding(
                                                                              padding:
                                                                                  EdgeInsets.symmetric(horizontal: 20),
                                                                              child:
                                                                                  Text(
                                                                                "0",
                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500),
                                                                              ),
                                                                            );
                                                                          }
                                                                        })
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              CheckboxListTile(
                                                                title: const Text(
                                                                  'Need invoice print?',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                secondary:
                                                                    const Icon(Icons
                                                                        .print),
                                                                autofocus: false,
                                                                activeColor:
                                                                    Colors.green,
                                                                checkColor:
                                                                    Colors.white,
                                                                selected:
                                                                    printneeded,
                                                                value: printneeded,
                                                                onChanged: (value) {
                                                                  setSheetState(() {
                                                                    printneeded =
                                                                        value!;
                                                                  });
                                                                  print(
                                                                      "This is the print needed");
                                                                  print(
                                                                      printneeded);
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  if (paymentterm
                                                                      .isEmpty) {
                                                                    API.showSnackBar(
                                                                        'failed',
                                                                        'Please select payment term',
                                                                        context);
                                                                  } else {
                                                                    setSheetState(
                                                                        () {
                                                                      sheetloading =
                                                                          true;
                                                                    });
                                                                    final dynamic
                                                                        shoppingresponse =
                                                                        await convertShoppingCart(
                                                                            shoppingcart);
                                                                    print(
                                                                        "this is the shopping response");
                                                                    print(
                                                                        shoppingresponse);
                                                                    final dynamic salesresponse = await API.postSalesSaveAPI(
                                                                        customer[
                                                                                "id"]
                                                                            .toString(),
                                                                        paymentterm[
                                                                                "payment_terms_id"]
                                                                            .toString(),
                                                                        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                                                        shoppingresponse,
                                                                        widget
                                                                            .token,
                                                                        context);
                                                                    if (salesresponse[
                                                                                "status"]
                                                                            .toString() ==
                                                                        "success") {
                                                                      if (printneeded) {
                                                                        final Map<
                                                                                String,
                                                                                dynamic>
                                                                            response =
                                                                            await API.getInvoicesDetailsByIDAPI(
                                                                                salesresponse["invoice_id"].toString(),
                                                                                widget.token,
                                                                                context);
                                                                        if (response
                                                                            .isEmpty) {
                                                                        setSheetState(
                                                                          () {
                                                                            sheetloading =
                                                                            false;
                                                                            });
                                                                          API.showSnackBar(
                                                                              "failed",
                                                                              "Failed to fetch sales details",
                                                                              context);
                                                                        } else {
                                                                          final dynamic
                                                                              printerdetailsresponse =
                                                                              await API
                                                                                  .getPrinterDetails();
                                                                          if (printerdetailsresponse[
                                                                                  "status"] ==
                                                                              "success") {
                                                                            printerManager
                                                                                .selectPrinter(PrinterBluetooth(bt.BluetoothDevice.fromJson({
                                                                              "name":
                                                                                  printerdetailsresponse["btname"].toString(),
                                                                              "address":
                                                                                  printerdetailsresponse["btaddress"].toString()
                                                                            })));
                                                                            const PaperSize
                                                                                paper =
                                                                                PaperSize.mm80;
                                                                            final profile =
                                                                                await CapabilityProfile.load(name: 'default');
                                                                            final PosPrintResult
                                                                                printerresponse =
                                                                                await printerManager.printTicket((await API.printWithDevice(
                                                                              paper,
                                                                              profile,
                                                                              {
                                                                                "company_name":
                                                                                    widget.userdetails["companyname"].toString(),
                                                                                "company_address":
                                                                                    widget.userdetails["companyaddress"].toString(),
                                                                                "company_phone":
                                                                                    widget.userdetails["companyphone"].toString(),
                                                                                "company_trn":
                                                                                    widget.userdetails["companytrn"].toString(),
                                                                                "invoice_no":
                                                                                    response["invoice_no"].toString(),
                                                                                "invoice_date":
                                                                                    response["invoice_created_date_time"].toString(),
                                                                                "customer_name":
                                                                                    response["customer_name"].toString(),
                                                                                "customer_trn_no":
                                                                                    response["customer_trn"].toString(),
                                                                                "salesman":
                                                                                    response["sales_man"].toString(),
                                                                                "invoice_item_list":
                                                                                    response["invoice_item_list"],
                                                                                "total_amount":
                                                                                    num.parse(response["sub_total"].toString()).toStringAsFixed(2),
                                                                                "tax_total":
                                                                                    num.parse(response["vat_amount"].toString()).toStringAsFixed(2),
                                                                                "grand_total":
                                                                                    num.parse(response["grand_total"].toString()).toStringAsFixed(2),
                                                                                "payment_type":
                                                                                    response["payment_term_name"].toString()
                                                                              },
                                                                            )));
                                                                            pushWidgetWhileRemove(
                                                                                newPage:
                                                                                    const SuccessPage(screen: CustomDrawerScreen()),
                                                                            context: context);
                                                                           
                                                                          } else {
                                                                            setSheetState(
                                                                                () {
                                                                              sheetloading =
                                                                                  false;
                                                                            });
                                                                            API.showSnackBar(
                                                                                "failed",
                                                                                printerdetailsresponse["msg"].toString(),
                                                                                context);
                                                                            pushWidgetWhileRemove(
                                                                                newPage:
                                                                                    const SuccessPage(screen: CustomDrawerScreen()),
                                                                                context: context);
                                                                          }
                                                                        }
                                                                      } else {
                                                                        print(
                                                                            "This is not printing");
                                                                        pushWidgetWhileRemove(
                                                                            newPage: const SuccessPage(
                                                                                screen:
                                                                                    CustomDrawerScreen()),
                                                                            context:
                                                                                context);
                                                                      }
                                                                    } else {
                                                                      setSheetState(
                                                                          () {
                                                                        sheetloading =
                                                                            false;
                                                                      });
                                                                      API.showSnackBar(
                                                                          "failed",
                                                                          salesresponse[
                                                                                  "message"]
                                                                              .toString(),
                                                                          context);
                                                                    }
                                                                  }
                                                                },
                                                                child: Container(
                                                                  height: 60,
                                                                  width:
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                  child: Card(
                                                                    elevation: 10,
                                                                    semanticContainer:
                                                                        true,
                                                                    color: Colors
                                                                        .indigo,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: const [
                                                                        Text(
                                                                          "Submit",
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize:
                                                                                  14,
                                                                              fontWeight:
                                                                                  FontWeight.w500),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal:
                                                                                  5),
                                                                          child:
                                                                              Text(
                                                                            "",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white,
                                                                                fontSize:
                                                                                    14,
                                                                                fontWeight:
                                                                                    FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ])),
                                                          ),
                                                    );
                                            });
                                          }).then((value) {
                                        print("This is running");
                                        setState(() {});
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width /
                                                  2.5,
                                          height: 50,
                                          child: Card(
                                            elevation: 10,
                                            color: API.appcolor,
                                            semanticContainer: true,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: const [
                                                Text(
                                                  "Shopping Cart",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Icon(
                                                  Icons.shopping_bag,
                                                  color: Colors.white,
                                                  size: 20,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
