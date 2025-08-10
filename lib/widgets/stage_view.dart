import 'package:flutter/material.dart';
import 'package:index_viewer/widgets/index_viwer.dart';

class StageInfo {
  const StageInfo({
    required this.data,
    required this.version,
    required this.maxX,
    this.mode = StageMode.normal,
  });

  final List<List<IndexData>> data;
  final int maxX;
  final int version;
  final StageMode mode;

  // FIXME: without any space lines doesnt count
  factory StageInfo.fromString(String str) {
    List<List<IndexData>> result = [];
    final lines = str.split("\n");
    int maxWidth = 0;
    for (int y = 0; y < lines.length; y++) {
      if (maxWidth < lines[y].length) maxWidth = lines[y].length;
      final List<IndexData> rows = [];
      for (int x = 0; x < lines[y].length; x++) {
        rows.add(
          IndexData(
            char: lines[y][x],
            idx: x,
            idy: y,
            cdx: x,
            cdy: y,

            version: 1,
          ),
        );
      }
      result.add(rows);
    }

    return StageInfo(
      data: result,
      version: 1,
      mode: StageMode.normal,
      maxX: maxWidth,
    );
  }

  StageInfo copyWith({
    List<List<IndexData>>? data,
    int? version,
    StageMode? mode, //
    int? maxX,
  }) {
    return StageInfo(
      data: data ?? this.data,
      maxX: maxX ?? this.maxX,
      version: version ?? this.version,
      mode: mode ?? this.mode,
    );
  }

  @override
  String toString() {
    return 'StageInfo(data: $data, version: $version, mode: $mode)';
  }
}

/// show each  stage, yes on each version,
class StageView extends StatelessWidget {
  const StageView({super.key, required this.currentState, required this.mode});
  final StageInfo currentState;
  final StageMode mode;
  @override
  Widget build(BuildContext context) {
    final double boxWidth =
        MediaQuery.sizeOf(context).width / currentState.maxX - 4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final row in currentState.data)
          Row(
            spacing: 2,
            children: [
              for (final indexData in row) //
                () {
                  final card = SizedBox.square(
                    dimension: boxWidth,
                    child: IndexViwer(mode: mode, data: indexData),
                  );
                  return Draggable<IndexData>(
                    data: indexData,
                    feedback: ColoredBox(color: Colors.grey, child: card),
                    childWhenDragging: ColoredBox(
                      color: Colors.green,
                      child: card,
                    ),
                    child: card,
                  );
                }(),
            ],
          ),
      ],
    );
  }
}

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
