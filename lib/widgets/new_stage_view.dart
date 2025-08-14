import 'package:flutter/material.dart';

import 'index_viwer.dart';
import 'stage_view.dart';

/// from [StageView]  to this for new one,
/// this is just DragTarget
class NewStageView extends StatefulWidget {
  const NewStageView({super.key, required this.stage});

  /// current stage
  final StageInfo stage;

  @override
  State<NewStageView> createState() => _NewStageViewState();
}

class _NewStageViewState extends State<NewStageView> {
  late final gridSize = (
    rows: widget.stage.data.length + 0,
    cols: widget.stage.maxX + 0,
  );
  late List<List<IndexData>> data = List.generate(
    gridSize.rows,
    (x) => List.generate(gridSize.cols, ((y) => IndexData.empty)),
  );

  StageMode mode = StageMode.normal;

  @override
  Widget build(BuildContext context) {
    final double boxWidth =
        MediaQuery.sizeOf(context).width / gridSize.cols - 4;
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int x = 0; x < gridSize.rows; x++)
            Row(
              //try gridView ?
              spacing: 2,
              children: [
                for (int y = 0; y < gridSize.cols; y++) //
                  DragTarget<IndexData>(
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return SizedBox(
                        width: boxWidth,
                        child: IndexViwer(mode: mode, data: data[x][y]),
                      );
                    },
                    onAcceptWithDetails: (
                      DragTargetDetails<IndexData> details,
                    ) {
                      data[x][y] = details.data;
                      setState(() {});
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
