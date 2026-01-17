import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshice/backend/api.dart';

class InventoryList extends StatefulWidget {
  final String warehouseid;
  final String token;
  const InventoryList({super.key,
  required this.warehouseid,
  required this.token
  });

  @override
  State<InventoryList> createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  TextEditingController searchcontroller = TextEditingController();

  bool viewgrid = false;
  bool loading = false;

  List<dynamic> inventorylist = [];

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
    final dynamic response = await API.getInventoryListAPI(searchcontroller.text, widget.warehouseid, widget.token, context);
    if(response["status"]=="success"){
      setState(() {
        inventorylist = response["data"];
        loading = false;
      });
    }else{
      setState(() {
        inventorylist = [];
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
          "Inventory",
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
            : inventorylist.isEmpty
                ? API.emptyWidget(context)
                : Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
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
                                      borderSide:
                                          BorderSide(color: API.appcolor)),
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
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      viewgrid = !viewgrid;
                                    });
                                  },
                                  icon: Icon(
                                    !viewgrid
                                        ? Icons.grid_on_rounded
                                        : Icons.list,
                                    color: API.textcolor,
                                  )))
                        ],
                      ),
                      Expanded(
                          child: Container(
                              child: viewgrid
                                  ? GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 8.8 / 10,
                                              mainAxisSpacing: 0.0,
                                              crossAxisSpacing: 0.0),
                                      itemCount: inventorylist.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          children: [
                                            Card(
                                              elevation: 6,
                                              semanticContainer: true,
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                      child: Stack(
                                                    children: [
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Image.asset(
                                                                'assets/images/noimage.jpg'),
                                                          )),
                                                    ],
                                                  )),
                                                  SizedBox(
                                                    height: 80,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        3),
                                                                child: Text(
                                                                  inventorylist[
                                                                          index]
                                                                      ["part_number"]
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        3),
                                                                child: Text(
                                                                  inventorylist[
                                                                          index]
                                                                    ["description"]
                                                                      .toString(),
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        0),
                                                                child: Text(
                                                                  "Price : ${num.parse(inventorylist[index]["sec_selling_price"].toString()).toStringAsFixed(2)}",
                                                                  style: TextStyle(
                                                                      color: API
                                                                          .appcolor,
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 60,
                                                          height: 50,
                                                          // color: Colors.red,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        5),
                                                                child: Text(
                                                                  "Avl Qty",
                                                                  style: TextStyle(
                                                                      color: API
                                                                          .textcolor,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                              ),
                                                              Text(
                                                                "${num.parse(inventorylist[index]
                                                                            ["sec_available_qty"].toString())
                                                                        .toStringAsFixed(
                                                                            1)} ${inventorylist[
                                                                            index]["sec_unit_name"]}"
                                                                   ,
                                                                style: TextStyle(
                                                                    color: API
                                                                        .textcolor,
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      })
                                  : ListView.builder(
                                      itemCount: inventorylist.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  8,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
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
                                                              10,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Image.asset(
                                                            'assets/images/noimage.jpg'),
                                                      ),
                                                    ),
                                                    const VerticalDivider(
                                                      thickness: 1,
                                                    ),
                                                    Expanded(
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
                                                                    child:
                                                                        Padding(
                                                                        padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              8,
                                                                          vertical:
                                                                              0),
                                                                        child:
                                                                          Text(
                                                                        inventorylist[index]["part_number"].toString(),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
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
                                                                  const SizedBox(
                                                                      child:
                                                                          VerticalDivider()),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width /
                                                                        4,
                                                                    child: Text(
                                                                      "Price : ${double.parse(inventorylist[index]["sec_selling_price"].toString()).toStringAsFixed(2)}",
                                                                      style: TextStyle(
                                                                          color: API
                                                                              .appcolor,
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.w500),
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
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          2),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          30,
                                                                      child:
                                                                          Text(
                                                                        inventorylist[index]
                                                                            ["description"]
                                                                            .toString(),
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w300),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                    SizedBox(
                                                      width: 60,
                                                      height: 50,
                                                      // color: Colors.red,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        5),
                                                            child: Text(
                                                              "Avl Qty",
                                                              style: TextStyle(
                                                                  color: API
                                                                      .textcolor,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                            ),
                                                          ),
                                                          Text(
                                                            "${num.parse(inventorylist[
                                                                            index]
                                                                      ["sec_available_qty"].toString())
                                                                    .toStringAsFixed(
                                                                        1)} ${inventorylist[
                                                                        index]
                                                                    ["sec_unit_name"].toString()}",
                                                            style: TextStyle(
                                                                color: API
                                                                    .textcolor,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    )))
                    ],
                  ),
      ),
    );
  }
}
