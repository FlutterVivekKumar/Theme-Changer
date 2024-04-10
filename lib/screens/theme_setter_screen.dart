import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remote_config/logic/theme_changer.dart';
import 'package:remote_config/main.dart';

class ThemeSetterScreen extends StatefulWidget {
  const ThemeSetterScreen({super.key});

  @override
  State<ThemeSetterScreen> createState() => _ThemeSetterScreenState();
}

class _ThemeSetterScreenState extends State<ThemeSetterScreen> {
  Future<Map<String, dynamic>> getDataFromRemoteConfig() async {
    final data = await remoteConfig.getString('theme');
    print(data);
    return jsonDecode(data);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change App Theme'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: getDataFromRemoteConfig(),
          builder: (context, snap) {
            List<ThemeData> themeList = [];

// Add default light and dark themes
            themeList.add(ThemeData.light());
            themeList.add(ThemeData.dark());

            if (snap.hasData) {
              final Map<String, dynamic> data = snap.data!['theme'];
              final Map<String, dynamic> cardData = snap.data!['cardTheme'];



              // Create custom theme
              ThemeData customTheme = ThemeData(
                primaryColor: parseColor(data['primaryColor']),
                accentColor: parseColor(data['accentColor']),
                backgroundColor: parseColor(data['backgroundColor']),
                appBarTheme: AppBarTheme(color: parseColor(data['primaryColor'])),
                iconTheme: IconThemeData(color: data['iconColor'].toString().toColor()),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: parseColor(data['primaryColor']),

                ),
                cardTheme: CardTheme(
                  color: parseColor(cardData['color']),
                  elevation: cardData['elevation'].toDouble(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      cardData['shape']['borderRadius'].toDouble(),
                    ),
                  ),
                ),
              );


              themeList.add(customTheme);
            }


            return Wrap(
              children: List.generate(
                  themeList.length,
                  (index) => InkWell(
                        onTap: () {
                          Provider.of<ThemeChanger>(context, listen: false)
                              .toggleTheme(selectedTheme: themeList[index]);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              width: size.width * .28,
                              height: size.width * .28,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    themeList[index].primaryColor,
                                    themeList[index].canvasColor,
                                    themeList[index].dialogBackgroundColor,
                                    themeList[index].shadowColor,
                                    themeList[index].scaffoldBackgroundColor,
                                    themeList[index].backgroundColor,
                                    themeList[index].buttonColor
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
            );
          }),
    );
  }
}
// Extract colors
Color parseColor(String colorString) =>
    colorString.replaceAll('0xFF', '#').toColor();

