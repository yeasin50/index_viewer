import 'package:flutter/material.dart';

import 'index_viwer.dart';
import 'stage_view.dart';
import 'two_dimensional_grid_view.dart' show TwoDimensionalGridView;

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
  get gridSize => (
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
    final double spacing = 20;
    final double boxWidth = 80;
    return Column(
      children: [
        Expanded(
          child: TwoDimensionalGridView(
            key: ValueKey("new Stage"),
            gridDimension: boxWidth + spacing,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            delegate: TwoDimensionalChildBuilderDelegate(
              maxXIndex: gridSize.cols,
              maxYIndex: gridSize.rows,
              addRepaintBoundaries: true,
              builder: (context, vicinity) {
                var indexData =
                    vicinity.yIndex < data.length &&
                            vicinity.xIndex < data[vicinity.yIndex].length
                        ? data[vicinity.yIndex][vicinity.xIndex]
                        : null;

                assert(indexData != null, "indexData  should not be empty");
                return DragTarget<IndexData>(
                  builder: (
                    BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected,
                  ) {
                    return SizedBox(
                      width: boxWidth,
                      child: IndexViwer(
                        key: ValueKey(indexData),
                        mode: mode,
                        data: indexData!,
                        onDelete:
                            indexData == IndexData.empty
                                ? null
                                : () {
                                  data[vicinity.yIndex] = List.from(
                                    data[vicinity.yIndex],
                                  );
                                  data[vicinity.yIndex][vicinity.xIndex] =
                                      IndexData.empty;
                                  setState(() {});
                                },
                      ),
                    );
                  },
                  onAcceptWithDetails: (DragTargetDetails<IndexData> details) {
                    data[vicinity.yIndex][vicinity.xIndex] = details.data;

                    setState(() {});
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
