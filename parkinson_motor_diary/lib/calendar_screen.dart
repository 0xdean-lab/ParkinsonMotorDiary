import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'screen2.dart';

// 각 날짜에 대한 이벤트를 저장하는 데이터 구조를 정의합니다.
// 여기서는 간단히 int 타입으로 체크박스의 개수를 저장하고 있습니다.
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
    _selectedEvents = ValueNotifier([]);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<int> _getEventsForDay(DateTime day) {
    // 특정 날짜에 대한 체크박스 개수를 가져옵니다.
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    _selectedEvents.value = _getEventsForDay(selectedDay);
    // TODO: screen2 위젯으로 넘어가는 로직을 추가하세요.
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const Screen2()), // Screen2 위젯으로 교체하세요.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('캘린더'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          TableCalendar<int>(
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
              // 여기에서 날짜 표시 스타일을 커스터마이징 할 수 있습니다.
              markerDecoration: BoxDecoration(
                color: Colors.pink, // 체크박스 색상 지정
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
                // 요일 행의 스타일을 정의합니다.
                ),
            headerStyle: const HeaderStyle(
              // 캘린더의 헤더 부분 스타일을 정의합니다.
              titleTextStyle: TextStyle(color: Colors.blue),
              formatButtonVisible: false,
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 2'),
      ),
      body: const Center(
        child: Text('Screen 2 Content'),
      ),
    );
  }
}
