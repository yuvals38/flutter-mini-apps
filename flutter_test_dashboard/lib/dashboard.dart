//import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:charts_flutter/src/text_element.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';

  String labeltype;
  String resultstype;

  List<String> machines = ['3023', '3020', '3025', '8001','8004'];
  String _selectedMachine;
  String _versions;
  List<String> versions = ['1.0.0.10','4.6.0.9','4.1.16.5','4.6.0.106'];

  String _fromdate = "Not set";
  String _todate = "Not set";




class Dashboard extends StatefulWidget{
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

/*ScrollController scrollController;
///The controller of sliding up panel
SlidingUpPanelController panelController = SlidingUpPanelController();
 @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.expand();
      } else if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.anchor();
      } else {}
    });
    super.initState();
  }
*/

var data = [0.0,1.0,1.5,2.0,0.0,-0.5,-1.0,-0.5,0.0,0.0];

final Map<String, double> someMap = {
  "Ink": 100,
  "Hours": 20,
  "People": 2,
};

  String name = '';
  String numberOfSheets;
  String inkConsumption;
  String  totalWorkingHours;

  static List<dynamic> labels;
  static List<dynamic> datainfo;

Material myChartItems(String title, String priceVal, String subtitle){
  return Material( 
    color: Colors.white,
    elevation: 14.0,
    borderRadius: BorderRadius.circular(24.0),
    shadowColor: Color(0x802196F3),
    child: Center(  
      child: Padding(  
        padding: EdgeInsets.all(8.0),
        child: Row(  
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(  
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(  
                  padding: EdgeInsets.all(1.0),
                  child: Text(title, style: TextStyle(fontSize: 20.0, color: Colors.blueAccent)),
                ),
                 Padding(  
                  padding: EdgeInsets.all(1.0),
                  child: Text(priceVal, style: TextStyle(fontSize: 30.0, color: Colors.blueAccent)),
                 ),
                  Padding(  
                  padding: EdgeInsets.all(1.0),
                  child: Text(subtitle, style: TextStyle(fontSize: 20.0, color: Colors.blueGrey)),
                  ),
                  //graph
                  Padding(  
                  padding: EdgeInsets.all(1.0),
                  child: new Sparkline(  
                    data: data,
                    lineColor: Color(0xffff6101),
                    pointsMode: PointsMode.all,
                    pointSize: 8.0 
                  ),
                  ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}


Material myChartItemsColorBelow(String title, String priceVal, String subtitle){
  return Material( 
    color: Colors.white,
    elevation: 14.0,
    borderRadius: BorderRadius.circular(24.0),
    shadowColor: Color(0x802196F3),
    child: Center(  
      child: Padding(  
        padding: EdgeInsets.all(8.0),
        child: Row(  
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(  
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(  
                  padding: EdgeInsets.all(1.0),
                  child: Text(title, style: TextStyle(fontSize: 20.0, color: Colors.blueAccent)),
                ),
                 Padding(  
                  padding: EdgeInsets.all(1.0),
                  child: Text(priceVal, style: TextStyle(fontSize: 30.0, color: Colors.blueAccent)),
                 ),
                  Padding(  
                  padding: EdgeInsets.all(1.0),
                  child: Text(subtitle, style: TextStyle(fontSize: 20.0, color: Colors.blueGrey)),
                  ),
                  //graph
                  Padding(  
                  padding: EdgeInsets.all(1.0),
                  child: new Sparkline(  
                    data: data,
                    fillMode: FillMode.below,
                    fillGradient: new LinearGradient( 
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.amber[800],Colors.amber[200]],
                    ),
                  ),
                  ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Material myChartItemsPie(String title, String priceVal, String subtitle){
  return Material( 
    color: Colors.white,
    elevation: 14.0,
    borderRadius: BorderRadius.circular(24.0),
    shadowColor: Color(0x802196F3),
    child: Center(  
      child: Padding(  
        padding: EdgeInsets.all(8.0),
        child: Row(  
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(  
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(  
                  padding: EdgeInsets.all(1.0),
                  child: Text(title, style: TextStyle(fontSize: 20.0, color: Colors.blueAccent)),
                ),
                 Padding(  
                  padding: EdgeInsets.all(1.0),
                  child: Text(priceVal, style: TextStyle(fontSize: 30.0, color: Colors.blueAccent)),
                 ),
                  Padding(  
                  padding: EdgeInsets.all(1.0),
                  child: Text(subtitle, style: TextStyle(fontSize: 20.0, color: Colors.blueGrey)),
                  ),
                  //graph
                  Padding(  
                  padding: EdgeInsets.all(1.0),
                  child: new PieChart(
                    dataMap: someMap,
                  
                    legendFontColor: Colors.blueGrey[900],
                    legendFontSize: 14.0,
                    legendFontWeight: FontWeight.w500,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32.0,
                    chartRadius: MediaQuery.of(context).size.width / 2.7,
                    showChartValuesInPercentage: true,
                    showChartValues: true,
                    showChartValuesOutside: false,
                    chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
                    //colorList: colorList,
                    showLegends: true,
                    decimalPlaces: 1,
                    showChartValueLabel: true,
                    chartValueFontSize: 12,
                    chartValueFontWeight: FontWeight.bold,
                    chartValueLabelColor: Colors.grey[200],
                    initialAngle: 0,

                  ),
                      
                       
                    //data: data,
                    //fillMode: FillMode.below,
                    //fillGradient: new LinearGradient( 
                     // begin: Alignment.topCenter,
                      //end: Alignment.bottomCenter,
                      //colors: [Colors.amber[800],Colors.amber[200]],
                    //),
                  //),
                  ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Material myItems(IconData icon, String heading, int color){
  return Material(
    color:Colors.white,
    elevation: 14.0,
    //shadowColor: Color(0x802196F3),
    borderRadius: BorderRadius.circular(24.0),
    child: Center(  
      child: Padding(  
        padding: const EdgeInsets.all(8.0),
        child: Row(  
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(  
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                //text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(heading, 
                  style: TextStyle(  
                    color:new  Color(color),
                    fontSize: 20.0,
                   ),
                  ),
                ),

                //icon / graph
               
                Material(  
                  color: new Color(color),
                  borderRadius:  BorderRadius.circular(24.0),
                  child: Padding(  
                    padding: const EdgeInsets.all(16.0),
                    child:// createChart(),
                    
                    Icon(  
                      icon,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  )
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

// Expanded(
                //child: charts.BarChart(_createSampleData(), animate: true),
              //)

Container barchart(){
return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
               "Sales",
                style: Theme.of(context).textTheme.body2,
              ),
              Expanded(
                child: charts.BarChart(_createSampleData(), animate: true),
              )
            ],
          ),
        ),
      )
    );
}
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(  
        title: Text('Scodix Dashboard',
          style: TextStyle( 
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.devices),
            onPressed: () {
              //list up
             
            },
          ),
        ],
      ),
      
      

      body: StaggeredGridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      
      padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
        children: <Widget>[
            barchart(),
            myChartItems("Prints by Month", "100.301", "10% target"),
            myItems(Icons.graphic_eq,"TotalViews",0xffed622b),
            myItems(Icons.bookmark,"BookMark",0xff26cb3c),
            myItems(Icons.notifications,"Notification",0xffff3266),
            myItems(Icons.attach_money,"Balance",0xff3399fe),
            
           // myItems(Icons.settings,"Settings",0xfff4c83f),
            myChartItemsPie("Pages by Month", "3200", "15% target"),
            myChartItemsColorBelow("Pages by Month", "3200", "15% target"),
            _scrollingList(),
         
        ],
        staggeredTiles: [
          StaggeredTile.extent(4,250.0),
          StaggeredTile.extent(4,250.0),
          StaggeredTile.extent(2,150.0),
          StaggeredTile.extent(2,150.0),
          StaggeredTile.extent(2,150.0),
          StaggeredTile.extent(2,150.0),
          StaggeredTile.extent(4,300.0),
          StaggeredTile.extent(5,250.0),
          StaggeredTile.extent(5,250.0),
        ],

       
      ),

       
      //bottomnav
       bottomNavigationBar: BottomNavigationBar(
       currentIndex: 0, // this will be set when a new tab is tapped
       items: [
         BottomNavigationBarItem(
           icon: new Icon(Icons.assessment),
           title: new Text('Today'),
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.timeline),
           title: new Text('Analysis'),
         ),
        
       ],
     
     ),

    );

    
       
  }

Widget _scrollingList(){
  return Container(
    //adding a margin to the top leaves an area where the user can swipe
    //to open/close the sliding panel
    margin: const EdgeInsets.only(top: 36.0),

    color: Colors.white,
    child: ListView.builder(
      itemCount: 50,
      itemBuilder: (BuildContext context, int i){
        return Container(
          padding: const EdgeInsets.all(12.0),
          child: Text("$i"),
        );
      },
    ),
  );
}
//get data json
getData(machinename,version,startdate,enddate,starttime,endtime) async{
    String url = 'http://scodixreports.azurewebsites.net/api/Reports';
    Map data = {
    "machineName":machinename,"swVersion":version,"startDate":startdate,"endDate":enddate,"startTime":starttime,"endTime":endtime,
    };

    

    var body = json.encode(data);

    var res =await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body);
      
    var resBody = json.decode(res.body);
    name = resBody['title'];
    numberOfSheets = resBody['numberOfSheets'];
    inkConsumption = resBody['inkConsumption'];
    totalWorkingHours = resBody['totalWorkingHours'];

    labels = resBody['labels'];
    datainfo = resBody['data'];

    

    setState(() {
      print("Success");
    });
  }
/*
Widget createChart()
{
  try{
  return new charts.BarChart(
    
                _createSampleData(),
                
                animate: true,
                defaultInteractions: true,
                barGroupingType: charts.BarGroupingType.grouped,
                behaviors: [
                  LinePointHighlighter(
                    symbolRenderer: CustomCircleSymbolRenderer()
                  )
                ],
                selectionModels: [
                  SelectionModelConfig(
                    changedListener: (SelectionModel model) {
                      if(model.hasDatumSelection)
                        labeltype = model.selectedSeries[0].domainFn(model.selectedDatum[0].index);
                        resultstype = model.selectedSeries[0].measureFn(model.selectedDatum[0].index).toString();
                        print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
                        print(model.selectedSeries[0].domainFn(model.selectedDatum[0].index));
                    }
                  )
                ],
              );
  }
  catch(e){

  }
}
*/

/// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
      if(labels != null)
      {
          final data = [

            new OrdinalSales(labels[0], datainfo[0]),
            new OrdinalSales(labels[1], datainfo[1]),
            new OrdinalSales(labels[2], datainfo[2]),
            new OrdinalSales(labels[3], datainfo[3]),
            new OrdinalSales(labels[4], datainfo[4]),
            new OrdinalSales(labels[5], datainfo[5]),
           /* new OrdinalSales(labels[6], datainfo[6]),
            new OrdinalSales(labels[7], datainfo[7]),
            new OrdinalSales(labels[8], datainfo[8]),
            new OrdinalSales(labels[9], datainfo[9]),
            new OrdinalSales(labels[10], datainfo[10]),*/

            
          ];
      
          return [
            new charts.Series<OrdinalSales, String>(
              id: 'labels',
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (OrdinalSales sales, _) => sales.label,
              measureFn: (OrdinalSales sales, _) =>  sales.datainfoitem,
              //measureFormatterFn: (OrdinalSales sales, _) =>  sales.datainfoitem.toString(),
              //measureOffsetFn: (OrdinalSales sales, _) => sales.datainfoitem,
              
              data: data,
            )
          ];
      }
      else
      {
       final data = [

            new OrdinalSales('labels[0]', 10.5),
            new OrdinalSales('labels[1]', 50.4),
            new OrdinalSales('labels[2]', 130.4),
            //new OrdinalSales('labels[3]', 28.7),
            //new OrdinalSales('labels[4]', 75.3),
            //new OrdinalSales('labels[5]', 97.2),
           /* new OrdinalSales(labels[6], datainfo[6]),
            new OrdinalSales(labels[7], datainfo[7]),
            new OrdinalSales(labels[8], datainfo[8]),
            new OrdinalSales(labels[9], datainfo[9]),
            new OrdinalSales(labels[10], datainfo[10]),*/

            
          ];
      
          return [
            new charts.Series<OrdinalSales, String>(
              id: 'labels',
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (OrdinalSales sales, _) => sales.label,
              measureFn: (OrdinalSales sales, _) =>  sales.datainfoitem,
              //measureFormatterFn: (OrdinalSales sales, _) =>  sales.datainfoitem.toString(),
              //measureOffsetFn: (OrdinalSales sales, _) => sales.datainfoitem,
              
              data: data,
            )
          ];
      }
  }




}

/// Sample ordinal data type.
class OrdinalSales {
  final String label;
  final double datainfoitem;

  OrdinalSales(this.label, this.datainfoitem);
}
/*
class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds, {List<int> dashPattern, Color fillColor, Color strokeColor, double strokeWidthPx}) {
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor, strokeColor: strokeColor, strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
      Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10, bounds.height + 10),
      fill: Color.white
    );
    var textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;
    canvas.drawText(
      TextElement(labeltype + ": " + resultstype, style: textStyle),
        (bounds.left).round(),
        (bounds.top - 28).round()
    );
  }
}*/