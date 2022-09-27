import 'package:flutter/material.dart';
import 'package:syncfusion_graph/calender_view/calender_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: CalenderView(),
    );
  }
}
