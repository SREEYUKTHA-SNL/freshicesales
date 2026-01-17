import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshice/backend/api.dart';
import 'package:freshice/frontend/transfer/addtransfer.dart';
import 'package:freshice/frontend/transfer/transferpdf.dart';
import 'package:route_transitions/route_transitions.dart';

class TransferScreen extends StatefulWidget {
  final String token;
  const TransferScreen({super.key, required this.token});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  TextEditingController searchcontroller = TextEditingController();

  List<dynamic> transfers = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchData();
    });
    super.initState();
  }

  void fetchData() async {
    setState(() {
      loading = true;
    });
    final dynamic response = await API.getTransferListAPI(
        searchcontroller.text, widget.token, context);
    setState(() {
      transfers = response["status"] == "success" ? response["data"] : [];
      loading = false;
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
                Navigator.pop(context);
              },
              icon: FaIcon(
                FontAwesomeIcons.arrowLeft,
                color: API.buttoncolor,
                size: 20,
              )),
          centerTitle: true,
          title: Text(
            "Transfers",
            style: TextStyle(
                color: API.buttoncolor,
                fontSize: 16,
                fontWeight: FontWeight.w300),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                slideRightWidget(
                    newPage: AddTransfer(
                      token: widget.token,
                    ),
                    context: context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    color: API.appcolor,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Add",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      FaIcon(
                        FontAwesomeIcons.exchange,
                        color: Colors.white,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: loading
                ? API.loadingScreen(context)
                : Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: transfers.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    elevation: 10,
                                    semanticContainer: true,
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    "Transfer Id",
                                                    style: TextStyle(
                                                        color: API.textcolor,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                                Text(
                                                  transfers[index]["id"]
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.teal,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    "Transfer Date",
                                                    style: TextStyle(
                                                        color: API.textcolor,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                                Text(
                                                  transfers[index]
                                                          ["transfer_date"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: API.textcolor,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        "From WH",
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
                                                      transfers[index]
                                                              ["warehouseFrom"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        "To WH",
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
                                                      transfers[index]
                                                              ["warehouseTo"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: API.textcolor,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        "Reference",
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
                                                      transfers[index]
                                                              ["reference"]
                                                          .toString(),
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
                                      trailing: IconButton(
                                          onPressed: () {
                                            slideRightWidget(
                                                newPage: TransferPDF(
                                                    transferid: transfers[index]
                                                            ["id"]
                                                        .toString()),
                                                context: context);
                                          },
                                          icon: Icon(
                                            Icons.file_present_outlined,
                                            color: API.appcolor,
                                          )),
                                    ));
                              }))
                    ],
                  )));
  }
}
