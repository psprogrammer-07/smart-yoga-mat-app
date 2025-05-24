import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressTrackingScreen extends StatefulWidget {
  const ProgressTrackingScreen({super.key});

  @override
  State<ProgressTrackingScreen> createState() => _ProgressTrackingScreenState();
}

enum TimePeriod { week, month, year }

class _ProgressTrackingScreenState extends State<ProgressTrackingScreen> {
  TimePeriod _selectedPeriod = TimePeriod.week;

  // Sample data - replace with actual data fetching logic
  List<FlSpot> _getSampleData(TimePeriod period) {
    switch (period) {
      case TimePeriod.week:
        return [
          const FlSpot(0, 10), // Mon
          const FlSpot(1, 30), // Tue
          const FlSpot(2, 25), // Wed
          const FlSpot(3, 20), // Thu
          const FlSpot(4, 40), // Fri
          const FlSpot(5, 50), // Sat
          const FlSpot(6, 50), // Sun
        ];
      case TimePeriod.month:
        // Replace with actual monthly data
        return List.generate(30, (index) => FlSpot(index.toDouble(), (index % 7 + 1) * 5.0 + (index/7)*2));
      case TimePeriod.year:
        // Replace with actual yearly data
        return List.generate(12, (index) => FlSpot(index.toDouble(), (index % 4 + 1) * 10.0 + index * 3));
    }
  }

  String _getBottomTitle(double value, TimePeriod period) {
    switch (period) {
      case TimePeriod.week:
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return days[value.toInt() % days.length];
      case TimePeriod.month:
        return (value.toInt() + 1).toString(); // Day of month
      case TimePeriod.year:
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return months[value.toInt() % months.length];
    }
  }

  @override
  Widget build(BuildContext context) {
    final spots = _getSampleData(_selectedPeriod);
    final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 10;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light background
     
      body: SafeArea(
        
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA), // Match scaffold background or a slightly different light shade
          ),
          
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  
                  alignment: Alignment.topLeft,
                  child: Text('Track Your Progress \n Seamlessly ', 
                  style: TextStyle(color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold))
                  
                  ),
               
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white, // Light container for the chart
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: LineChart(
                      LineChartData(
                        maxY: maxY,
                        minY: 0,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          getDrawingHorizontalLine: (value) {
                            return const FlLine(
                              color: Color(0xFFDEE2E6), // Lighter grid lines
                              strokeWidth: 1,
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return const FlLine(
                              color: Color(0xFFDEE2E6), // Lighter grid lines
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  meta: meta,
                                 
                                  space: 8.0,
                                  child: Text(_getBottomTitle(value, _selectedPeriod), style: const TextStyle(color: Color(0xFF495057), fontWeight: FontWeight.bold, fontSize: 12)), // Darker text for titles
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                if (value % (maxY/5).floor() == 0 || value == maxY.floor() || value == 0) {
                                   return Text(value.toInt().toString(), style: const TextStyle(color: Color(0xFF495057), fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.left); // Darker text for titles
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: const Color(0xFFDEE2E6), width: 1), // Lighter border
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7E57C2), Color(0xFF5C6BC0)], // Light purple/blue gradient
                            ),
                            barWidth: 5,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(
                              show: true,
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [const Color(0xFF7E57C2).withOpacity(0.1), const Color(0xFF5C6BC0).withOpacity(0.2)],
                              ),
                            ),
                          ),
                          
                        ],
                        
                       
  lineTouchData: LineTouchData(
    touchTooltipData: LineTouchTooltipData(
    getTooltipColor: (touchedSpot) => Colors.deepPurpleAccent, // Remove or comment out getTooltipColor if it conflicts,
      // getTooltipColor: (touchedSpot) => Colors.deepPurpleAccent, // Remove or comment out getTooltipColor if it conflicts
      getTooltipItems: (touchedSpots) {
        return touchedSpots.map((touchedSpot) {
          // Determine the label based on the selected period
          String label;
          if (_selectedPeriod == TimePeriod.week) {
             const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
             label = '${days[touchedSpot.x.toInt() % days.length]}: ${touchedSpot.y.toInt()}';
          } else if (_selectedPeriod == TimePeriod.month) {
             label = 'Day(${touchedSpot.x.toInt() + 1}) :  ${touchedSpot.y.toInt()}';
          } else {
             const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
             label = '${months[touchedSpot.x.toInt() % months.length]}: ${touchedSpot.y.toInt()}';
          }

          return LineTooltipItem(
            label,
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w900), // Ensure white text color
          );
        }).toList();
      },
    ),
  ),
  // other chart properties



                        
                      ),
                      
                    ),

                    
                    
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ToggleButtons(
                    borderColor: const Color(0xFFBDBDBD), // Light grey border
                    fillColor: const Color(0xFF7E57C2).withOpacity(0.8), // Accent color for selected fill
                    borderWidth: 1,
                    selectedBorderColor: const Color(0xFF7E57C2), // Accent color for selected border
                    selectedColor: Colors.white, // White text for selected
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF495057), // Darker text for unselected
                    constraints: BoxConstraints(minHeight: 40.0, minWidth: (MediaQuery.of(context).size.width - 48) / TimePeriod.values.length), // Adjusted for padding
                    isSelected: TimePeriod.values.map((period) => _selectedPeriod == period).toList(),
                    onPressed: (int index) {
                      setState(() {
                        _selectedPeriod = TimePeriod.values[index];
                      });
                    },
                    children: TimePeriod.values.map((period) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(period.name[0].toUpperCase() + period.name.substring(1), style: const TextStyle(fontSize: 16 /* Style color is handled by ToggleButtons selectedColor/color */)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}