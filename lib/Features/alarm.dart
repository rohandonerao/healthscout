import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class AlarmSettingScreen extends StatefulWidget {
  @override
  _AlarmSettingScreenState createState() => _AlarmSettingScreenState();
}

class _AlarmSettingScreenState extends State<AlarmSettingScreen>
    with SingleTickerProviderStateMixin {
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _alarmEnabled = true;
  String _selectedAlarmTone = 'Default Tone';

  final List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  final List<String> _selectedDays = [];

  static void alarmCallback() {
    print("🔔 Alarm Triggered!");
  }

  void _showAlarmTimeToast() {
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final timeUntilAlarm = selectedDateTime.isBefore(now)
        ? selectedDateTime.add(Duration(days: 1)).difference(now)
        : selectedDateTime.difference(now);

    Fluttertoast.showToast(
      msg: 'Alarm set for ${_selectedTime.format(context)}\n'
          'Will ring in ${timeUntilAlarm.inHours}h ${timeUntilAlarm.inMinutes.remainder(60)}m',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.lightBlue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _scheduleRealAlarm() async {
    const platform = MethodChannel('com.healthscout/alarm');

    try {
      await platform.invokeMethod('setAlarm', {
        'hour': _selectedTime.hour,
        'minute': _selectedTime.minute,
        'days': _selectedDays,
        'message': 'HealthScout Reminder',
      });
    } on PlatformException catch (e) {
      print("Failed to set alarm: ${e.message}");
    }
  }

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _toggleEveryday() {
    setState(() {
      if (_selectedDays.length == 7) {
        _selectedDays.clear();
      } else {
        _selectedDays.clear();
        _selectedDays.addAll(_weekdays);
      }
    });
  }

  bool get isEveryday => _selectedDays.length == 7;

  @override
  Widget build(BuildContext context) {
    final headline = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Set Alarm'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Time", style: headline),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (picked != null) {
                        setState(() => _selectedTime = picked);
                      }
                    },
                    icon: Icon(Icons.access_time),
                    label: Text(_selectedTime.format(context),
                        style: TextStyle(fontSize: 22)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text("Repeat", style: headline),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      ChoiceChip(
                        label: Text("Everyday"),
                        selected: isEveryday,
                        selectedColor: Colors.lightBlue,
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          color: isEveryday ? Colors.white : Colors.black,
                        ),
                        onSelected: (selected) => _toggleEveryday(),
                      ),
                      ..._weekdays.map((day) => ChoiceChip(
                            label: Text(day),
                            selected: _selectedDays.contains(day),
                            selectedColor: Colors.lightBlueAccent,
                            backgroundColor: Colors.grey.shade200,
                            labelStyle: TextStyle(
                              color: _selectedDays.contains(day)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onSelected: (selected) => _toggleDay(day),
                          )),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text("Alarm Tone", style: headline),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedAlarmTone,
                        items:
                            ['Default Tone', 'Custom Tone 1', 'Custom Tone 2']
                                .map((tone) => DropdownMenuItem(
                                      value: tone,
                                      child: Row(
                                        children: [
                                          Icon(Icons.music_note,
                                              color: Colors.lightBlueAccent),
                                          SizedBox(width: 10),
                                          Text(tone),
                                        ],
                                      ),
                                    ))
                                .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedAlarmTone = value!),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Enable Alarm", style: headline),
                      Switch(
                        value: _alarmEnabled,
                        activeColor: Colors.lightBlueAccent,
                        onChanged: (val) => setState(() => _alarmEnabled = val),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showAlarmTimeToast();
                        _scheduleRealAlarm();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.check),
                      label: Text('Save Alarm', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
