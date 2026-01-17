// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshice/backend/api.dart';
import 'package:freshice/frontend/reports/dayreportscreen.dart';
import 'package:freshice/frontend/reports/focreportscreen.dart';
import 'package:freshice/frontend/reports/productionreportscreen.dart';
import 'package:route_transitions/route_transitions.dart';

class ReportScreen extends StatefulWidget {
  final String productionreport;
  final String dayreport;
  final String token;
  const ReportScreen(
      {super.key,
      required this.productionreport,
      required this.dayreport,
      required this.token});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
          "Reports",
          style: TextStyle(
              color: API.buttoncolor,
              fontSize: 16,
              fontWeight: FontWeight.w300),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            widget.productionreport == "1"
                ? GestureDetector(
                    onTap: () async {
                      final connectivityResult =
                          await Connectivity().checkConnectivity();
                      if (connectivityResult == ConnectivityResult.none) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => API.alertboxScreen(context),
                        );
                      } else {
                        slideRightWidget(
                            newPage: ProductionReportScreen(
                              token: widget.token,
                            ),
                            context: context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 5,
                          semanticContainer: true,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: API.appcolor, width: 0.5),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 5,
                                height: MediaQuery.of(context).size.height / 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: FaIcon(
                                    FontAwesomeIcons.industry,
                                    color: API.appcolor,
                                  )),
                                ),
                              ),
                              const VerticalDivider(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Production Report",
                                    style: TextStyle(
                                      color: API.textcolor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    "Click to view",
                                    style: TextStyle(
                                        color: API.textcolor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            widget.dayreport == "1"
                ? GestureDetector(
                    onTap: () async {
                      slideRightWidget(
                          newPage: DayReportScreen(
                            token: widget.token,
                          ), context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 5,
                          semanticContainer: true,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: API.appcolor, width: 0.5),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 5,
                                height: MediaQuery.of(context).size.height / 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: FaIcon(
                                    FontAwesomeIcons.cubesStacked,
                                    color: API.appcolor,
                                  )),
                                ),
                              ),
                              const VerticalDivider(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Day Report",
                                    style: TextStyle(
                                      color: API.textcolor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    "Click to view",
                                    style: TextStyle(
                                        color: API.textcolor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),   widget.dayreport == "1"
                ? GestureDetector(
                    onTap: () async {
                      slideRightWidget(
                          newPage: FOCReportScreen(
                            token: widget.token,
                          ), context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 5,
                          semanticContainer: true,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: API.appcolor, width: 0.5),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 5,
                                height: MediaQuery.of(context).size.height / 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: FaIcon(
                                    FontAwesomeIcons.cubes,
                                    color: API.appcolor,
                                  )),
                                ),
                              ),
                              const VerticalDivider(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "FOC Report",
                                    style: TextStyle(
                                      color: API.textcolor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    "Click to view",
                                    style: TextStyle(
                                        color: API.textcolor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
