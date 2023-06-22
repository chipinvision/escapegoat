////////////////////////////////////////////////////////
//  Instagram: @invisionchip
//  Github: https://github.com/chipinvision
//  LinkedIn: https://linkedin.com/invisionchip
////////////////////////////////////////////////////////
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:escapegoat/utils/app_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:clipboard/clipboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EscapeGOAT',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> category = [
    'family',
    'college',
    'office',
    'unbelievable',
  ];

  List<String> displaycategory = [
    'Family',
    'College',
    'Office',
    'Unbelievable',
  ];

  String selected = '';

  String _excuse = '';

  Future<void> _getExcuse() async {
    final response = await http
        .get(Uri.parse('https://excuser-three.vercel.app/v1/excuse/$selected'));

    if (response.statusCode == 200) {
      // update to retrieve excuse from response body instead of headers
      final excuseList = jsonDecode(response.body) as List<dynamic>;
      final excuse = excuseList.isNotEmpty ? excuseList[0]['excuse'] : '';
      setState(() {
        _excuse = excuse;
      });
    } else {
      throw Exception('Failed to load excuse');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 150,
            ),
            Text(
              'EscapeGOAT',
              style: GoogleFonts.getFont(
                'Orbitron',
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: AppStyle.text,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Choose the category for which you need an excuse',
              style: GoogleFonts.getFont(
                'Open Sans',
                textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: AppStyle.text,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: category.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChoiceChip(
                    label: Text(
                      displaycategory[index],
                      style: GoogleFonts.getFont(
                        'Open Sans',
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppStyle.text,
                        ),
                      ),
                    ),
                    selectedColor: AppStyle.accent,
                    backgroundColor: AppStyle.primary,
                    selected: selected == category[index],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.transparent),
                    ),
                    onSelected: (bool select) {
                      setState(() {
                        selected = select ? category[index] : '';
                      });
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 10);
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                _getExcuse();
              },
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppStyle.primary,
                ),
                child: Center(
                  child: Text(
                    'GENERATE',
                    style: GoogleFonts.getFont(
                      'Orbitron',
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: AppStyle.text,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Excuse: ',
                  style: GoogleFonts.getFont(
                    'Open Sans',
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: AppStyle.primary,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _excuse,
                style: GoogleFonts.getFont(
                  'Open Sans',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: AppStyle.text,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.primary,
        onPressed: () async {
          FlutterClipboard.copy(_excuse).then((value) {
            return ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Excuse Copied',
                  style: GoogleFonts.getFont(
                    'Open Sans',
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppStyle.text,
                    ),
                  ),
                ),
                backgroundColor: AppStyle.primary,
              ),
            );
          });
        },
        child: const Icon(Icons.copy),
      ),
    );
  }
}
