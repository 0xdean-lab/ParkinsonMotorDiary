import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'screen2.dart';

// 각 날짜에 대한 이벤트를 저장하는 데이터 구조를 정의합니다.
// 여기서는 간단히 List<int> 타입으로 체크박스의 개수를 저장하고 있습니다.
final kEvents = LinkedHashMap<DateTime, List<int>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kToday.year, kToday.month, item % 31 + 1): [item % 5 + 1]
};

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

// 오늘 날짜를 기준으로 사용합니다.
final DateTime kToday = DateTime.now();
final DateTime kFirstDay = DateTime(kToday.year - 1, kToday.month, kToday.day);
final DateTime kLastDay = DateTime(kToday.year + 1, kToday.month, kToday.day);

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<int>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = kToday;
  DateTime _focusedDay = kToday;

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(_getEventsForDay(kToday));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<int> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents.value = _getEventsForDay(selectedDay);
    });

    // 여기에서 Screen2로 이동 시 선택된 날짜를 전달하는 방식~
    if (_selectedEvents.value.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Screen2(selectedDay: _selectedDay)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '파킨슨 일기',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xfff7eeee),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80.0),
            child: TableCalendar<int>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeSelectionMode: RangeSelectionMode.toggledOff,
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                    color: Color(0xfff7eeee), shape: BoxShape.rectangle),
                todayTextStyle: TextStyle(color: Colors.black),
                selectedDecoration: BoxDecoration(
                  color: Color(0xfff7eeee),
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(color: Colors.black),
                markerDecoration: BoxDecoration(
                  color: Color(0xfff98da1),
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                  // 요일 행의 스타일을 정의합니다.
                  ),
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(color: Colors.black),
                formatButtonVisible: false,
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: Colors.black),
              ),
            ),
          ),
          // 선택된 날짜의 이벤트 총합을 표시하는 UI 추가
          ValueListenableBuilder<List<int>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return Visibility(
                visible: value.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('일기 쓴 날 : 총 ${value.length} 일'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  final DateTime selectedDay;

  const Screen2({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xfff7eeee),
        title: Text(
          '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: const Center(
        child: Text('Screen 2 Content'),
      ),
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Example',
      theme: ThemeData(
        primaryColor: const Color(0xfff7eeee),
      ),
      home: const CalendarScreen(),
    );
  }
}
