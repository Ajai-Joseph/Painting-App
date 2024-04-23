import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:paint_the_drawing/getbuilder.dart';
import 'package:paint_the_drawing/home_binding.dart';
import 'package:paint_the_drawing/screen.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:vibration/vibration.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

String homeScreen = '/homeScreen';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListScreen(),
      getPages: [
        GetPage(
            name: homeScreen, page: () => HomeScreen(), binding: HomeBinding())
      ],
    );
  }
}

class ListScreen extends StatefulWidget {
  ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<String> svgPaths = [
    "assets/fish.svg",
    "assets/air-fare-svgrepo-com.svg",
    "assets/tiger.svg",
    "assets/lion.svg",
  ];

  GenerativeModel model = GenerativeModel(
      model: 'gemini-pro', apiKey: "AIzaSyAQ5YOe3KPXz68YeYazb-6xtcfpKb1nFlo");

  ChatSession? chatSession;
  @override
  void initState() {
    chatSession = model.startChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  svgPaths[index],
                  height: 100,
                  width: 100,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          log(svgPaths[index]);
                          Path path = await getDrawPath(
                              svgPaths[index] == "assets/s-letter-thumbnail.svg"
                                  ? "assets/s-letter.svg"
                                  : svgPaths[index]);

                          Get.toNamed(homeScreen,
                              arguments: {'path': path, 'isSand': true});
                        },
                        child: Text('Sand Writing')),
                    SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          Path path = await getDrawPath(
                              svgPaths[index] == "assets/s-letter-thumbnail.svg"
                                  ? "assets/s-letter.svg"
                                  : svgPaths[index]);

                          Get.toNamed(homeScreen,
                              arguments: {'path': path, 'isSand': false});
                        },
                        child: Text('Blackboard Writing'))
                  ],
                )
              ],
            );
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 300),
              child: Divider(),
            );
          },
          itemCount: svgPaths.length,
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          showMyDialog(context);
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue,
          ),
          child: Center(
            child: Text(
              'USE AI',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }

  showMyDialog(BuildContext context) async {
    TextEditingController textFieldController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Text'),
          content: TextField(
            controller: textFieldController,
            decoration: InputDecoration(hintText: 'Type something...'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: Material(
                          color: Colors.transparent,
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          )),
                    );
                  },
                );
                log(textFieldController.text);
                String msg =
                    'Give detailed svg to draw a ${textFieldController.text} image,  width=800px height=800px, strokewidth=60';
                sendChat(msg);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  sendChat(String message) async {
    try {
      GenerateContentResponse response =
          await chatSession!.sendMessage(Content.text(message));
      String? text = response.text;
      log(text.toString());
      Navigator.of(context).pop();
      if (text != null && text != '') {
        List<String> paths = extractPathsFromSVG(text);
        String combinedPaths = combinePaths(paths);
        Navigator.of(context).pop();
        Get.toNamed(homeScreen, arguments: {
          'path': parseSvgPathData(combinedPaths),
          'isSand': false
        });
      } else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Something went wrong'),
            backgroundColor: Colors.red,
          ));
      }
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.red,
        ));
      Navigator.of(context).pop();
    }
  }

  String getMessageFromContent(Content content) {
    return content.parts.whereType<TextPart>().map((e) => e.text).join('');
  }
}

// Future<String> fetchSvgFromUrl() async {
//   final response = await http.get(Uri.parse(
//       "https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/why.svg"));
//   if (response.statusCode == 200) {
//     return response.body;
//   } else {
//     throw Exception('Failed to load SVG from the URL: ');
//   }
// }

Future<Path> getDrawPath(String svgPath) async {
  String svgContent = await rootBundle.loadString(svgPath);
  //F String svgContent = await fetchSvgFromUrl();
  XmlDocument document = XmlDocument.parse(svgContent);

  List<XmlElement> paths = document.findAllElements('path').toList();
  return parseSvgPathData(
      paths.map((e) => e.getAttribute('d')).toList().join(' '));
}

List<String> extractPathsFromSVG(String svgCode) {
  RegExp regex = RegExp(r'd="([^"]+)"');
  Iterable<Match> matches = regex.allMatches(svgCode);

  List<String> paths = [];
  for (Match match in matches) {
    if (match.groupCount == 1) {
      paths.add(match.group(1)!);
    }
  }

  return paths;
}

String combinePaths(List<String> paths) {
  return paths.join(' ');
}
