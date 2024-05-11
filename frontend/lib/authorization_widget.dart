import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF292929), // Установить цвет фона AppBar
        title: Text(
          'TECHNO-DOORS',
          style: TextStyle(
            color: Colors.white, // Цвет заголовка белый
            fontWeight: FontWeight.bold,
            fontFamily: 'Work Sans',
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF292929), // Установить цвет фона для основного тела
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                cursorColor: Colors.white, // Цвет курсора белый
                style: TextStyle(color: Colors.white), // Цвет вводимого текста белый
                decoration: InputDecoration(
                  labelText: 'Логин',
                  labelStyle: TextStyle(
                    color: Color(0xFFACACAC), // Цвет надписей "Логин" и "Пароль"
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Цвет черточки при наборе
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Цвет нижней черточки
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                cursorColor: Colors.white, // Цвет курсора белый
                style: TextStyle(color: Colors.white), // Цвет вводимого текста белый
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  labelStyle: TextStyle(
                    color: Color(0xFFACACAC), // Цвет надписей "Логин" и "Пароль"
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Цвет черточки при наборе
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Цвет нижней черточки
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Действие при нажатии на кнопку "Войти"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Устанавливаем прозрачный фон
                  elevation: 0, // Убираем тень кнопки
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0), // Уменьшаем отступы по горизонтали и вертикали
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Закругляем углы кнопки
                  ),
                ),
                child: Container(
                  width: 130,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Закругляем углы контейнера кнопки
                    color: Color(0xFF14181B), // Цвет фона кнопки
                  ),
                  child: Text('Войти',
                    style: TextStyle(
                      color: Colors.white, // Цвет текста кнопки
                      fontFamily: 'Work Sans',
                      ),
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

void main() {
  runApp(MaterialApp(
    home: LoginForm(),
  ));
}