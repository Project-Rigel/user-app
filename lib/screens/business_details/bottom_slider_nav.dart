import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rigel/screens/business_details/successDating.dart';
import 'package:rigel/services/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rigel/shared/commonBtn.dart';
import 'package:rigel/shared/shared.dart';
import 'select_date.dart';

class BottomSliderNav extends StatelessWidget {
  BottomSliderNav({Key key, this.business}) : super(key: key);
  final String bussinessId = "gpVwyDZEsgmVWyaBuwKx";
  final Bussiness business;
  var timeSelected = "";

  PageController _controller =
      new PageController(initialPage: 0, viewportFraction: 1.0);

  gotoDateSelection() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      1,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  gotoProductSelection(PageController controller) {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  goToSuccess(PageController controller) {
    controller.animateToPage(
      2,
      duration: Duration(milliseconds: 500),
      curve: Curves.elasticIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _controller,
            physics: new NeverScrollableScrollPhysics(),
            children: <Widget>[
              selectProductWidget(bussinessId),
              SelectDateModal(title: bussinessId, controller: _controller),
              SuccessDating(business: business)
            ],
            scrollDirection: Axis.horizontal,
          )),
    );
  }

  Widget selectProductWidget(String bussinessId) {
    return FutureBuilder(
      future: Firestore.instance
          .collection('business/gpVwyDZEsgmVWyaBuwKx/productos')
          .getDocuments(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData) {
          //List<Product> products = snap.data;
          return Scaffold(
              body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: Text("Selecciona un producto:",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2)),
                  )),
              SizedBox(height: 15.0),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: new ListView(
                    children: snap.data.documents
                        .map<Widget>((DocumentSnapshot document) {
                      return InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs
                                .setString('product', document.documentID)
                                .then((val) => gotoDateSelection());
                          },
                          child: CommonButton(text: document["name"]));
                    }).toList(),
                  ),
                ),
              ),
            ],
          ));
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
