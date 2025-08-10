import 'package:flutter/material.dart';
import 'package:index_viewer/widgets/index_viwer.dart';

import 'widgets/stage_view.dart';

class IndexViewerApp extends StatefulWidget {
  const IndexViewerApp({super.key});

  @override
  State<IndexViewerApp> createState() => _IndexViewerAppState();
}

class _IndexViewerAppState extends State<IndexViewerApp> {
  final controller = TextEditingController(text: "some");

  final StageInfo stage  =  StageInfo.fromString("""
void main(){
 
}""");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ///
          TextFormField(controller: controller),
          Flexible(
            child: StageView(
              mode: StageMode.normal,
              currentState: stage,
            ),
          ),
          Expanded(
            child: NewStageView(
              stage: stage,
            ),
          ),
        ],
      ),
    );
  }
}
