import 'package:flutter/material.dart';

enum StageAction {
  // when  pick mode
  arrage,

  // just drag mode,  free scroll
  scrollabe;

  bool get isArrage => this == StageAction.arrage;
  bool get isScrollable => this == StageAction.scrollabe;
}

/// actions buttons to decide drag or move items
class StageActionsView extends StatelessWidget {
  const StageActionsView({
    super.key,
    required this.stageAction,
    required this.onChange,
  });

  final StageAction stageAction;
  final ValueChanged<StageAction> onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(stageAction.toString()),
        IconButton(
          onPressed: () {
            onChange(StageAction.scrollabe);
          },
          color: stageAction.isScrollable ? Colors.blueAccent : Colors.grey,
          icon: Icon(Icons.pan_tool),
        ),
        IconButton(
          onPressed: () {
            onChange(StageAction.arrage);
          },
          color: stageAction.isArrage ? Colors.blueAccent : Colors.grey,
          icon: Icon(Icons.ads_click),
        ),
      ],
    );
  }
}
