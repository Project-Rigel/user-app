import 'package:flutter/material.dart';
import 'package:rigel/services/db.dart';
import 'package:rigel/services/globals.dart';
import 'package:rigel/services/models.dart';
import 'select_date.dart';

class BottomSliderNav extends StatelessWidget {
  BottomSliderNav({Key key}) : super(key: key);

  PageController _controller =
      new PageController(initialPage: 0, viewportFraction: 1.0);

  gotoDateSelection() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoProductSelection() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      1,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _controller,
            physics: new AlwaysScrollableScrollPhysics(),
            children: <Widget>[selectProductWidget(), SelectDateModal()],
            scrollDirection: Axis.horizontal,
          )),
    );
  }

  Widget selectProductWidget(String bussinessId) {
    return FutureBuilder(
      future: Collection<Product>(path: 'bussiness/$bussinessId/productos')
          .getData(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData) {
          List<Product> products = snap.data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: Text('Topics'),
              actions: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.userCircle,
                      color: Colors.pink[200]),
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                )
              ],
            ),
            drawer: TopicDrawer(topics: snap.data),
            body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: topics.map((topic) => TopicItem(topic: topic)).toList(),
            ),
            bottomNavigationBar: AppBottomNav(),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
