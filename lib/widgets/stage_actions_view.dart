import 'package:flutter/material.dart';

enum StageAction {
  drag,
  move;

  bool get isDraggable => this == StageAction.drag;
}

/// actions buttons to decide drag or move items
class StageActionsView extends StatefulWidget {
  const StageActionsView({
    super.key,
    this.stageAction = StageAction.drag,
    required this.onChange,
  });

  final StageAction stageAction;
  final ValueChanged<StageAction> onChange;

  @override
  State<StageActionsView> createState() => _StageActionsViewState();
}

class _StageActionsViewState extends State<StageActionsView> {
  late bool scrollable = widget.stageAction == StageAction.drag ? false : true;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            widget.onChange(StageAction.drag);
            scrollable = true;
            setState(() {});
          },
          color: !scrollable ? Colors.grey : Colors.blueAccent,
          icon: Icon(Icons.ads_click),
        ),
        IconButton(
          onPressed: () {
            widget.onChange(StageAction.move);
            scrollable = false;
            setState(() {});
          },
          color: scrollable ? Colors.grey : Colors.blueAccent,
          icon: Icon(Icons.pan_tool),
        ),
      ],
    );
  }
}
