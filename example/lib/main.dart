// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart' as cs
    show CalendarStyle, DaysOfWeekStyle;

void main() {
  initializeDateFormatting()
      .then((_) => runApp(const BookingCalendarDemoApp()));
}

class BookingCalendarDemoApp extends StatefulWidget {
  const BookingCalendarDemoApp({Key? key}) : super(key: key);

  @override
  State<BookingCalendarDemoApp> createState() => _BookingCalendarDemoAppState();
}

class _BookingCalendarDemoAppState extends State<BookingCalendarDemoApp> {
  final now = DateTime.now();
  late BookingService mockBookingService;

  @override
  void initState() {
    super.initState();
    // DateTime.now().startOfDay
    // DateTime.now().endOfDay
    mockBookingService = BookingService(
        serviceName: 'Mock Service',
        serviceDuration: 60,
        bookingEnd: DateTime(now.year, now.month, now.day, 13, 0),
        bookingStart: DateTime(now.year, now.month, now.day, 8, 0));
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    await Future.delayed(const Duration(seconds: 1));
    converted.add(DateTimeRange(
        start: newBooking.bookingStart, end: newBooking.bookingEnd));
    print('${newBooking.toJson()} has been uploaded');
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    ///take care this is only mock, so if you add today as disabledDays it will still be visible on the first load
    ///disabledDays will properly work with real data
    DateTime first = now;

    DateTime second = now.add(const Duration(minutes: 55));
    DateTime third = now.subtract(const Duration(minutes: 240));
    DateTime fourth = now.subtract(const Duration(minutes: 500));
    converted.add(
        DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
    converted.add(DateTimeRange(
        start: second, end: second.add(const Duration(minutes: 23))));
    converted.add(DateTimeRange(
        start: third, end: third.add(const Duration(minutes: 15))));
    converted.add(DateTimeRange(
        start: fourth, end: fourth.add(const Duration(minutes: 50))));

    return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
        start: DateTime(now.year, now.month, now.day, 12, 0)
            .add(const Duration(days: 1)),
        end: DateTime(now.year, now.month, now.day, 12, 30)
            .add(const Duration(days: 1)),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Booking Calendar Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Booking Calendar Demo'),
          ),
          body: Center(
            child: BookingCalendar(
              isVisibileformatButtonVisible: false,
              bookingService: mockBookingService,
              convertStreamResultToDateTimeRanges: convertStreamResultMock,
              getBookingStream: getBookingStreamMock,
              uploadBooking: uploadBookingMock,
              pauseSlots: generatePauseSlots(),
              pauseSlotText: 'LUNCH',
              hideBreakTime: false,
              loadingWidget: const Text('Fetching data...'),
              uploadingWidget: const CircularProgressIndicator(),
              locale: 'it_IT',
              startingDayOfWeek: StartingDayOfWeek.monday,
              bookingButtonColor: Colors.blue,
              buttonInActiveColor: Colors.blue.shade100,
              wholeDayIsBookedWidget:
                  const Text('Sorry, for this day everything is booked'),
              calendarStyle: const cs.CalendarStyle(
                isTodayHighlighted: false,
                weekendTextStyle: TextStyle(color: Colors.amber),
                selectedTextStyle: TextStyle(color: Colors.black),
                holidayDecoration: BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
                holidayTextStyle: TextStyle(
                  color: Colors.blue,
                ),
              ),
              daysOfWeekStyle: const cs.DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ));
  }
}
