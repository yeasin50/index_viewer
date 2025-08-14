import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:index_viewer/index_viewer_app.dart';

/// This is a simple application,  have go goal for hundreds of characters rendering.
/// I usually have 30/40 characters and 4/5 sentences  for my work,  and few lines,
/// I just don't wanna count any every time I make changes which  messed up my.
void main() {
  runApp(
    MaterialApp(
      home: IndexViewerApp(),
      theme: ThemeData.dark().copyWith(), //
      scrollBehavior: ScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
        },
      ),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ValueKey get genKey => ValueKey(DateTime.now());

  late List<ValueKey> keys = [ValueKey(genKey)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Index indicator")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          spacing: 24,
          children: [
            ElevatedButton(
              onPressed: () {
                keys.add(genKey);
                setState(() {});
              },
              child: Text("add new item"),
            ),
            SizedBox(height: 24),
            for (int i = 0; i < keys.length; i++)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: IndexBuilder()),
                  IconButton(
                    onPressed: () {
                      keys.removeAt(i);
                      setState(() {});
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class IndexBuilder extends StatefulWidget {
  const IndexBuilder({super.key});

  @override
  State<IndexBuilder> createState() => _IndexBuilderState();
}

class _IndexBuilderState extends State<IndexBuilder> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final charStyle = TextStyle(fontSize: 32);
    final highLightStyle = charStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.cyanAccent,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 24,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyanAccent.withAlpha(100)),
            ),
          ),
        ),

        Wrap(
          children: List.generate(controller.text.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                children: [
                  Text(i.toString(), style: highLightStyle),
                  Text(controller.text[i], style: charStyle),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// shows index at top of each  char
// Flexible(
//   child: CustomPaint(
//     painter: StringIndexPainter(
//       controller: controller,
//       style: TextStyle(color: Colors.white, fontSize: 32),
//     ),
//   ),
// ),
class StringIndexPainter extends CustomPainter {
  StringIndexPainter({required this.controller, required this.style})
    : super(repaint: controller);

  final TextEditingController controller;
  final TextStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final text = controller.text;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    double x = 0.0;
    double y = 0.0;

    double charGap = 16 + (text.length / size.width);

    for (int i = 0; i < text.length; i++) {
      final char = text[i];

      textPainter.text = TextSpan(
        text: char,
        style: style.copyWith(
          fontWeight: FontWeight.w300,
          color: style.color?.withAlpha(150),
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y + textPainter.height * 1 / 3));

      final indexPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: style.copyWith(
            fontSize: style.fontSize! / 2,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      indexPainter.layout();

      final indexOffset = Offset(
        x + (textPainter.width - indexPainter.width) / 2,
        y - 5,
      );
      indexPainter.paint(canvas, indexOffset);

      x += textPainter.width + charGap;

      if (x > size.width) {
        x = 0.0;
        y += textPainter.height + (style.fontSize ?? 24);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
