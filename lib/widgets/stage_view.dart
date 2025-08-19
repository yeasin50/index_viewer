import 'package:flutter/material.dart';
import 'package:index_viewer/widgets/index_viwer.dart';

import 'stage_actions_view.dart';
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
    final lines = str.split("\n");

    int maxWidth = 0;
    for (final line in lines) {
      if (line.length > maxWidth) {
        maxWidth = line.length;
      }
    }

    List<List<IndexData>> result = [];
    for (int y = 0; y < lines.length; y++) {
      final line = lines[y];
      final List<IndexData> row = [];

      for (int x = 0; x < maxWidth; x++) {
        final item =
            x < line.length
                ? IndexData(
                  char: line[x],
                  idx: x,
                  idy: y,
                  cdx: x,
                  cdy: y,
                  version: 1,
                )
                : IndexData.empty;
        row.add(item);
      }
      result.add(row);
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
  StageAction stageAction = StageAction.scrollabe;

  bool scrollable = true;

  final ScrollController verticalController = ScrollController();
  final ScrollController horizontalController = ScrollController();

  ScrollableDetails get verticalDetails => ScrollableDetails.vertical(
    controller: verticalController,
    physics:
        scrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
  );

  ScrollableDetails get horizontalDetails => ScrollableDetails.horizontal(
    controller: horizontalController,
    physics:
        scrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
  );



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
        StageActionsView(
          stageAction: stageAction,
          onChange: (v) {
            stageAction = v;
            scrollable =  v.isScrollable;
            setState(() {});
          },
        ),
        Expanded(
          child: TwoDimensionalGridView(
            key: ValueKey("two_dimensional_grid"),
            gridDimension: widget.currentState.gridDimension,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            horizontalDetails: horizontalDetails,
            verticalDetails: verticalDetails,
            diagonalDragBehavior:
                stageAction.isScrollable
                    ? DiagonalDragBehavior.free
                    : DiagonalDragBehavior
                        .none, // disable drag when not scrollable
            delegate: TwoDimensionalChildBuilderDelegate(
              maxXIndex: widget.currentState.maxX,
              maxYIndex: widget.currentState.data.length,
              builder: (context, vicinity) {
                var data =
                    vicinity.yIndex < widget.currentState.data.length &&
                            vicinity.xIndex <
                                widget.currentState.data[vicinity.yIndex].length
                        ? widget.currentState.data[vicinity.yIndex][vicinity
                            .xIndex]
                        : null;
                if (data == null || data == IndexData.empty) {
                  return Text(" ");
                }
                final child = SizedBox.square(
                  dimension:
                      widget.currentState.gridDimension -
                      20, // the spacing I was having
                  child: IndexViwer(mode: widget.mode, data: data),
                );
                return stageAction.isArrage
                    ? Draggable<IndexData>(
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
