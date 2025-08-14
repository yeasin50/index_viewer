import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

/// yap from  my game_of_life
/// Create a grid view on TwoDimensionalScrollView
///
/// ```dart
///  TwoDimensionalGridView(
///   gridDimension: 20,
///   diagonalDragBehavior: DiagonalDragBehavior.free,
///   cacheExtent: 500,
///   delegate: TwoDimensionalChildBuilderDelegate(
///     maxXIndex: 130,
///     maxYIndex: 130,
///     builder: (context, vicinity) {
///       return Container(
///         height: 20,
///         width: 20,
///         color: Colors.primaries[(vicinity.xIndex + vicinity.yIndex) % Colors.primaries.length],
///         alignment: Alignment.center,
///         child: Text(
///           vicinity.toString(),
///         ),
///       );
///     },
///   ),
/// ),
/// ```
///
class TwoDimensionalGridView extends TwoDimensionalScrollView {
  const TwoDimensionalGridView({
    super.key,
    required super.delegate,
    required this.gridDimension,
    super.primary,
    super.mainAxis = Axis.vertical,
    super.verticalDetails = const ScrollableDetails.vertical(),
    super.horizontalDetails = const ScrollableDetails.horizontal(),
    super.cacheExtent,
    super.diagonalDragBehavior = DiagonalDragBehavior.none,
    super.dragStartBehavior = DragStartBehavior.start,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.clipBehavior = Clip.hardEdge,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
  });

  /// actual size of each  grid
  final double gridDimension;

  final double crossAxisSpacing;
  final double mainAxisSpacing;
  

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
  ) {
    return TwoDimensionalGridViewPort(
      gridDimension: gridDimension,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
      verticalOffset: verticalOffset,
      verticalAxisDirection: AxisDirection.down,
      horizontalAxisDirection: AxisDirection.right,
      horizontalOffset: horizontalOffset,
      delegate: delegate,
      mainAxis: mainAxis,
    );
  }
}

class TwoDimensionalGridViewPort extends TwoDimensionalViewport {
  const TwoDimensionalGridViewPort({
    super.key,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.delegate,
    required super.mainAxis,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
    required this.gridDimension,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
  });

  /// actual size of each  grid
  final double gridDimension;

  final double crossAxisSpacing;
  final double mainAxisSpacing;

  @override
  RenderTwoDimensionalViewport createRenderObject(BuildContext context) {
    return RenderTreeViewPostT(
      gridDimension: gridDimension,
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalAxisDirection,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalAxisDirection,
      delegate: delegate,
      mainAxis: mainAxis,
      childManager: context as TwoDimensionalChildManager,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderTwoDimensionalViewport renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
  }
}

class RenderTreeViewPostT extends RenderTwoDimensionalViewport {
  RenderTreeViewPostT({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.delegate,
    required super.mainAxis,
    required super.childManager,
    required this.gridDimension,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
  });

  /// actual size of each  grid
  final double gridDimension;

  final double crossAxisSpacing;
  final double mainAxisSpacing;

  @override
  void layoutChildSequence() async {
    final double horizontalPixels = horizontalOffset.pixels;
    final double verticalPixels = verticalOffset.pixels;

    final viewPortWidth = viewportDimension.width + cacheExtent;
    final viewPortHeight = viewportDimension.height + cacheExtent;

    final TwoDimensionalChildBuilderDelegate builderDelegate =
        delegate as TwoDimensionalChildBuilderDelegate;

    final int maxRowIndex = builderDelegate.maxYIndex!;
    final int maxColIndex = builderDelegate.maxXIndex!;

    final int leadingColumn = math.max(
      (horizontalPixels / (gridDimension + mainAxisSpacing)).floor(),
      0,
    );
    final int leadingRow = math.max(
      (verticalPixels / (gridDimension + crossAxisSpacing)).floor(),
      0,
    );

    final int trailingColumn = math.min(
      ((horizontalPixels + viewPortWidth) / (gridDimension + mainAxisSpacing))
          .ceil(),
      maxColIndex,
    );
    final int trailingRow = math.min(
      ((verticalPixels + viewPortHeight) / (gridDimension + crossAxisSpacing))
          .ceil(),
      maxRowIndex,
    );

    /// actuall layout
    double xLayoutOffset =
        (leadingColumn * (gridDimension + mainAxisSpacing)) - horizontalPixels;

    for (int x = leadingColumn; x < trailingColumn; x++) {
      double yLayoutOffset =
          (leadingRow * (gridDimension + crossAxisSpacing)) - verticalPixels;

      for (int y = leadingRow; y < trailingRow; y++) {
        final ChildVicinity childVicinity = ChildVicinity(xIndex: x, yIndex: y);
        final RenderBox child = buildOrObtainChildFor(childVicinity)!;
        child.layout(constraints.loosen());

        parentDataOf(child).layoutOffset = Offset(xLayoutOffset, yLayoutOffset);
        yLayoutOffset += gridDimension + crossAxisSpacing;
      }
      xLayoutOffset += gridDimension + mainAxisSpacing;
    }

    final double verticalExtent =
        gridDimension * (maxRowIndex * 1.0) +
        (maxRowIndex - 1) * crossAxisSpacing; // size + N-1 spacing

    verticalOffset.applyContentDimensions(
      0,
      (verticalExtent - viewportDimension.height).clamp(0, double.infinity),
    );

    final double horizontalExtent =
        gridDimension * (maxColIndex * 1) +
        (maxColIndex - 1) * crossAxisSpacing;

    horizontalOffset.applyContentDimensions(
      0,
      (horizontalExtent - viewportDimension.width).clamp(0, double.infinity),
    );
  }
}
