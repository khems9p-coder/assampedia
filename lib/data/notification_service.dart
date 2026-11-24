import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../core/i18n/app_lang.dart';
import 'jobs_models.dart';
import 'quotes.dart';

/// The morning quote notification, and which job vacancies are new to this
/// reader (for the bell on the Home screen).
class NotificationService extends ChangeNotifier {
  NotificationService({bool? onDevice}) : _onDevice = onDevice ?? (!kIsWeb && Platform.isAndroid);

  /// Whether real phone notifications can be shown (false in tests and on the web).
  final bool _onDevice;

  /// The hour (24-hour clock, India time) of the morning notification.
  static const morningHour = 7;

  /// How many mornings ahead are scheduled. Opening the app tops this up.
  static const daysAhead = 14;

  static const _dailyKey = 'daily_quote_on';
  static const _seenKey = 'seen_job_ids';
  static const _channelId = 'daily_quote';

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  bool _dailyOn = true;
  final Set<String> _seenJobs = {};
  List<Vacancy> _openJobs = const [];

  /// Whether the morning quote is switched on (on by default).
  bool get dailyOn => _dailyOn;

  /// Open vacancies, newest closing date last.
  List<Vacancy> get openJobs => _openJobs;

  bool isNew(Vacancy v) => v.id != null && !_seenJobs.contains(v.id);

  /// How many open vacancies this reader has not seen yet.
  int get newJobCount => _openJobs.where(isNew).length;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _dailyOn = prefs.getBool(_dailyKey) ?? true;
    _seenJobs
      ..clear()
      ..addAll(prefs.getStringList(_seenKey) ?? const []);
    notifyListeners();
  }

  /// Sets up the phone notifications and schedules the coming mornings.
  /// Safe to call on every app start and after the language changes.
  Future<void> start(AppLang lang) {
    if (!_onDevice) return Future.value();
    // One set-up at a time, in the order asked.
    return _queue = _queue.then((_) => _start(lang));
  }

  Future<void> _queue = Future.value();

  Future<void> _start(AppLang lang) async {
    try {
      if (!_ready) {
        tzdata.initializeTimeZones();
        tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
        await _plugin.initialize(const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')));
        _ready = true;
      }
      await _schedule(lang);
    } catch (e) {
      debugPrint('Notifications could not be set up: $e');
    }
  }

  Future<void> setDailyOn(bool on, AppLang lang) async {
    _dailyOn = on;
    notifyListeners();
    await (await SharedPreferences.getInstance()).setBool(_dailyKey, on);
    await start(lang);
  }

  Future<void> _schedule(AppLang lang) async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await _plugin.cancelAll();
    if (!_dailyOn) return;
    // Android 13 and newer ask the reader once; later calls return straight away.
    final allowed = await android?.requestNotificationsPermission() ?? true;
    if (!allowed) return;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        lang == AppLang.assamese ? 'আজিৰ প্ৰেৰণা' : 'Morning quote',
        channelDescription: lang == AppLang.assamese ? 'প্ৰতিদিনে ৰাতিপুৱা এটা প্ৰেৰণাদায়ক বাণী' : 'A motivational quote every morning',
        styleInformation: const BigTextStyleInformation(''),
      ),
    );
    for (final when in morningsFrom(tz.TZDateTime.now(tz.local))) {
      final q = quoteForDay(when);
      await _plugin.zonedSchedule(
        when.year * 10000 + when.month * 100 + when.day,
        lang == AppLang.assamese ? 'আজিৰ প্ৰেৰণা ☀️' : 'Thought for today ☀️',
        '“${q.text(lang)}”\n— ${q.author(lang)}',
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  /// The next [daysAhead] mornings at [morningHour] after [now].
  static List<tz.TZDateTime> morningsFrom(tz.TZDateTime now) {
    var first = tz.TZDateTime(now.location, now.year, now.month, now.day, morningHour);
    if (!first.isAfter(now)) first = first.add(const Duration(days: 1));
    return [for (var i = 0; i < daysAhead; i++) tz.TZDateTime(now.location, first.year, first.month, first.day + i, morningHour)];
  }

  /// Updates the list of open vacancies (for the bell's count).
  void updateJobs(List<Vacancy> all, [DateTime? today]) {
    final open = [
      for (final v in all)
        if (v.status(today) != VacancyStatus.closed) v,
    ]..sort((a, b) => a.closingDate.compareTo(b.closingDate));
    _openJobs = open;
    notifyListeners();
  }

  /// Marks every open vacancy as seen, so the bell's count goes back to 0.
  Future<void> markJobsSeen() async {
    final ids = [for (final v in _openJobs) ?v.id];
    if (ids.every(_seenJobs.contains)) return;
    _seenJobs.addAll(ids);
    notifyListeners();
    await (await SharedPreferences.getInstance()).setStringList(_seenKey, _seenJobs.toList());
  }
}
