import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/pages/request_page.dart';
import 'package:frontend/pages/help_info_page.dart';
import 'package:frontend/pages/personal_info_page.dart';
import 'package:frontend/pages/schedule_page.dart';
import 'package:frontend/pages/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/pages/authorization_page.dart';

class MainMenuWidget extends StatelessWidget {
  const MainMenuWidget({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');

    // Перенаправление на страницу входа
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthorizationWidget()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292929),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {},
                  child: Text(
                    'Главное меню',
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
            MainMenuButton(
              text: 'Личная информация',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalInfoWidget()),
                );
              },
            ),
            MainMenuButton(
              text: 'Расписание',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserSchedulePage()), // Переход на страницу расписания
                );
              },
            ),
            MainMenuButton(
              text: 'Запрос на доступ к помещению',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestFormWidget()),
                );
              },
            ),
            MainMenuButton(
              text: 'Связь с администратором',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage()),
                );
              },
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpInfoWidget()), // Переход на страницу справочной информации
                      );
                    },
                    child: Opacity(
                      opacity: 0.75,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10), // Отступ от нижнего края
                        child: Text(
                          'Справочная информация',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Readex Pro',
                            fontSize: 14, // Увеличенный размер шрифта
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _logout(context); // Вызов метода выхода
                    },
                    child: Opacity(
                      opacity: 0.5,
                      child: Align(
                        alignment: AlignmentDirectional(0, 1),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 15), // Отступ от нижнего края
                          child: Text(
                            'Выйти из аккаунта',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Readex Pro',
                              fontSize: 12,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
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

class MainMenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MainMenuButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0, -1),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
        child: SizedBox(
          width: 275,
          height: 70,
          child: TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color(0xFF14181B),
              ),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: Text(
              text,
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}