import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSchedulePage extends StatefulWidget {
  @override
  _UserSchedulePageState createState() => _UserSchedulePageState();
}

class _UserSchedulePageState extends State<UserSchedulePage> with SingleTickerProviderStateMixin {
  List<dynamic> _userSchedule = [];
  String? _token;
  int _selectedDay = 0;
  late TabController _tabController;

  final List<String> _daysOfWeek = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
  final Map<String, String> _daysOfWeekMap = {
    'Пн': 'Понедельник',
    'Вт': 'Вторник',
    'Ср': 'Среда',
    'Чт': 'Четверг',
    'Пт': 'Пятница',
    'Сб': 'Суббота',
    'Вс': 'Воскресенье',
  };

  @override
  void initState() {
    super.initState();
    _loadToken();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedDay = _tabController.index;
          if (_token != null) {
            _fetchUserSchedule(_token!);
          }
        });
      }
    });
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    setState(() {
      _token = token;
      if (_token != null) {
        _fetchUserSchedule(_token!);
      }
    });
  }

  Future<void> _fetchUserSchedule(String token) async {
    final userInfoResponse = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/v1/users/current/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (userInfoResponse.statusCode == 200) {
      final data = jsonDecode(userInfoResponse.body);
      final int userId = data['id'];
      final selectedDayFullName = _daysOfWeekMap[_daysOfWeek[_selectedDay]]!;
      final scheduleUrl = 'http://127.0.0.1:8000/api/v1/users/schedule/$userId/?day_of_week=$selectedDayFullName';

      print('Schedule URL: $scheduleUrl'); // Debug URL

      final scheduleResponse = await http.get(
        Uri.parse(scheduleUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (scheduleResponse.statusCode == 200) {
        final scheduleData = jsonDecode(scheduleResponse.body);

        print('Schedule Data for $selectedDayFullName: $scheduleData');

        setState(() {
          _userSchedule = scheduleData;
        });
      } else {
        _showDialog('Ошибка', 'Не удалось получить расписание пользователя');
      }
    } else {
      _showDialog('Ошибка', 'Не удалось получить информацию о пользователе');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xFF292929),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 70),
                child: Text(
                  'Расписание',
                  style: GoogleFonts.getFont(
                    'Work Sans',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.white,
                tabs: _daysOfWeek.map((day) => Tab(text: day)).toList(),
              ),
              SizedBox(height: 5),
              Expanded(
                child: _userSchedule.isEmpty
                  ? Center(
                      child: Text(
                        'На этот день расписания нет',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : SingleChildScrollView(
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Начало', style: TextStyle(color: Colors.white))),
                          DataColumn(label: Text('Окончание', style: TextStyle(color: Colors.white))),
                          DataColumn(label: Text('Помещение', style: TextStyle(color: Colors.white))),
                        ],
                        rows: _userSchedule.map((scheduleItem) {
                          final startTime = scheduleItem['start_time'];
                          final endTime = scheduleItem['end_time'];
                          final room = scheduleItem['room']['number_room'];
                          return DataRow(cells: [
                            DataCell(Text('$startTime', style: TextStyle(color: Colors.white))),
                            DataCell(Text('$endTime', style: TextStyle(color: Colors.white))),
                            DataCell(Text('$room', style: TextStyle(color: Colors.white))),
                          ]);
                        }).toList(),
                      ),
                    ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}