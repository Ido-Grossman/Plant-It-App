import 'dart:async';
import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart' as tz;

class CalendarHelper {
  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  Future<bool> requestPermissions() async {
    final permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
    return permissionsGranted.data ?? false;
  }

  Future<List<Calendar>> retrieveCalendars() async {
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    return calendarsResult.data ?? [];
  }

  Future<String?> createOrUpdateEvent(
      String calendarId, String title, DateTime startTime, DateTime endTime) async {
    final tzStartTime = tz.TZDateTime.from(startTime, tz.local);
    final tzEndTime = tz.TZDateTime.from(endTime, tz.local);

    final event = Event(calendarId, start: tzStartTime, end: tzEndTime, title: title);
    final createOrUpdateResult = await _deviceCalendarPlugin.createOrUpdateEvent(event);
    return createOrUpdateResult?.data;
  }

  Future<List<Event>> retrieveEvents(String? calendarId, DateTime startDate, DateTime endDate) async {
    final retrieveEventsParams = RetrieveEventsParams(
      eventIds: null,
      startDate: startDate,
      endDate: endDate,
    );
    final eventsResult = await _deviceCalendarPlugin.retrieveEvents(calendarId, retrieveEventsParams);
    return eventsResult.data ?? [];
  }
}