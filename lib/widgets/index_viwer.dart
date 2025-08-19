import 'package:flutter/material.dart';

///  how the stage will be visible
enum StageMode {
  // - chart at middle
  // - initial index at bottom left
  normal,

  // - index at middle
  // - char at bottom left
  indexChange,
}

class IndexData {
  const IndexData({
    required this.char,
    required this.version,
    required this.idx,
    required this.idy,
    this.cdx = 0,
    this.cdy = 0,
  });

  final String char;
  //initial
  final int idx, idy;
  final int version;
  //current
  final int cdx, cdy;

  static IndexData empty = IndexData(
    char: "",
    idx: 0,
    idy: 0,
    cdx: 0,
    cdy: 0,
    version: 0,
  );

  ///
  IndexData copyWith({String? char, int? idx, idy, cdx, cdy, int? version}) {
    return IndexData(
      char: char ?? this.char,
      idx: idx ?? this.idx,
      idy: idy ?? this.idy,
      cdx: cdx ?? this.cdx,
      cdy: cdy ?? this.cdy,
      version: version ?? this.version,
    );
  }

  @override
  String toString() {
    return 'IndexData(char: $char, initialIndex: ($idx ,$idy), version: $version, currentIndex($cdx,$cdy)';
  }
}

/// show index char with details based on [mode]
///
class IndexViwer extends StatefulWidget {
  const IndexViwer({
    super.key,
    required this.mode,
    required this.data,
    this.onDelete,
  });

  final StageMode mode;
  final IndexData data;

  /// if null it won't show delete button
  final VoidCallback? onDelete;

  @override
  State<IndexViwer> createState() => _IndexViwerState();
}

class _IndexViwerState extends State<IndexViwer> {
  /// something wrong with cache so I have made this stateful
  late IndexData data = widget.data.copyWith();
  @override
  void didUpdateWidget(covariant IndexViwer oldWidget) {
    if (oldWidget.data != data) {
      data = widget.data;
      print("change ... ");
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final idxyStrint = data == IndexData.empty ? "" : "${data.idx}-${data.idy}";
    final texts = switch (widget.mode) {
      StageMode.normal => (primaryText: data.char, smallText: idxyStrint),
      StageMode.indexChange => (primaryText: idxyStrint, smallText: data.char),
    };
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.withAlpha(40)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            Center(child: Text(texts.primaryText, style: textStyle.titleLarge)),
            if (data.version > 1)
              Positioned(
                bottom: 4,
                left: 4,
                child: Text(texts.smallText, style: textStyle.bodyMedium),
              ),
            if (widget.onDelete != null)
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onTap: widget.onDelete,
                  child: Icon(Icons.close, color: Colors.redAccent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
