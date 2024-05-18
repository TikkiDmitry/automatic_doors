import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart' show rootBundle;

class HelpInfoWidget extends StatefulWidget {
  const HelpInfoWidget({Key? key}) : super(key: key);

  @override
  _HelpInfoWidgetState createState() => _HelpInfoWidgetState();
}

class _HelpInfoWidgetState extends State<HelpInfoWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode unfocusNode = FocusNode();
  String helpInfoText = "";

  @override
  void initState() {
    super.initState();
    _loadHelpInfo();
  }

  Future<void> _loadHelpInfo() async {
    final text = await rootBundle.loadString('assets/help_info.txt');
    setState(() {
      helpInfoText = text;
    });
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (unfocusNode.canRequestFocus) {
          FocusScope.of(context).requestFocus(unfocusNode);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF292929),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: InkWell(
                    child: Text(
                      'Справочная информация',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.workSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                  child: SingleChildScrollView(
                    child: Text(
                      helpInfoText,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 1),
                child: IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
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
