import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/colors.dart';
import 'package:khoi_shop/consts/my_icons.dart';

class _BarChart extends StatelessWidget {

  List<BarChartGroupData> barGroups;


  _BarChart({required this.barGroups});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        alignment: BarChartAlignment.spaceAround,
        maxY: 260,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: const EdgeInsets.all(0),
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.y.round().toString(),
          const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: SideTitles(
      showTitles: true,
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      margin: 20,
    ),
    leftTitles: SideTitles(showTitles: false),
    topTitles: SideTitles(showTitles: false),
    rightTitles: SideTitles(showTitles: false),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );


  // List<BarChartGroupData> get barGroups  =>  [
  //
  //   BarChartGroupData(
  //     x: 0,
  //     barRods: [
  //       BarChartRodData(
  //           y: 8, colors: [Colors.lightBlueAccent, Colors.greenAccent])
  //     ],
  //     showingTooltipIndicators: [0],
  //   ),
  //   BarChartGroupData(
  //     x: 1,
  //     barRods: [
  //       BarChartRodData(
  //           y: 10, colors: [Colors.lightBlueAccent, Colors.greenAccent])
  //     ],
  //     showingTooltipIndicators: [0],
  //   ),
  //   BarChartGroupData(
  //     x: 2,
  //     barRods: [
  //       BarChartRodData(
  //           y: 14, colors: [Colors.lightBlueAccent, Colors.greenAccent])
  //     ],
  //     showingTooltipIndicators: [0],
  //   ),
  //   BarChartGroupData(
  //     x: 3,
  //     barRods: [
  //       BarChartRodData(
  //           y: 15, colors: [Colors.lightBlueAccent, Colors.greenAccent])
  //     ],
  //     showingTooltipIndicators: [0],
  //   ),
  //   BarChartGroupData(
  //     x: 3,
  //     barRods: [
  //       BarChartRodData(
  //           y: 13, colors: [Colors.lightBlueAccent, Colors.greenAccent])
  //     ],
  //     showingTooltipIndicators: [0],
  //   ),
  //   BarChartGroupData(
  //     x: 3,
  //     barRods: [
  //       BarChartRodData(
  //           y: 10, colors: [Colors.lightBlueAccent, Colors.greenAccent])
  //     ],
  //     showingTooltipIndicators: [0],
  //   ),
  // ];
}

class ChartScreen extends StatefulWidget {
 static const routeName = '/ChartScreen';
  const ChartScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChartScreenState();
}

class ChartScreenState extends State<ChartScreen> {


  List<BarChartGroupData> barGroups = [];
  Future<void> getData() async{
    int x = 0;
    barGroups.clear();
    await FirebaseFirestore.instance
        .collection('orders')
        .get()
        .then((QuerySnapshot ordersSnapshot) {
      ordersSnapshot.docs.forEach((element) {
        barGroups.add(
          BarChartGroupData(
            x: x,
            barRods: [
              BarChartRodData(
                  y: element.get('orderTotal'), colors: [Colors.lightBlueAccent, Colors.greenAccent])
            ],
            showingTooltipIndicators: [0],
          ),

        );
        x++;
      });
    });
  }


  late TextEditingController _searchTextController;
  final FocusNode _node = FocusNode();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
      builder: (context, snapshot) {
        return barGroups == []? CircularProgressIndicator():
        Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: _searchTextController,
                minLines: 1,
                focusNode: _node,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                  ),
                  hintText: 'Search',
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  suffixIcon: IconButton(
                    onPressed: _searchTextController.text.isEmpty
                        ? null
                        : () {
                      _searchTextController.clear();
                      _node.unfocus();
                    },
                    icon: Icon(MyAppIcons.times,
                        color: _searchTextController.text.isNotEmpty
                            ? Colors.red
                            : Colors.grey),
                  ),
                ),
                onChanged: (value) {
                  _searchTextController.text.toLowerCase();
                  setState(() {

                  });
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.5,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  color: const Color(0xff2c4260),
                  child: _BarChart(barGroups: barGroups,),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() {
      setState(() {});
    });
  }
}