import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshice/backend/api.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ProductionReportScreen extends StatefulWidget {
  final String token;
  const ProductionReportScreen({super.key, required this.token});

  @override
  State<ProductionReportScreen> createState() => _ProductionReportScreenState();
}

class _ProductionReportScreenState extends State<ProductionReportScreen> {
  TextEditingController fromdatecontroller = TextEditingController();
  TextEditingController enddatecontroller = TextEditingController();

  DateTime? fromdate;
  DateTime? enddate;

  Map<String, dynamic> selectedtype = {};

  String pdfpath = '';
  bool loading = false;

  Future<void> loadFetch() async {
    setState(() {
      loading = true;
    });
    final dynamic response = await API.getPrintItemWiseGoodReceiptReportPDF(
        fromdatecontroller.text,
        enddatecontroller.text,
        selectedtype.isEmpty ? "" : selectedtype["code"].toString(),
        widget.token);
    print(response);
    setState(() {
      pdfpath =
          response['status'] == 'success' ? response['pdflink'].toString() : '';
      loading = false;
    });
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
          "Production Report",
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
        child: loading
            ? API.loadingScreen(context)
            : pdfpath.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: Text(
                          "From Date",
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
                                  readOnly: true,
                                  controller: fromdatecontroller,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            dialogBackgroundColor: API.appcolor,
                                            colorScheme: ColorScheme.light(
                                                primary: API.appcolor,
                                                onPrimary: Colors.white,
                                                onSurface: API.appcolor,
                                                onSurfaceVariant: Colors.white),
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor: API.appcolor,
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime(2100),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        fromdate = pickedDate;
                                        fromdatecontroller.text =
                                            "${fromdate!.day}/${fromdate!.month}/${fromdate!.year}";
                                        enddate = null;
                                        enddatecontroller.text = "";
                                      });
                                    }
                                  },
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
                                    hintText: "From Date",
                                  ),
                                ),
                              ))),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: Text(
                          "To Date",
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
                                  readOnly: true,
                                  controller: enddatecontroller,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            dialogBackgroundColor: API.appcolor,
                                            colorScheme: ColorScheme.light(
                                                primary: API.appcolor,
                                                onPrimary: Colors.white,
                                                onSurface: API.appcolor,
                                                onSurfaceVariant: Colors.white),
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor: API.appcolor,
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2100),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        enddate = pickedDate;
                                        enddatecontroller.text =
                                            "${enddate!.day}/${enddate!.month}/${enddate!.year}";
                                      });
                                    }
                                  },
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
                                    hintText: "End Date",
                                  ),
                                ),
                              ))),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 5, horizontal: 20),
                      //   child: Text(
                      //     "Type",
                      //     style: TextStyle(
                      //         color: API.textcolor,
                      //         fontSize: 11,
                      //         fontWeight: FontWeight.w500),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 50,
                      //   child: Padding(
                      //       padding: const EdgeInsets.only(
                      //         top: 5,
                      //         bottom: 0,
                      //         left: 20,
                      //         right: 20,
                      //       ),
                      //       child: SizedBox(
                      //         width: MediaQuery.of(context).size.width,
                      //         child: selectedtype.isNotEmpty
                      //             ? GestureDetector(
                      //                 onTap: () {
                      //                   setState(() {
                      //                     selectedtype = {};
                      //                   });
                      //                 },
                      //                 child: SizedBox(
                      //                   height: 58,
                      //                   child: InputDecorator(
                      //                     decoration: InputDecoration(
                      //                         filled: true,
                      //                         fillColor: Colors.white,
                      //                         enabledBorder: OutlineInputBorder(
                      //                           borderRadius:
                      //                               BorderRadius.circular(5.0),
                      //                           borderSide: const BorderSide(
                      //                             width: 0.5,
                      //                           ),
                      //                         ),
                      //                         focusedBorder: OutlineInputBorder(
                      //                           borderRadius:
                      //                               BorderRadius.circular(5.0),
                      //                           borderSide: const BorderSide(
                      //                             color: Colors.green,
                      //                             width: 0.5,
                      //                           ),
                      //                         ),
                      //                         hintStyle: const TextStyle(
                      //                             fontFamily: 'Montserrat',
                      //                             color: Color.fromRGBO(
                      //                                 181, 184, 203, 1),
                      //                             fontWeight: FontWeight.w300,
                      //                             fontSize: 11),
                      //                         contentPadding:
                      //                             const EdgeInsets.fromLTRB(
                      //                                 20.0, 5.0, 20.0, 5.0),
                      //                         hintText: "Type",
                      //                         border: OutlineInputBorder(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(
                      //                                     8.0))),
                      //                     child: Container(
                      //                       width: MediaQuery.of(context)
                      //                           .size
                      //                           .width,
                      //                       decoration: const BoxDecoration(
                      //                         color: Colors.white,
                      //                       ),
                      //                       child: Row(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment
                      //                                 .spaceBetween,
                      //                         children: [
                      //                           SizedBox(
                      //                             width: MediaQuery.of(context)
                      //                                     .size
                      //                                     .width /
                      //                                 1.6,
                      //                             child: Text(
                      //                               "${selectedtype["description"]}",
                      //                               style: TextStyle(
                      //                                 color: API.textcolor,
                      //                                 fontSize: 14,
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           Icon(
                      //                             Icons.delete,
                      //                             color: Colors.grey[400],
                      //                             size: 18,
                      //                           )
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               )
                      //             : SizedBox(
                      //                 child: TypeAheadField(
                      //                     hideSuggestionsOnKeyboardHide: false,
                      //                     textFieldConfiguration:
                      //                         TextFieldConfiguration(
                      //                       style: TextStyle(
                      //                           color: API.textcolor,
                      //                           fontWeight: FontWeight.bold),
                      //                       cursorColor: API.bordercolor,
                      //                       decoration: InputDecoration(
                      //                         border:
                      //                             const OutlineInputBorder(),
                      //                         focusedBorder: OutlineInputBorder(
                      //                             borderSide: BorderSide(
                      //                                 color: API.appcolor)),
                      //                         filled: true,
                      //                         fillColor: Colors.white,
                      //                         enabledBorder: OutlineInputBorder(
                      //                           borderRadius:
                      //                               BorderRadius.circular(5.0),
                      //                           borderSide: const BorderSide(
                      //                             width: 0.5,
                      //                           ),
                      //                         ),
                      //                         hintStyle: const TextStyle(
                      //                             fontFamily: 'Montserrat',
                      //                             color: Color.fromRGBO(
                      //                                 181, 184, 203, 1),
                      //                             fontWeight: FontWeight.w300,
                      //                             fontSize: 11),
                      //                         contentPadding:
                      //                             const EdgeInsets.fromLTRB(
                      //                                 20.0, 10.0, 20.0, 10.0),
                      //                         hintText: "From Warehouse",
                      //                       ),
                      //                     ),
                      //                     suggestionsCallback: (value) async {
                      //                       return await API.postTypeListAPI(
                      //                           widget.token,
                      //                           "RECEIPT",
                      //                           context);
                      //                     },
                      //                     itemBuilder:
                      //                         (context, TypeModel? typelist) {
                      //                       final listdata = typelist;
                      //                       return ListTile(
                      //                         dense: true,
                      //                         title: Text(
                      //                           listdata!.description
                      //                               .toString(),
                      //                           overflow: TextOverflow.ellipsis,
                      //                           softWrap: false,
                      //                           maxLines: 1,
                      //                           style: TextStyle(
                      //                               color: API.textcolor,
                      //                               fontSize: 14,
                      //                               fontWeight:
                      //                                   FontWeight.w400),
                      //                         ),
                      //                       );
                      //                     },
                      //                     onSuggestionSelected:
                      //                         (TypeModel? typelist) async {
                      //                       final data = {
                      //                         "id": typelist!.id,
                      //                         "code": typelist.code,
                      //                         "description":
                      //                             typelist.description
                      //                       };
                      //                       setState(() {
                      //                         selectedtype = data;
                      //                       });
                      //                       print(selectedtype);
                      //                     }),
                      //               ),
                      //       )),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await loadFetch();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 20),
                          child: Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: API.appcolor,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Center(
                              child: Text(
                                "Load Report",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: SfPdfViewerTheme(
                                data: SfPdfViewerThemeData(
                                    backgroundColor: Colors.white,
                                    progressBarColor: Colors.green),
                                child: SfPdfViewer.network(
                                  "${API.fileurl}/$pdfpath",
                                  initialZoomLevel: 1,
                                ))),
                      ),
                      GestureDetector(
                        onTap: () {
                          Share.share("${API.fileurl}/$pdfpath");
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: MediaQuery.of(context).size.height / 13,
                          child: Card(
                            elevation: 10,
                            semanticContainer: true,
                            surfaceTintColor: Colors.white,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: API.appcolor,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Image.asset("assets/images/share.png"),
                                ),
                                Text(
                                  "Share PDF",
                                  style: TextStyle(
                                      color: API.textcolor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
