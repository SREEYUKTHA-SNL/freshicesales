import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshice/backend/api.dart';
import 'dart:math' as math;


class CustomerScreen extends StatefulWidget {
  final String token;
  const CustomerScreen({super.key,
  required this.token
  });

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  TextEditingController searchcontroller = TextEditingController();

  List<dynamic> customers = [];

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
    final dynamic response = await API.getCustomersListAPI(searchcontroller.text, widget.token, context);
    if(response["status"]=="success"){
      setState(() {
        customers = response["data"];
        loading = false;
      });
    }else{
      setState(() {
        customers = [];
        loading = false;
      });
    }
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
          "Customers",
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
            : customers.isEmpty
                ? API.emptyWidget(context)
                : Column(
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
                          onChanged: (value) async {
                         await loadData(false);
                          },
                        ),
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: customers.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Card(
                                    elevation: 10,
                                    semanticContainer: true,
                                    child: ListTile(
                                      leading: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color((math.Random()
                                                            .nextDouble() *
                                                        0xFFFFFF)
                                                    .toInt())
                                                .withOpacity(0.5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              customers[index]
                                                  ["name"][0]
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          )),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              customers[index]
                                                ["name"]
                                                  .toString(),
                                              style: TextStyle(
                                                  color: API.textcolor,
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
                                                    2.8,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        "Phone",
                                                        style: TextStyle(
                                                            color:
                                                                API.textcolor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                    Text(
                                                      customers[index]
                                                          ["phone_no"]
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
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.8,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        "Address",
                                                        style: TextStyle(
                                                            color:
                                                                API.textcolor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                    Text(
                                                      customers[index]
                                                          ["address"]
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
                                          const Divider(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    "TRN",
                                                    style: TextStyle(
                                                        color: API.textcolor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                Text(
                                                  customers[index]
                                                      ["trn_no"]
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
                                    ),
                                  ),
                                );
                              }))
                    ],
                  ),
      ),
    );
  }
}
