import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../backend/api.dart';

class DayReportScreen extends StatefulWidget {
  final String token;
  const DayReportScreen({super.key,
  required this.token
  });

  @override
  State<DayReportScreen> createState() => _DayReportScreenState();
}

class _DayReportScreenState extends State<DayReportScreen> {
  TextEditingController filterdatecontroller = TextEditingController();

  DateTime filterdate = DateTime.now();

  bool loading = false;
  String pdfpath = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await loadData();
    });
  }

  Future<void> loadData()async{
    setState(() {
      loading = true;
    });
    final dynamic response = await API.getDailyReportPDF("${filterdate.year}-${filterdate.month}-${filterdate.day}",
    widget.token);
    print(response);
    setState(() {
      pdfpath = response['status'] == 'success'
        ? response['pdflink'].toString()
        : '';
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
          "Day Report",
          style: TextStyle(
              color: API.buttoncolor,
              fontSize: 16,
              fontWeight: FontWeight.w300),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: false,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: SingleChildScrollView(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    color: API.appcolor,
                                    child: const Center(
                                      child: Text(
                                        "Filter By Date",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    child: Text(
                                      "Filter Date",
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: TextFormField(
                                              style: TextStyle(
                                                  fontSize: API.appfontsize),
                                              readOnly: true,
                                              controller: filterdatecontroller,
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  builder: (context, child) {
                                                    return Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                       dialogBackgroundColor: API.appcolor,
                                                        colorScheme:
                                                            ColorScheme.light(
                                                                primary: API
                                                                    .appcolor,
                                                                onPrimary:
                                                                    Colors
                                                                        .white,
                                                                onSurface: API
                                                                    .appcolor,
                                                                onSurfaceVariant:
                                                                    Colors
                                                                        .white),
                                                        textButtonTheme:
                                                            TextButtonThemeData(
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                API.appcolor,
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
                                                    filterdate = pickedDate;
                                                    filterdatecontroller.text =
                                                        "${filterdate.day}/${filterdate.month}/${filterdate.year}";
                                                  });
                                                }
                                              },
                                              textAlign: TextAlign.left,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
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
                                                hintText: "Filter Date",
                                              ),
                                            ),
                                          ))),
                                  GestureDetector(
                                    onTap: () async {
                                      await loadData().then((value) {
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 20),
                                      child: Container(
                                        height: 45,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: API.appcolor,
                                          borderRadius:
                                              BorderRadius.circular(40),
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
                                ])));
                      });
                    });
              },
              icon: Icon(
                Icons.filter_alt,
                color: API.appcolor,
              ))
        ],
      ),
      body:  SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: loading
            ? API.loadingScreen(context)
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
