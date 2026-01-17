import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshice/backend/api.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TransferPDF extends StatefulWidget {
  final String transferid;
  const TransferPDF({
    super.key,
    required this.transferid,
  });

  @override
  State<TransferPDF> createState() => _TransferPDFState();
}

class _TransferPDFState extends State<TransferPDF> {
  bool loading = false;
  String pdfpath = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        loading = true;
      });
      final dynamic response = await API.getTransferPDF(widget.transferid);
      print(response);
      setState(() {
        pdfpath = response['status'] == 'success'
            ? response['pdflink'].toString()
            : '';
        loading = false;
      });
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
          "Transfer PDF",
          style: TextStyle(
              color: API.buttoncolor,
              fontSize: 16,
              fontWeight: FontWeight.w300),
        ),
      ),
      body: SizedBox(
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
