// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:esc_pos_bluetooth_updated/esc_pos_bluetooth_updated.dart';
import 'package:esc_pos_utils_updated/esc_pos_utils_updated.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshice/backend/api.dart';
import 'package:freshice/frontend/sales/viewsalesitems.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:flutter_bluetooth_basic_updated/flutter_bluetooth_basic.dart'
    as bt;

class SalesListScreen extends StatefulWidget {
  final Map<String, dynamic> userdetails;
  final String token;
  const SalesListScreen(
      {super.key, required this.token, required this.userdetails});

  @override
  State<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  TextEditingController searchcontroller = TextEditingController();

  PrinterBluetoothManager printerManager = PrinterBluetoothManager();

  List<dynamic> saleslist = [];
  DateTime startdate = DateTime.now();
  DateTime enddate = DateTime.now();

  int rounding = 2;
  int selectedindex = -1;

  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await loadData(true);
    });
  }

  Future<void> loadData(bool type)async{
    if(type){
      setState(() {
        loading = true;
      });
    }
    final dynamic response = await API.getInvoicesListAPI("${startdate.year}-${startdate.month}-${startdate.day}", "${enddate.year}-${enddate.month}-${enddate.day}", searchcontroller.text, widget.token, context);
    if(response["status"]=="success"){
      setState(() {
        saleslist = response["data"];
        loading = false;
      });
    }else{
      setState(() {
        saleslist = [];
        loading = false;
      });
    }
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
            "Sales",
            style: TextStyle(
                color: API.buttoncolor,
                fontSize: 16,
                fontWeight: FontWeight.w300),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101));
                  if (picked != null) {
                    setState(() {
                      startdate = picked;
                      enddate = picked;
                    });
                    await loadData(true);
                  }
                },
                icon: Icon(
                  Icons.calendar_month,
                  color: API.appcolor,
                ))
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child:loading
                  ? API.loadingScreen(context)
                  : saleslist.isEmpty
              ? API.emptyWidget(context)
              :  Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: TextFormField(
                            style: TextStyle(fontSize: API.appfontsize),
                            controller: searchcontroller,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: API.appcolor)),
                              contentPadding: const EdgeInsets.all(10),
                              hintText: "Search",
                              labelText: "Search",
                              isDense: true,
                              prefixIcon: Icon(
                                Icons.search,
                                color: API.appcolor,
                              ),
                            ),
                            onChanged: (val) async {
                            await loadData(false);
                            },
                          ),
                        ),
                        Expanded(
                            child: Container(
                          child: ListView.builder(
                              itemCount: saleslist.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Card(
                                    elevation: 10,
                                    semanticContainer: true,
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    "Inv Id : ${saleslist[index]["invoice_no"].toString()}",
                                                    style: TextStyle(
                                                        color: API.textcolor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  slideRightWidget(
                                                      newPage: ViewSalesItems(
                                                        token: widget.token,
                                                          invoiceid:
                                                           saleslist[index]["id"].toString(),),
                                                      context: context);
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: SizedBox(
                                                    height: 25,
                                                    child: Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.teal,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  final Map<String, dynamic>
                                                      response =
                                                      await API
                                                          .getInvoicesDetailsByIDAPI(
                                                              saleslist[index]["id"].toString(),
                                                              widget.token,
                                                              context
                                                                );
                                                  if (response.isEmpty) {
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
                                                        printerManager.selectPrinter(
                                                            PrinterBluetooth(
                                                                bt.BluetoothDevice
                                                                    .fromJson({
                                                          "name":
                                                              printerdetailsresponse[
                                                                      "btname"]
                                                                  .toString(),
                                                          "address":
                                                              printerdetailsresponse[
                                                                      "btaddress"]
                                                                  .toString()
                                                        })));
                                                        const PaperSize paper =
                                                            PaperSize.mm80;
                                                        final profile =
                                                            await CapabilityProfile
                                                                .load(
                                                                    name:
                                                                        'default');
                                                        final PosPrintResult
                                                            printerresponse =
                                                            await printerManager
                                                                .printTicket(
                                                                    (await API
                                                                        .printWithDevice(
                                                          paper,
                                                          profile,
                                                          {
                                                            "company_name": widget
                                                                .userdetails[
                                                                    "companyname"]
                                                                .toString(),
                                                            "company_address": widget
                                                                .userdetails[
                                                                    "companyaddress"]
                                                                .toString(),
                                                            "company_phone": widget
                                                                .userdetails[
                                                                    "companyphone"]
                                                                .toString(),
                                                            "company_trn": widget
                                                                .userdetails[
                                                                    "companytrn"]
                                                                .toString(),
                                                            "invoice_no": response[
                                                                    "invoice_no"]
                                                                .toString(),
                                                            "invoice_date": response["invoice_created_date_time"].toString(),
                                                            "customer_name":
                                                                response[
                                                                        "customer_name"]
                                                                    .toString(),
                                                            "customer_trn_no":
                                                                response["customer_trn"]
                                                                    .toString(),
                                                            "salesman":
                                                                 response["sales_man"]
                                                                    .toString(),
                                                            "invoice_item_list":
                                                                response[
                                                                    "invoice_item_list"],
                                                            "total_amount": num.parse(response[
                                                                        "sub_total"]
                                                                    .toString())
                                                                .toStringAsFixed(
                                                                    2),
                                                            "tax_total": num.parse(response[
                                                                        "vat_amount"]
                                                                    .toString())
                                                                .toStringAsFixed(
                                                                    2),
                                                            "grand_total": num.parse(response[
                                                                        "grand_total"]
                                                                    .toString())
                                                                .toStringAsFixed(
                                                                    2),
                                                            "payment_type":response["payment_term_name"].toString()
                                                          },
                                                        )));
                                                        print(
                                                            "This is the printer response");
                                                        print(printerresponse
                                                            .msg);
                                                      } else {
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                        API.showSnackBar(
                                                            "failed",
                                                            printerdetailsresponse[
                                                                    "msg"]
                                                                .toString(),
                                                            context);
                                                      }
                                                  }
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: SizedBox(
                                                    height: 25,
                                                    child: Icon(
                                                      Icons.print,
                                                      color: Colors.teal,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                            saleslist[index]
                                                      ["customer_name"]
                                                      .toString(),
                                              style: TextStyle(
                                                  color: API.appcolor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          const Divider(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        "Amount",
                                                        style: TextStyle(
                                                            color:
                                                                API.textcolor,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ),
                                                    Text(
                                                      num.parse(saleslist[index]
                                                              ["sub_total"]
                                                              .toString())
                                                          .toStringAsFixed(
                                                              rounding),
                                                      style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4.5,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        "VAT",
                                                        style: TextStyle(
                                                            color:
                                                                API.textcolor,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ),
                                                    Text(
                                                      num.parse(saleslist[index]
                                                              ["vat_amount"]
                                                              .toString())
                                                          .toStringAsFixed(
                                                              rounding),
                                                      style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.5,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        "Total",
                                                        style: TextStyle(
                                                            color:
                                                                API.textcolor,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ),
                                                    Text(
                                                      num.parse(saleslist[index]
                                                              ["grand_total"]
                                                              .toString())
                                                          .toStringAsFixed(
                                                              rounding),
                                                      style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ))
                      ],
                    ),
        ));
  }
}
