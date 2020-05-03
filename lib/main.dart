import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Scroll bounds Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final centerKey = GlobalKey(debugLabel: 'centerKey');
const defaultBottomCount = 80;

class _MyHomePageState extends State<MyHomePage> {
  var bottomCount = defaultBottomCount;
  var scrollController = ScrollController(initialScrollOffset: 0);
  var anchor = 0.0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: scrollView,
            ),
            controls,
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Table get controls => Table(
        columnWidths: {
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
          2: FlexColumnWidth(),
          3: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          sizeControl,
          offsetControl,
          anchorControl,
        ],
      );

  TableRow get sizeControl => TableRow(
    children: [
      Text('B Size '),
      Text('$bottomCount'),
      Slider(
        min: 0,
        max: defaultBottomCount.truncateToDouble(),
        value: bottomCount.truncateToDouble(),
        onChanged: (value) {
          bottomCount = value.truncate();
          setState(() {});
        },
      ),
      FlatButton(
        child: Text('Reset'),
        onPressed: () {
          setState(() {
            bottomCount = defaultBottomCount;
          });
        },
      ),
    ],
  );

  TableRow get offsetControl => TableRow(
        children: [
          Text('Offset '),
          Text('${(scrollController.hasClients ? scrollController.offset : 0).toStringAsFixed(2)}'),
          Slider(
            min: -500,
            max: 500,
            value: min(
                scrollController.hasClients ? scrollController.offset : 0, 500),
            onChanged: (value) {
              setState(() {
                scrollController.jumpTo(value);
              });
            },
          ),
          FlatButton(
            child: Text('Reset'),
            onPressed: () {
              setState(() {
                scrollController.jumpTo(0);
              });
            },
          ),
        ],
      );

  TableRow get anchorControl => TableRow(
        children: [
          Text('Anchor '),
          Text('${anchor.toStringAsFixed(2)}'),
          Slider(
            min: 0,
            max: 1,
            value: anchor,
            onChanged: (value) {
              anchor = value;
              setState(() {});
            },
          ),
          FlatButton(
            child: Text('Reset'),
            onPressed: () {
              setState(() {
                anchor = 0;
              });
            },
          ),
        ],
      );

  CustomScrollView get scrollView => CustomScrollView(
        center: centerKey,
        anchor: anchor,
        controller: scrollController,
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Text('T Item ${- index - 1}'),
                childCount: 5),
          ),
          SliverList(
            key: centerKey,
            delegate: SliverChildBuilderDelegate(
                (context, index) => Text('C Item ${index}'),
                childCount: 1),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Text('B Item ${index + 1}'),
                childCount: bottomCount),
          ),
        ],
      );
}
