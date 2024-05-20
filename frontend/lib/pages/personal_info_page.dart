import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfoWidget extends StatefulWidget {
  const PersonalInfoWidget({super.key});

  @override
  State<PersonalInfoWidget> createState() => _PersonalInfoWidgetState();
}

class _PersonalInfoWidgetState extends State<PersonalInfoWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode unfocusNode = FocusNode();

  Map<String, dynamic> userInfo = {
    'fio': 'Загрузка...',
    'job_title': {'name': 'Загрузка...'},
    'phone_number': 'Загрузка...',
    'photo': null,
  };

  String? _token;
  int? userId;

  @override
  void initState() {
    super.initState();
    _getTokenAndFetchUserInfo();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  Future<void> _getTokenAndFetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
    if (_token != null) {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/v1/users/current/'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userId = data['id'];
        fetchUserInfo();
      } else {
        print('Failed to fetch user ID');
      }
    } else {
      print('No token found');
    }
  }

  Future<void> fetchUserInfo() async {
    if (userId == null) return;

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/v1/users/accounts/$userId/'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        userInfo = json.decode(utf8.decode(response.bodyBytes));
      });
    } else {
      // Обработка ошибки
      print('Ошибка загрузки данных пользователя');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF292929),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Text(
                      'Личная информация',
                      style: GoogleFonts.workSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/фото_2.jpg',
                    width: 150,
                    height: 175,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: Text(
                  userInfo['fio'] ?? 'Загрузка...', // Добавляем проверку на null
                  textAlign: TextAlign.center,
                  style: GoogleFonts.readexPro(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 0,
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                          child: Text(
                            'Должность:',
                            style: GoogleFonts.readexPro(
                              color: Colors.white,
                              fontSize: 15,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          userInfo['job_title']['job_title'] ?? 'Загрузка...',
                          style: GoogleFonts.readexPro(
                            color: Colors.white,
                            fontSize: 16,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                          child: Text(
                            'Номер телефона:',
                            style: GoogleFonts.readexPro(
                              color: Colors.white,
                              fontSize: 15,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          userInfo['phone_number'] ?? 'Загрузка...',
                          style: GoogleFonts.readexPro(
                            color: Colors.white,
                            fontSize: 16,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(30, 25, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF292929),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      elevation: 3,
                      textStyle: GoogleFonts.readexPro(
                        fontSize: 16,
                        letterSpacing: 0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_forward_ios, size: 15, color: Colors.white), // Устанавливаем белый цвет иконки
                        const Text(
                          ' Подробная информация',
                          style: TextStyle(color: Colors.white), // Устанавливаем белый цвет текста
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: IconButton(
                    icon: const Icon(Icons.home, color: Colors.white, size: 24),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}