import 'package:flutter/material.dart';
import 'package:rigel/screens/theme/light_colors.dart';

class CategoryList extends StatelessWidget {
  final List<String> categories;

  CategoryList({this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Categoría',
            style: TextStyle(
                color: LightColors.kGray,
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2),
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            //direction: Axis.vertical,
            alignment: WrapAlignment.start,
            verticalDirection: VerticalDirection.down,
            runSpacing: 0,
            //textDirection: TextDirection.rtl,
            spacing: 10.0,
            children: <Widget>[
              Chip(
                label: Text(categories[0]),
                backgroundColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(color: Colors.white),
              ),
              Chip(
                label: Text(categories[1]),
                backgroundColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(color: Colors.white),
              ),
              /*new ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new Chip(
                      label: Text(categories[index]),
                    );
                  })*/
            ],
          ),
        ],
      ),
    );
  }
}
