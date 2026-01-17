// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshice/backend/api.dart';
import 'package:freshice/backend/bluetoothscannerpage.dart';
import 'package:freshice/frontend/common/loginscreen.dart';
import 'package:freshice/frontend/common/settingsscreen.dart';
import 'package:freshice/frontend/common/successpage.dart';
import 'package:freshice/frontend/production/addproduction.dart';
import 'package:freshice/frontend/sales/addsalesscreen.dart';
import 'package:freshice/frontend/inventory/currentstock.dart';
import 'package:freshice/frontend/customers/customersscreen.dart';
import 'package:freshice/frontend/inventory/inventoryscreen.dart';
import 'package:freshice/frontend/reports/reportscreen.dart';
import 'package:freshice/frontend/sales/saleslistscreen.dart';
import 'package:freshice/frontend/transfer/transfers.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userdetails;
  final zoomdrawerdontroller;
  const HomeScreen(
      {super.key,
      required this.userdetails,
      required this.zoomdrawerdontroller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String,dynamic> userdetails = {};
  List<ChartData> dashboarddetails = [];

  Future<List<ChartData>> convertToChartData(List<dynamic> details) async {
    List<ChartData> result = [];
    for (int i = 0; i < details.length; i++) {
      result.add(ChartData(details[i]["day"].toString(),
          double.parse(details[i]["net_sales"].toString())));
    }
    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        loading = true;
      });
      final dynamic userresponse = await API.getUserDetails();
      print("This is the user details");
      print(userresponse);
      if(userresponse["status"]=="success"){
         final dynamic response = await API.getDashboardDetailsAPI( userresponse["status"]=="success"? userresponse["token"]:"", context);
      final dynamic chartresponse = await convertToChartData(response["status"]=="success"?response["data"]:[]);
    setState(() {
      userdetails = userresponse;
      dashboarddetails = chartresponse;
      loading = false;
    });
      }else{
        API.showSnackBar("failed", "Cache missed.Please login once again", context);
          SharedPreferences poscache =
                                                await SharedPreferences
                                                    .getInstance();
                          await poscache.clear();
                          pushWidgetWhileRemove(
                                                newPage: const LoginScreen(),
                                                context: context);
      }
 
                                                      });
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              widget.zoomdrawerdontroller.toggle();
            },
            icon: FaIcon(
              FontAwesomeIcons.barsStaggered,
              color: API.buttoncolor,
              size: 20,
            )),
        centerTitle: true,
        title: GestureDetector(
          onTap: () {},
          child: Text(
            "Fresh Ice Factory",
            style: TextStyle(
                color: API.buttoncolor,
                fontSize: 16,
                fontWeight: FontWeight.w300),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                slideRightWidget(
                    newPage: const BluetoothScannerPage(), context: context);
              },
              icon: Icon(
                Icons.print_rounded,
                color: API.appcolor,
              )),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
                width: 50,
                height: 50,
                child: Image.asset("assets/images/freshice.png")),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: loading
            ? API.loadingScreen(context)
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Container(
                                          height: 20,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 30),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Weekly Sales",
                                                  style: TextStyle(
                                                      color: API.buttoncolor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        child: Container(
                                          height:  MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.3,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: SfCartesianChart(
                                                      primaryXAxis:
                                                          CategoryAxis(),
                                                      primaryYAxis: NumericAxis(
                                                          minimum: 0,
                                                          maximum: 40,
                                                          interval: 10),
                                                      tooltipBehavior:
                                                          TooltipBehavior(
                                                              enable: true),
                                                      series: <
                                                          CartesianSeries<
                                                              ChartData,
                                                              String>>[
                                                    BarSeries<ChartData,
                                                            String>(
                                                        dataSource:
                                                            dashboarddetails,
                                                        xValueMapper:
                                                            (ChartData data,
                                                                    _) =>
                                                                data.x,
                                                        yValueMapper:
                                                            (ChartData data,
                                                                    _) =>
                                                                data.y,
                                                        name: 'Sales',
                                                        color: API.appcolor)
                                                  ])),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  )
                          ,
                  
                  
                    Container(
                      // height: MediaQuery.of(context).size.height / 2.28,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: API.appcolor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                               bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                children: [
                                  widget.userdetails["app_direct_sale"]
                                              .toString() ==
                                          "1"
                                      ? GestureDetector(
                                          onTap: () {
                                            slideRightWidget(
                                                newPage: AddSalesScreen(
                                    token: widget
                                                      .userdetails["token"]
                                                      .toString(),
                                                         warehouseid: widget
                                                      .userdetails[
                                                          "warehouse_id"]
                                                      .toString(),
                                                  userid: widget
                                                      .userdetails["userid"]
                                                      .toString(),
                                                  userdetails:
                                                      widget.userdetails,
                                                ),
                                                context: context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10,
                                            child: Card(
                                              elevation: 10,
                                              semanticContainer: true,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .fileCirclePlus,
                                                      color: API.appcolor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: Text(
                                                      "Direct Sale",
                                                      style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20),
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .angleRight,
                                                      color: API.appcolor,
                                                      size: 25,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget.userdetails["app_sales"].toString() ==
                                          "1"
                                      ? GestureDetector(
                                          onTap: () {
                                            slideRightWidget(
                                                newPage: SalesListScreen(
                                                  token: widget
                                                      .userdetails["token"]
                                                      .toString(),
                                                  userdetails:
                                                      widget.userdetails,
                                                ),
                                                context: context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10,
                                            child: Card(
                                              elevation: 10,
                                              semanticContainer: true,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .fileCircleCheck,
                                                      color: API.appcolor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: Text(
                                                      "Sales",
                                                      style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget.userdetails["app_production"]
                                              .toString() ==
                                          "1"
                                      ? GestureDetector(
                                          onTap: () async {
                                            final connectivityResult =
                                                await Connectivity()
                                                    .checkConnectivity();
                                            if (connectivityResult ==
                                                ConnectivityResult.none) {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (_) =>
                                                    API.alertboxScreen(context),
                                              );
                                            } else {
                                              slideRightWidget(
                                                  newPage: AddProductionScreen(
                                                    token: widget
                                                        .userdetails["token"]
                                                        .toString(),
                                                  ),
                                                  context: context);
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10,
                                            child: Card(
                                              elevation: 10,
                                              semanticContainer: true,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: FaIcon(
                                                      FontAwesomeIcons.industry,
                                                      color: API.appcolor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: Text(
                                                      "Production",
                                                      style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget.userdetails["app_transfer"]
                                              .toString() ==
                                          "1"
                                      ? GestureDetector(
                                          onTap: () async {
                                            final connectivityResult =
                                                await Connectivity()
                                                    .checkConnectivity();
                                            if (connectivityResult ==
                                                ConnectivityResult.none) {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (_) =>
                                                    API.alertboxScreen(context),
                                              );
                                            } else {
                                              slideRightWidget(
                                                  newPage: TransferScreen(
                                                    token: widget
                                                        .userdetails["token"]
                                                        .toString(),
                                                  ),
                                                  context: context);
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10,
                                            child: Card(
                                              elevation: 10,
                                              semanticContainer: true,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: FaIcon(
                                                      FontAwesomeIcons.exchange,
                                                      color: API.appcolor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: Text(
                                                      "Transfers",
                                                      style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget.userdetails["app_customers"]
                                              .toString() ==
                                          "1"
                                      ? GestureDetector(
                                          onTap: () {
                                            slideRightWidget(
                                                newPage:  CustomerScreen(
                                                    token: widget
                                                        .userdetails["token"]
                                                        .toString(),
                                                ),
                                                context: context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10,
                                            child: Card(
                                              elevation: 10,
                                              semanticContainer: true,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .userGroup,
                                                      color: API.appcolor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: Text(
                                                      "Customers",
                                                      style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget.userdetails["app_inventory"]
                                              .toString() ==
                                          "1"
                                      ? GestureDetector(
                                          onTap: () {
                                            slideRightWidget(
                                                newPage:  InventoryList(
                                                   token: widget
                                                        .userdetails["token"]
                                                        .toString(),
                                                   warehouseid: widget
                                                      .userdetails[
                                                          "warehouse_id"]
                                                      .toString(),
                                                ),
                                                context: context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10,
                                            child: Card(
                                              elevation: 10,
                                              semanticContainer: true,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: FaIcon(
                                                      FontAwesomeIcons.cubes,
                                                      color: API.appcolor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: Text(
                                                      "Inventory",
                                                      style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget.userdetails["app_store"].toString() ==
                                          "1"
                                      ? GestureDetector(
                                          onTap: () {
                                            slideRightWidget(
                                                newPage: CurrentStock(
                                                  token: widget
                                                      .userdetails["token"]
                                                      .toString(),
                                                  defaultwarehouseid: widget
                                                      .userdetails[
                                                          "default_warehouse_id"]
                                                      .toString(),
                                                  defaultwarehousename: widget
                                                      .userdetails[
                                                          "default_warehouse_name"]
                                                      .toString(),
                                                ),
                                                context: context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10,
                                            child: Card(
                                              elevation: 10,
                                              semanticContainer: true,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: FaIcon(
                                                      FontAwesomeIcons.cubes,
                                                      color: API.appcolor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: Text(
                                                      "Current Stock",
                                                      style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  GestureDetector(
                                    onTap: () async {
                                      slideRightWidget(
                                          newPage: ReportScreen(
                                            dayreport: widget
                                                .userdetails["app_sales"]
                                                .toString(),
                                            productionreport: widget
                                                .userdetails["app_production"]
                                                .toString(),
                                            token: widget.userdetails["token"]
                                                .toString(),
                                          ),
                                          context: context);
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.2,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      child: Card(
                                        elevation: 10,
                                        semanticContainer: true,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: FaIcon(
                                                FontAwesomeIcons.pieChart,
                                                color: API.appcolor,
                                              ),
                                            ),
                                            Expanded(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                "Reports",
                                                style: TextStyle(
                                                    color: API.textcolor,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),                          
                                  widget.userdetails["app_device_settings"]
                                              .toString() ==
                                          "1"
                                      ? GestureDetector(
                                          onTap: () async {
                                            final connectivityResult =
                                                await Connectivity()
                                                    .checkConnectivity();
                                            if (connectivityResult ==
                                                ConnectivityResult.none) {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (_) =>
                                                    API.alertboxScreen(context),
                                              );
                                            } else {
                                              slideRightWidget(
                                                  newPage: SettingsScreen(
                                                    token: widget
                                                        .userdetails["token"]
                                                        .toString(),
                                                  ),
                                                  context: context);
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10,
                                            child: Card(
                                              elevation: 10,
                                              semanticContainer: true,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: FaIcon(
                                                      FontAwesomeIcons.gears,
                                                      color: API.appcolor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: Text(
                                                      "Settings",
                                                      style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                         
                              const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}
