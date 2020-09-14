import 'package:flutter/material.dart';
import 'package:rigel/screens/bussiness_details/select_date.service.dart';
import 'package:rigel/shared/loader.dart';
import 'package:table_calendar/table_calendar.dart';

final Map<DateTime, List> _holidays = {
  DateTime(2020, 8, 26): ['Cerrado'],
  DateTime(2020, 8, 27): ['Cerrado'],
  DateTime(2020, 8, 28): ['Cerrado'],
  DateTime(2020, 8, 1): ['Vacaciones'],
};

class SelectDateModal extends StatefulWidget {
  SelectDateModal({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SelectDateModalState createState() => _SelectDateModalState();
}

class _SelectDateModalState extends State<SelectDateModal>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  List<String> openDays;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    testTimesMethod(_selectedDay);
    _events = {
      _selectedDay: [
        '09:00',
        '14:00',
        '16:00',
        '20:00',
      ],
      _selectedDay.subtract(Duration(days: 30)): [
        'Event A0',
        'Event B0',
        'Event C0'
      ],
      _selectedDay.subtract(Duration(days: 23)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): [
        'Event A2',
        'Event B2',
        'Event C2',
        'Event D2'
      ],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): [
        'Event A4',
        'Event B4',
        'Event C4'
      ],
      _selectedDay.subtract(Duration(days: 4)): [
        'Event A5',
        'Event B5',
        'Event C5'
      ],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay.add(Duration(days: 1)): [
        'Event A8',
        'Event B8',
        'Event C8',
        'Event D8'
      ],
      _selectedDay.add(Duration(days: 3)):
          Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): [
        'Event A10',
        'Event B10',
        'Event C10'
      ],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): [
        'Event A12',
        'Event B12',
        'Event C12',
        'Event D12'
      ],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): [
        'Event A14',
        'Event B14',
        'Event C14'
      ],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: testDaysMethod(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Switch out 2 lines below to play with TableCalendar's settings
                //-----------------------
                _buildTableCalendar(),
                // _buildTableCalendarWithBuilders(),
                const SizedBox(height: 8.0),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.all(15),
                  child: _buildEventList(),
                )),
              ],
            );
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      locale: 'es_Es',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Més',
        CalendarFormat.twoWeeks: '2 Semanas',
        CalendarFormat.week: 'Semana',
      },
      calendarStyle: CalendarStyle(
        selectedColor: Theme.of(context).primaryColorLight,
        todayColor: Theme.of(context).primaryColor,
        markersColor: Colors.transparent,
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.black),
        //holidayStyle: TextStyle(color: Colors.black)
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.black),
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    if (_selectedEvents.isNotEmpty) {
      return GridView.count(
        primary: false,
        childAspectRatio: 3.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: _selectedEvents
            .map((event) => FlatButton(
                  padding: EdgeInsets.all(10),
                  shape: new RoundedRectangleBorder(
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: Colors.white,
                  onPressed: () => print('$event tapped!'),
                  child: Expanded(
                    child: Text('$event', textAlign: TextAlign.center),
                  ),
                ))
            .toList(),
      );
    } else {
      return Text(
        "No hay nada disponible este día",
        style: TextStyle(fontWeight: FontWeight.w500),
      );
    }
  }
}
