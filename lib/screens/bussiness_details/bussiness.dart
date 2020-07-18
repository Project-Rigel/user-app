import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rigel/screens/bussiness_details/select_date.dart';
import 'package:rigel/screens/screens.dart';
import 'package:rigel/screens/theme/light_colors.dart';
import 'package:rigel/services/services.dart';
import 'package:rigel/shared/category_list.dart';
import 'package:rigel/shared/loader.dart';
import 'package:rigel/shared/top_container.dart';

class BussinessScreen extends StatefulWidget {
  @override
  _BussinessScreenState createState() => _BussinessScreenState();
}

class _BussinessScreenState extends State<BussinessScreen> {
  final String bussinessId = "gpVwyDZEsgmVWyaBuwKx";

  @override
  void initState() {
    super.initState();
  }

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: Document<Bussiness>(path: 'bussiness/$bussinessId').getData(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (!snap.hasData || snap.hasError) {
            return LoadingScreen();
          } else {
            Bussiness bussiness = snap.data;
            return Scaffold(
              extendBody: true,
              floatingActionButton: GestureDetector(
                child: FloatingActionButton.extended(
                  label: Text('Reservar tu cita'),
                  icon: Icon(Icons.calendar_today),
                  backgroundColor: Theme.of(context).primaryColorLight,
                  foregroundColor: Colors.white,
                  tooltip: 'Reservar',
                  onPressed: () {
                    showBarModalBottomSheet(
                      context: context,
                      builder: (context, scrollController) => Container(
                          child: SelectDateModal(
                        title: "TEST",
                      )),
                    );
                  },
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              backgroundColor: Colors.white,
              body: SafeArea(
                top: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TopContainer(
                      height: MediaQuery.of(context).size.height / 4,
                      width: width,
                      padding: EdgeInsets.only(top: 30.00),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Hero(
                                  tag: 'backButton',
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        size: 25,
                                        color: LightColors.kDarkBlue,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ]),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      subheading(bussiness.name),
                                    ],
                                  ),
                                  SizedBox(height: 15.0),
                                  CategoryList(categories: bussiness.categories)
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
