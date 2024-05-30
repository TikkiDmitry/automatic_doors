import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class RequestFormWidget extends StatefulWidget {
  const RequestFormWidget({Key? key}) : super(key: key);

  @override
  State<RequestFormWidget> createState() => _RequestFormWidgetState();
}

class _RequestFormWidgetState extends State<RequestFormWidget> {
  late TextEditingController _textController1;
  late TextEditingController _textController2;
  late TextEditingController _textController3;

  late FocusNode _textFieldFocusNode1;
  late FocusNode _textFieldFocusNode2;
  late FocusNode _textFieldFocusNode3;

  final _formKey = GlobalKey<FormState>();

  String? _token;

  @override
  void initState() {
    super.initState();
    _textController1 = TextEditingController();
    _textController2 = TextEditingController();
    _textController3 = TextEditingController();

    _textFieldFocusNode1 = FocusNode();
    _textFieldFocusNode2 = FocusNode();
    _textFieldFocusNode3 = FocusNode();

    _getToken();
  }

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('jwt_token');
    });
  }

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();
    _textController3.dispose();

    _textFieldFocusNode1.dispose();
    _textFieldFocusNode2.dispose();
    _textFieldFocusNode3.dispose();

    super.dispose();
  }

  Future<void> _recordAccessRequest(int roomId, String timeRange, String reason, bool result, int userId) async {
    final times = timeRange.split('-');
    final currentDate = DateTime.now();
    final startDatetime = DateTime(currentDate.year, currentDate.month, currentDate.day, int.parse(times[0].split(':')[0]), int.parse(times[0].split(':')[1]));
    final endDatetime = DateTime(currentDate.year, currentDate.month, currentDate.day, int.parse(times[1].split(':')[0]), int.parse(times[1].split(':')[1]));

    try {
      print("Starting _recordAccessRequest with:");
      print("roomId: $roomId");
      print("startDatetime: $startDatetime");
      print("endDatetime: $endDatetime");
      print("reason: $reason");
      print("result: $result");
      print("userId: $userId");

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/v1/rooms/access/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'id_user': userId,
          'number_room': roomId,
          'startDatetime': startDatetime.toIso8601String(),
          'endDatetime': endDatetime.toIso8601String(),
          'cause': reason,
          'result': result,
          'cause_acc_den': result ? 'Разрешено системой' : 'Отказано системой', // Обновленная часть
        }),
      );

      print("HTTP POST response status code: ${response.statusCode}");
      print("HTTP POST response body: ${response.body}");

      if (response.statusCode == 201) {
        print('Access request recorded successfully');
      } else {
        print('Failed to record access request');
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      _showDialog('Ошибка', 'Произошла ошибка при записи запроса');
    }
  }

  Future<void> _checkRoomAvailability() async {
    final roomNumber = _textController1.text;
    final timeRange = _textController2.text;
    final reason = _textController3.text;

    int? userId;
    int? roomId;

    // Check if the room exists
    final roomResponse = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/v1/rooms/list/'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (roomResponse.statusCode == 200) {
      final roomList = jsonDecode(roomResponse.body);
      final room = roomList.firstWhere((room) => room['number_room'] == roomNumber, orElse: () => null);
      if (room == null) {
        _showDialog('Ошибка', 'Помещение не найдено');
        return;
      } else {
        roomId = room['id'];
      }

      if (_token != null) {
        final response = await http.get(
          Uri.parse('http://127.0.0.1:8000/api/v1/users/current/'),
          headers: {'Authorization': 'Bearer $_token'},
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          userId = data['id'];
        } else {
          print('Failed to fetch user ID');
          print('Response status code: ${response.statusCode}');
          print('Response body: ${response.body}');
          return;
        }
      } else {
        print('No token found');
        return;
      }

      // Check if the room is available
      final scheduleResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/v1/users/schedule/$userId/?room=$roomId'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (scheduleResponse.statusCode == 200) {
        final schedule = jsonDecode(scheduleResponse.body);
        print(schedule);
        final isAvailable = _isRoomAvailable(schedule, timeRange);
        if (isAvailable) {
          if (userId != null && roomId != null) {
            await _recordAccessRequest(roomId, timeRange, reason, true, userId);
            _showDialog('Успешно', 'Доступ разрешен');
          }
        } else {
          if (userId != null && roomId != null) {
            await _recordAccessRequest(roomId, timeRange, reason, false, userId);
            _showDialog('Ошибка', 'Помещение занято');
          }
        }
      } else {
        _showDialog('Ошибка', 'Не удалось получить расписание помещения');
        print('Response status code: ${scheduleResponse.statusCode}');
        print('Response body: ${scheduleResponse.body}');
      }
    } else {
      _showDialog('Ошибка', 'Не удалось получить список помещений');
      print('Response status code: ${roomResponse.statusCode}');
      print('Response body: ${roomResponse.body}');
    }
  }

  bool _isRoomAvailable(List<dynamic> schedule, String timeRange) {
    final times = timeRange.split('-');
    final requestedStartTime = times[0].trim();
    final requestedEndTime = times[1].trim();

    for (var entry in schedule) {
      final startTime = entry['start_time'];
      final endTime = entry['end_time'];

      if (!(requestedEndTime.compareTo(startTime) <= 0 || requestedStartTime.compareTo(endTime) >= 0)) {
        return false; // Room is not available
      }
    }

    return true; // Room is available
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Work Sans',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black, // Цвет заголовка
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            fontFamily: 'Work Sans',
            fontSize: 15,
            color: Colors.black, // Цвет текста сообщения
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(
                fontFamily: 'Work Sans',
                fontSize: 16,
                color: Colors.black, // Цвет кнопки
              ),
            ),
          ),
        ],
        backgroundColor: Color(0xFFECECEC), // Цвет фона окна
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Радиус скругления углов
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFF292929),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: InkWell(
                  child: Text(
                    'Форма запроса',
                    style: GoogleFonts.getFont(
                      'Work Sans',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _textController1,
                        focusNode: _textFieldFocusNode1,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Номер помещения',
                          labelStyle: TextStyle(
                            color: Color(0xFFACACAC),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите номер помещения';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _textController2,
                        focusNode: _textFieldFocusNode2,
                        inputFormatters: [
                          MaskedInputFormatter('00:00-00:00'),
                        ],
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Время',
                          labelStyle: TextStyle(
                            color: Color(0xFFACACAC),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите время';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _textController3,
                        focusNode: _textFieldFocusNode3,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Причина',
                          labelStyle: TextStyle(
                            color: Color(0xFFACACAC),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите причину';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 50),
                      FFButtonWidget(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print('Form validated');
                            _checkRoomAvailability();
                          }
                        },
                        text: 'Отправить',
                        options: FFButtonOptions(
                          width: 200,
                          height: 50,
                          color: Color(0xFF292929),
                          textStyle: GoogleFonts.getFont(
                            'Readex Pro',
                            color: Colors.white,
                            fontSize: 17,
                            letterSpacing: 0,
                          ),
                          elevation: 3,
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
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

class FFButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final FFButtonOptions options;

  const FFButtonWidget({
    required this.onPressed,
    required this.text,
    required this.options,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: options.width,
      height: options.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(options.color),
          elevation: MaterialStateProperty.all<double>(options.elevation),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: options.borderRadius,
              side: options.borderSide,
            ),
          ),
        ),
        child: Text(
          text,
          style: options.textStyle,
        ),
      ),
    );
  }
}

class FFButtonOptions {
  final double width;
  final double height;
  final Color color;
  final TextStyle textStyle;
  final double elevation;
  final BorderSide borderSide;
  final BorderRadiusGeometry borderRadius;

  const FFButtonOptions({
    required this.width,
    required this.height,
    required this.color,
    required this.textStyle,
    required this.elevation,
    required this.borderSide,
    required this.borderRadius,
  });
}