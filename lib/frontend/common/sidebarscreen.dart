// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshice/backend/api.dart';
import 'package:freshice/frontend/common/loginscreen.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBarScreen extends StatefulWidget {
  final Map<String, dynamic> userdetails;
  const SideBarScreen({super.key, required this.userdetails});

  @override
  State<SideBarScreen> createState() => _SideBarScreenState();
}

class _SideBarScreenState extends State<SideBarScreen> {
  bool syncing = false;

  static dynamic onAlertPopUp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Are you sure ?",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: API.textcolor,
                ),
              ),
              content: Container(
                height: 52,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      thickness: 1,
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "Please note that leaving the screen while syncing the data may result data loss.Can we proceed to sync your data?",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: API.textcolor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15)),
                      child: const Center(
                        child: Text(
                          "NO",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Container(
                        height: 30,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15)),
                        child: const Center(
                            child: Text("YES",
                                style: TextStyle(color: Colors.white)))))
              ],
            ));
  }

  Future<List<dynamic>> convertInventory(List<dynamic> details) async {
    List<dynamic> result = [];
    for (int i = 0; i < details.length; i++) {
      result.add({
        "product_id": details[i]["id"].toString(),
        "quantity": details[i]["available_qty"].toString(),
        "unit_id": details[i]["default_unit_id"].toString()
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: API.appcolor,
        body: SizedBox.expand(
            child: Container(
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    right: 10, left: 10, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(
                              backgroundColor: API.backgroundmaincolor,
                              child: ClipRRect(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Image.asset(
                                    "assets/images/avatar.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      // color: Colors.red,
                      height: MediaQuery.of(context).size.height / 12,
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Text(
                              widget.userdetails["name"].toString(),
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Text(
                            "Address".toString(),
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 15,
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                color: Colors.white,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 20,
                child: InkWell(
                  onTap: () async {
                    await API.getlaunchUrl(
                        Uri.parse("https://bluesky.ae/contactus.html"));
                  },
                  child: const ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    dense: true,
                    leading: Icon(
                      FontAwesomeIcons.info,
                      color: Colors.white,
                      size: 20,
                    ),
                    title: Text(
                      "Privacy Policy",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 20,
                child: InkWell(
                  onTap: () async {
                    await API.getlaunchUrl(Uri.parse(
                        "https://bluesky.ae/index.html#page-aboutus"));
                  },
                  child: const ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    dense: true,
                    leading: Icon(
                      FontAwesomeIcons.users,
                      color: Colors.white,
                      size: 20,
                    ),
                    title: Text(
                      "About Us",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              ),
               InkWell(
                      onTap: () async {
                          final shouldPop = await onAlertPopUp(context);
                          if (shouldPop == true) {
                          SharedPreferences poscache =
                                                await SharedPreferences
                                                    .getInstance();
                          await poscache.clear();
                          pushWidgetWhileRemove(
                                                newPage: const LoginScreen(),
                                                context: context);
                          
                        }
                      },
                      child: const ListTile(
                        dense: true,
                        leading: Icon(
                          FontAwesomeIcons.arrowAltCircleRight,
                          color: Colors.white,
                        ),
                        title: Text(
                          "LogOut",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                      ),
                    ),
              Container(
                height: MediaQuery.of(context).size.height / 6,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 40,
                                    width: 80,
                                    child: Image.asset(
                                        "assets/images/logo-b.png")),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Powered By",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w300,
                                            fontSize: 8,
                                            color: Colors.black),
                                      ),
                                      const Text(
                                        "Bluesky Technologies",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w300,
                                            fontSize: 8,
                                            color: Colors.black),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Text(
                                          "${API.updateddate}  ( ${API.buildversion} )",
                                          style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w300,
                                              fontSize: 8,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
