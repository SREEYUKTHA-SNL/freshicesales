// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshice/backend/api.dart';
import 'package:freshice/frontend/common/customdrawerscreen.dart';
import 'package:freshice/frontend/common/homescreen.dart';
import 'package:freshice/frontend/common/successpage.dart';
import 'package:freshice/model/warehousemodel.dart';
import 'package:freshice/model/warehouseproductmodel.dart';
import 'package:get/get.dart';
import 'package:route_transitions/route_transitions.dart';

class AddTransfer extends StatefulWidget {
  final String token;
  const AddTransfer({super.key, required this.token});

  @override
  State<AddTransfer> createState() => _AddTransferState();
}

class _AddTransferState extends State<AddTransfer> {
  TextEditingController referrencecontroller = TextEditingController();
  TextEditingController quantitycontroller = TextEditingController();

  Map<String, dynamic> fromwarehouse = {};
  Map<String, dynamic> towarehouse = {};
  WarehouseProductModel? selecteditem;

  List<dynamic> itemslist = [];

  bool loading = false;
  bool sheetloading = false;

  Future<bool> checkProductAvailable(
      List<dynamic> items, String productid, String unitid) async {
    bool result = false;
    for (int i = 0; i < items.length; i++) {
      if (items[i]["item_id"].toString() == productid &&
          items[i]["unit"].toString() == unitid) {
        result = true;
      }
    }
    return result;
  }

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
          "Add Transfer",
          style: TextStyle(
              color: API.buttoncolor,
              fontSize: 16,
              fontWeight: FontWeight.w300),
        ),
      ),
      bottomNavigationBar: loading
          ? const SizedBox()
          : itemslist.isEmpty
              ? const SizedBox()
              : Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Items ( ${itemslist.length} )",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            loading = true;
                          });
                          final dynamic response = await API.postTransferAPI(
                              "",
                              fromwarehouse["id"].toString(),
                              towarehouse["id"].toString(),
                              referrencecontroller.text,
                              "",
                              "",
                              itemslist,
                              widget.token,
                              context);
                          if (response["status"] == "success") {
                            pushWidgetWhileRemove(
                                newPage: const SuccessPage(
                                    screen: CustomDrawerScreen()),
                                context: context);
                          } else {
                            setState(() {
                              loading = false;
                            });
                            API.showSnackBar("failed",
                                response["message"].toString(), context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                height: 50,
                                child: Card(
                                  elevation: 10,
                                  color: API.appcolor,
                                  semanticContainer: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Text(
                                        "Submit",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Icon(
                                        Icons.check_circle,
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
                ),
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: loading
                ? API.loadingScreen(context)
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Text(
                            "From Warehouse",
                            style: TextStyle(
                                color: API.textcolor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
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
                                child: fromwarehouse.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            fromwarehouse = {};
                                            towarehouse = {};
                                          });
                                        },
                                        child: SizedBox(
                                          height: 58,
                                          child: InputDecorator(
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5.0),
                                                  borderSide: const BorderSide(
                                                    width: 0.5,
                                                  ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.green,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                hintStyle: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Color.fromRGBO(
                                                        181, 184, 203, 1),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 11),
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 5.0, 20.0, 5.0),
                                                hintText: "From Warehouse",
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0))),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        1.6,
                                                    child: Text(
                                                      "${fromwarehouse["name"]}",
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
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              style: TextStyle(
                                                  color: API.textcolor,
                                                  fontWeight: FontWeight.bold),
                                              cursorColor: API.bordercolor,
                                              decoration: InputDecoration(
                                                border:
                                                    const OutlineInputBorder(),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: API.appcolor)),
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5.0),
                                                  borderSide: const BorderSide(
                                                    width: 0.5,
                                                  ),
                                                ),
                                                hintStyle: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Color.fromRGBO(
                                                        181, 184, 203, 1),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 11),
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 10.0),
                                                hintText: "From Warehouse",
                                              ),
                                            ),
                                            suggestionsCallback: (value) async {
                                              return await API
                                                  .postWarehouseListAPI(
                                                      widget.token,
                                                      "",
                                                      "FROM",
                                                      context);
                                            },
                                            itemBuilder: (context,
                                                WarehouseModel? warehouselist) {
                                              final listdata = warehouselist;
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
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              );
                                            },
                                            onSuggestionSelected: (WarehouseModel?
                                                warehouselist) async {
                                              final data = {
                                                'id': warehouselist!.id,
                                                "name": warehouselist.name,
                                              };
                                              setState(() {
                                                fromwarehouse = data;
                                              });
                                              print(fromwarehouse);
                                            }),
                                      ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Text(
                            "To Warehouse",
                            style: TextStyle(
                                color: API.textcolor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        AbsorbPointer(
                          absorbing: fromwarehouse.isEmpty ? true : false,
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
                                  child: towarehouse.isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              towarehouse = {};
                                            });
                                          },
                                          child: SizedBox(
                                            height: 58,
                                            child: InputDecorator(
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    borderSide: const BorderSide(
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    borderSide: const BorderSide(
                                                      color: Colors.green,
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  hintStyle: const TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Color.fromRGBO(
                                                          181, 184, 203, 1),
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 11),
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          20.0, 5.0, 20.0, 5.0),
                                                  hintText: "To Warehouse",
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0))),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.6,
                                                      child: Text(
                                                        "${towarehouse["name"]}",
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
                                              hideSuggestionsOnKeyboardHide:
                                                  false,
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                style: TextStyle(
                                                    color: API.textcolor,
                                                    fontWeight: FontWeight.bold),
                                                cursorColor: API.bordercolor,
                                                decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  API.appcolor)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    borderSide: const BorderSide(
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  hintStyle: const TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Color.fromRGBO(
                                                          181, 184, 203, 1),
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 11),
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          20.0, 10.0, 20.0, 10.0),
                                                  hintText: "To Warehouse",
                                                ),
                                              ),
                                              suggestionsCallback: (value) async {
                                                return await API
                                                    .postWarehouseListAPI(
                                                        widget.token,
                                                        fromwarehouse["id"]
                                                            .toString(),
                                                        "TO",
                                                        context);
                                              },
                                              itemBuilder: (context,
                                                  WarehouseModel? warehouselist) {
                                                final listdata = warehouselist;
                                                return ListTile(
                                                  dense: true,
                                                  title: Text(
                                                    listdata!.name.toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: false,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: API.textcolor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                );
                                              },
                                              onSuggestionSelected:
                                                  (WarehouseModel?
                                                      warehouselist) async {
                                                final data = {
                                                  'id': warehouselist!.id,
                                                  "name": warehouselist.name,
                                                };
                                                setState(() {
                                                  towarehouse = data;
                                                });
                                                print(towarehouse);
                                              }),
                                        ),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Text(
                            "Reference",
                            style: TextStyle(
                                color: API.textcolor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
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
                                  child: TextFormField(
                                    style: TextStyle(fontSize: API.appfontsize),
                                    controller: referrencecontroller,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: API.appcolor)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
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
                                      hintText: "Reference",
                                    ),
                                    onChanged: (val) async {},
                                  ),
                                ))),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 5, horizontal: 20),
                        //   child: Text(
                        //     "Reference",
                        //     style: TextStyle(
                        //         color: API.textcolor,
                        //         fontSize: 11,
                        //         fontWeight: FontWeight.w500),
                        //   ),
                        // ),
                        // SizedBox(
                        //     height: 50,
                        //     child: Padding(
                        //         padding: const EdgeInsets.only(
                        //           top: 5,
                        //           bottom: 0,
                        //           left: 20,
                        //           right: 20,
                        //         ),
                        //         child: SizedBox(
                        //           width: MediaQuery.of(context).size.width,
                        //           child: TextFormField(
                        //             style: TextStyle(fontSize: API.appfontsize),
                        //             controller: referrencecontroller,
                        //             textAlign: TextAlign.left,
                        //             keyboardType: TextInputType.text,
                        //             textInputAction: TextInputAction.next,
                        //             decoration: InputDecoration(
                        //               border: const OutlineInputBorder(),
                        //               focusedBorder: OutlineInputBorder(
                        //                   borderSide:
                        //                       BorderSide(color: API.appcolor)),
                        //               filled: true,
                        //               fillColor: Colors.white,
                        //               enabledBorder: OutlineInputBorder(
                        //                 borderRadius: BorderRadius.circular(5.0),
                        //                 borderSide: const BorderSide(
                        //                   width: 0.5,
                        //                 ),
                        //               ),
                        //               hintStyle: const TextStyle(
                        //                   fontFamily: 'Montserrat',
                        //                   color: Color.fromRGBO(181, 184, 203, 1),
                        //                   fontWeight: FontWeight.w300,
                        //                   fontSize: 11),
                        //               contentPadding: const EdgeInsets.fromLTRB(
                        //                   20.0, 10.0, 20.0, 10.0),
                        //               hintText: "Reference",
                        //             ),
                        //             onChanged: (val) async {},
                        //           ),
                        //         ))),
      
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20, right: 10, top: 10),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Choose Items",
                                  style: TextStyle(
                                      color: API.textcolor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        selecteditem.isNull
                            ? SizedBox(
                                height: 50,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 0,
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: SizedBox(
                                      child: TypeAheadField(
                                          hideSuggestionsOnKeyboardHide: false,
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            style: TextStyle(
                                                color: API.textcolor,
                                                fontWeight: FontWeight.bold),
                                            cursorColor: API.bordercolor,
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: API.appcolor)),
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                borderSide: const BorderSide(
                                                  width: 0.5,
                                                ),
                                              ),
                                              hintStyle: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color.fromRGBO(
                                                      181, 184, 203, 1),
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 11),
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      20.0, 10.0, 20.0, 10.0),
                                              hintText: "Inventory",
                                            ),
                                          ),
                                          suggestionsCallback: (value) async {
                                            return await API
                                                .getProductsListByWarehouseAPI(
                                                    value,
                                                    fromwarehouse["id"]
                                                        .toString(),
                                                    widget.token,
                                                    context);
                                          },
                                          itemBuilder: (context, products) {
                                            final listdata = products;
                                            return ListTile(
                                              dense: true,
                                              title: Text(
                                                listdata.description.toString(),
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
                                          onSuggestionSelected: (products) async {
                                            setState(() {
                                              selecteditem = products;
                                            });
                                            print(selecteditem);
                                          }),
                                    )),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: Container(
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: API.appcolor)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          width: 0.5,
                                        ),
                                      ),
                                      hintStyle: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color.fromRGBO(181, 184, 203, 1),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 11),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10.0, 10.0, 5.0, 10.0),
                                      hintText: "Inventory",
                                    ),
                                    child: SizedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${selecteditem!.partNumber.toString()} / ${selecteditem!.description}",
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      selecteditem = null;
                                                      quantitycontroller.text =
                                                          "";
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 18,
                                                  ))
                                            ],
                                          ),
                                          const Divider(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Available Qty",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                              Text(
                                                selecteditem!.availableQty
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Unit",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                            context: context,
                                                            isScrollControlled:
                                                                true,
                                                            isDismissible: false,
                                                            builder: (context) {
                                                              return StatefulBuilder(
                                                                  builder: (BuildContext
                                                                          context,
                                                                      StateSetter
                                                                          setSheetState) {
                                                                return SafeArea(
                                                                  child: Padding(
                                                                      padding: EdgeInsets.only(
                                                                          bottom: MediaQuery.of(
                                                                                  context)
                                                                              .viewInsets
                                                                              .bottom),
                                                                      child: sheetloading
                                                                          ? SizedBox(
                                                                              height:
                                                                                  MediaQuery.of(context).size.height / 5,
                                                                              width: MediaQuery.of(context)
                                                                                  .size
                                                                                  .width,
                                                                              child:
                                                                                  API.loadingScreen(context),
                                                                            )
                                                                          : SingleChildScrollView(
                                                                              child: Column(mainAxisSize: MainAxisSize.min, children: [
                                                                              SizedBox(
                                                                                height:
                                                                                    30,
                                                                                width:
                                                                                    MediaQuery.of(context).size.width,
                                                                                child:
                                                                                    Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      "Choose unit",
                                                                                      style: TextStyle(color: API.buttoncolor, fontSize: 14, fontWeight: FontWeight.w300),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              const Divider(
                                                                                height:
                                                                                    5,
                                                                                indent:
                                                                                    30,
                                                                                endIndent:
                                                                                    30,
                                                                              ),
                                                                              Wrap(
                                                                                children:
                                                                                    selecteditem!.arrUnits!.map<Widget>((e) {
                                                                                  return Column(
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: MediaQuery.of(context).size.width,
                                                                                        child: ListTile(
                                                                                          onTap: () async {
                                                                                            if (fromwarehouse.isEmpty) {
                                                                                              API.showSnackBar("failed", "Please select from warehouse", context);
                                                                                            } else {
                                                                                              setSheetState(() {
                                                                                                sheetloading = true;
                                                                                              });
                                                                                              final dynamic response = await API.getAvailableQuantityAPI(e.id.toString(), fromwarehouse["id"].toString(), selecteditem!.id.toString(), widget.token, context);
                                                                                              if (response["status"] == "success") {
                                                                                                selecteditem!.uomId = response["uom_id"].toString();
                                                                                                selecteditem!.uomUnitId = response["uom_unit_id"].toString();
                                                                                                selecteditem!.uomUnitName = response["uom_unit_name"].toString();
                                                                                                selecteditem!.uomUnitFactor = response["factor"].toString();
                                                                                                selecteditem!.availableQty = response["available_qty"].toString();
                                                                                              }
                                                                                              setSheetState(() {
                                                                                                sheetloading = false;
                                                                                              });
                                                                                              Navigator.pop(context);
                                                                                              setState(() {});
                                                                                            }
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
                                                                                              const SizedBox(
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
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      const Divider(
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
                                                      child: Container(
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                4,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromRGBO(
                                                              248, 248, 253, 1),
                                                          border: Border.all(
                                                            color:
                                                                API.bordercolor,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 5),
                                                                child: Text(
                                                                  selecteditem!
                                                                      .uomUnitName
                                                                      .toString(),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
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
                                                            )),
                                                            const Icon(
                                                              Icons
                                                                  .keyboard_arrow_down_outlined,
                                                              size: 23,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Qty",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                      height: 30,
                                                      child: TextFormField(
                                                        controller:
                                                            quantitycontroller,
                                                        keyboardType:
                                                            TextInputType.number,
                                                        cursorColor:
                                                            Colors.grey[400],
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 14,
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    const Color.fromRGBO(
                                                                        248,
                                                                        248,
                                                                        253,
                                                                        1),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0.0),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: API
                                                                        .bordercolor,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0.0),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .green,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                hintStyle: const TextStyle(
                                                                    color: Color.fromRGBO(
                                                                        181,
                                                                        184,
                                                                        203,
                                                                        1),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize: 11),
                                                                contentPadding:
                                                                    const EdgeInsets.fromLTRB(
                                                                        8.0,
                                                                        2.0,
                                                                        4.0,
                                                                        2.0),
                                                                hintText: "Qty",
                                                                border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(0.0))),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  if (quantitycontroller
                                                      .text.isEmpty) {
                                                    API.showSnackBar(
                                                        "failed",
                                                        "Qty should not be empty",
                                                        context);
                                                  } else {
                                                    if (num.parse(
                                                            quantitycontroller
                                                                .text) <=
                                                        num.parse(selecteditem!
                                                            .availableQty
                                                            .toString())) {
                                                      setState(() {
                                                        loading = true;
                                                      });
                                                      final bool checkresponse =
                                                          await checkProductAvailable(
                                                              itemslist,
                                                              selecteditem!.id
                                                                  .toString(),
                                                              selecteditem!.uomId
                                                                  .toString());
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      if (checkresponse) {
                                                        API.showSnackBar(
                                                            "failed",
                                                            "Item already in the list",
                                                            context);
                                                      } else {
                                                        setState(() {
                                                          itemslist.add({
                                                            "item_id":
                                                                selecteditem!.id
                                                                    .toString(),
                                                            "item_description":
                                                                selecteditem!
                                                                    .description
                                                                    .toString(),
                                                            "item_name":
                                                                selecteditem!
                                                                    .partNumber
                                                                    .toString(),
                                                            "transfer_qty":
                                                                quantitycontroller
                                                                    .text,
                                                            "unit": selecteditem!
                                                                .uomId
                                                                .toString(),
                                                            "unit_name":
                                                                selecteditem!
                                                                    .uomUnitName
                                                                    .toString()
                                                          });
                                                          selecteditem = null;
                                                          quantitycontroller
                                                              .text = "";
                                                        });
                                                      }
                                                    } else {
                                                      API.showSnackBar(
                                                          "failed",
                                                          "Qty should be less than or equal to available quantity",
                                                          context);
                                                    }
                                                  }
                                                },
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                      "",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4.5,
                                                      decoration: BoxDecoration(
                                                        color: API.appcolor,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                40),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Text(
                                                            "Add",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          FaIcon(
                                                            FontAwesomeIcons.add,
                                                            color: Colors.white,
                                                            size: 17,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        itemslist.isEmpty
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 10, top: 10),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Selected Items",
                                        style: TextStyle(
                                            color: API.textcolor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        Wrap(
                          children: itemslist.reversed.map<Widget>((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 3),
                              child: Container(
                                child: InputDecorator(
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
                                          width: 0.5, color: API.appcolor),
                                    ),
                                    hintStyle: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Color.fromRGBO(181, 184, 203, 1),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 11),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        10.0, 10.0, 5.0, 10.0),
                                    hintText: "Inventory",
                                  ),
                                  child: SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${e["item_name"].toString()} / ${e["item_description"].toString()}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        "Unit",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w400),
                                                      ),
                                                      Container(
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                4,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromRGBO(
                                                              248, 248, 253, 1),
                                                          border: Border.all(
                                                            color:
                                                                API.bordercolor,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 5),
                                                                child: Text(
                                                                  e["unit_name"]
                                                                      .toString(),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
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
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        "Qty",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w400),
                                                      ),
                                                      Container(
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                4,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromRGBO(
                                                              248, 248, 253, 1),
                                                          border: Border.all(
                                                            color:
                                                                API.bordercolor,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 5),
                                                                child: Text(
                                                                  e["transfer_qty"]
                                                                      .toString(),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
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
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        "",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w400),
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              itemslist.remove(e);
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                            size: 18,
                                                          )),
                                                    ]))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )),
      ),
    );
  }
}
