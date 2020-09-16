import 'package:i18n_extension/i18n_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rigel/screens/theme/light_colors.dart';
import 'package:rigel/services/services.dart';
import 'package:rigel/shared/category_list.dart';
import 'package:rigel/shared/loader.dart';
import 'package:rigel/screens/business_details/top_container.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'bottom_slider_nav.dart';

class BussinessScreen extends StatefulWidget {
  @override
  _BussinessScreenState createState() => _BussinessScreenState();
}

class _BussinessScreenState extends State<BussinessScreen> {
  final String bussinessId = "gQc7A7w1GIATEz4vo65T";

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
        future: Document<Bussiness>(path: 'business/$bussinessId').getData(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (!snap.hasData || snap.hasError) {
            return LoadingScreen();
          } else {
            Bussiness bussiness = snap.data;
            initializeDateFormatting("es_Es");
            return I18n(
              initialLocale: Locale("es", "ES"),
              child: Scaffold(
                extendBody: true,
                floatingActionButton: GestureDetector(
                  child: FloatingActionButton.extended(
                    label: Text('Reservar tu cita'),
                    icon: Icon(Icons.calendar_today),
                    backgroundColor: Theme.of(context).primaryColorLight,
                    foregroundColor: Colors.white,
                    tooltip: 'Reservar',
                    onPressed: () async {
                      showBarModalBottomSheet(
                        context: context,
                        builder: (context, scrollController) =>
                            Container(child: BottomSliderNav()),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    CategoryList(
                                        categories: bussiness.categories),
                                    SizedBox(height: 10.0),
                                    Center(
                                      child: Text(bussiness.description),
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Expanded(
                                          child: FlatButton.icon(
                                            padding: EdgeInsets.all(10),
                                            shape: new RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0)),
                                            icon: Icon(FontAwesomeIcons.phone,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            color: Colors.white,
                                            onPressed: () async {
                                              String _phone = bussiness.phone;
                                              _makePhoneCall('tel:$_phone');
                                            },
                                            label: Expanded(
                                              child: Text(bussiness.phone,
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.0),
                                        Expanded(
                                          child: FlatButton.icon(
                                            padding: EdgeInsets.all(10),
                                            shape: new RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0)),
                                            icon: Icon(
                                                FontAwesomeIcons.mailBulk,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            color: Colors.white,
                                            onPressed: () async {
                                              final Uri _emailLaunchUri = Uri(
                                                  scheme: 'mailto',
                                                  path: bussiness.mail,
                                                  queryParameters: {
                                                    'subject':
                                                        'Green&In: Consulta'
                                                  });

                                              launch(
                                                  _emailLaunchUri.toString());
                                            },
                                            label: Expanded(
                                              child: Text(bussiness.mail,
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
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
              ),
            );
          }
        });
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
