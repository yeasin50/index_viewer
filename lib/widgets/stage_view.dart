import 'package:flutter/material.dart';
import 'package:index_viewer/widgets/index_viwer.dart';

import 'two_dimensional_grid_view.dart';

class StageInfo {
  const StageInfo({
    required this.data,
    required this.version,
    required this.maxX,
    this.gridDimension = 100,
    this.mode = StageMode.normal,
  });

  final List<List<IndexData>> data;
  final int maxX;
  final int version;
  final StageMode mode;

  ///  to zoom in stageView for TwoDimensionalGridView
  final double gridDimension;

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
    double? gridDimension,
  }) {
    return StageInfo(
      gridDimension: gridDimension ?? this.gridDimension,
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
class StageView extends StatefulWidget {
  const StageView({super.key, required this.currentState, required this.mode});
  final StageInfo currentState;
  final StageMode mode;

  @override
  State<StageView> createState() => _StageViewState();
}

class _StageViewState extends State<StageView> {
  bool scrollable = true;

  ScrollPhysics? get scrollPhysics =>
      scrollable
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics();

  ScrollableDetails get verticalDetails => ScrollableDetails.vertical(
    physics: scrollPhysics,
    controller: verticalController,
  );

  ScrollableDetails get horizontalDetails => ScrollableDetails.horizontal(
    physics: scrollPhysics,
    controller: horizontalController,
  );

  final horizontalController = ScrollController();
  final verticalController = ScrollController();

  @override
  void dispose() {
    horizontalController.dispose();
    verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 24,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                scrollable = true;
                setState(() {});
              },
              color: !scrollable ? Colors.grey : Colors.blueAccent,
              icon: Icon(Icons.pan_tool),
            ),
            IconButton(
              onPressed: () {
                scrollable = false;
                setState(() {});
              },
              color: scrollable ? Colors.grey : Colors.blueAccent,
              icon: Icon(Icons.drag_handle),
            ),
          ],
        ),
        Expanded(
          child: TwoDimensionalGridView(
            key: ValueKey(
              "Stage view $scrollable",
            ), // there is a bug, changing physics doesn't getBack scroll able   ,  need to improve
            gridDimension: widget.currentState.gridDimension,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            horizontalDetails: horizontalDetails,
            verticalDetails: verticalDetails,
            delegate: TwoDimensionalChildBuilderDelegate(
              maxXIndex: widget.currentState.maxX,
              maxYIndex: widget.currentState.data.length,
              builder: (context, vicinity) {
                var data =
                    vicinity.xIndex < widget.currentState.data.length &&
                            vicinity.yIndex <
                                widget.currentState.data[vicinity.xIndex].length
                        ? widget.currentState.data[vicinity.xIndex][vicinity
                            .yIndex]
                        : null;
                if (data == null) {
                  return Text(".");
                }
                final child = SizedBox.square(
                  dimension:
                      widget.currentState.gridDimension -
                      20, // the spacing I was having
                  child: IndexViwer(mode: widget.mode, data: data),
                );
                return child;
                return !scrollable
                    ? Draggable<IndexData>(
                      key: ValueKey(data),
                      data: data,
                      feedback: ColoredBox(color: Colors.grey, child: child),
                      childWhenDragging: ColoredBox(
                        color: Colors.green,
                        child: child,
                      ),
                      child: child,
                    )
                    : child;
              },
            ),
          ),
        ),
      ],
    );
  }
}
