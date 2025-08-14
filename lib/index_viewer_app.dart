import 'package:flutter/material.dart';
import 'package:index_viewer/widgets/index_viwer.dart';

import 'widgets/new_stage_view.dart';
import 'widgets/stage_view.dart';

class IndexViewerApp extends StatefulWidget {
  const IndexViewerApp({super.key});

  @override
  State<IndexViewerApp> createState() => _IndexViewerAppState();
}

class _IndexViewerAppState extends State<IndexViewerApp> {
  final controller = TextEditingController(text: "some");

  final StageInfo stage = StageInfo.fromString("""
void main(){
 some long string and more on  gooes 
 some  and more on  gooes 
  long string and more on  gooes 
 some long string and more on  s 
 some long strmore on  gooes 
}""");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              ///
              // TextFormField(controller: controller),
              Expanded(
                child: StageView(mode: StageMode.normal, currentState: stage),
              ),
              // Expanded(child: NewStageView(stage: stage)),
            ],
          ),
        ),
      ),
    );
  }
}



// class MyHomePage extends StatefulWidget {
//   final String title;
//
//   const MyHomePage({
//     Key? key,
//     required this.title,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: TwoDimensionalGridView(
//         diagonalDragBehavior: DiagonalDragBehavior.free,
//         delegate: TwoDimensionalChildBuilderDelegate(
//             maxXIndex: 9,
//             maxYIndex: 9,
//             builder: (BuildContext context, ChildVicinity vicinity) {
//               return Container(
//                 color: vicinity.xIndex.isEven && vicinity.yIndex.isEven
//                     ? Colors.amber[50]
//                     : (vicinity.xIndex.isOdd && vicinity.yIndex.isOdd
//                         ? Colors.purple[50]
//                         : null),
//                 height: 200,
//                 width: 200,
//                 child: Center(
//                     child: Text(
//                         'Row ${vicinity.yIndex}: Column ${vicinity.xIndex}')),
//               );
//             }),
//       ),
//     );
//   }
// }
