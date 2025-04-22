import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController workedHourCtrl = TextEditingController();
  String? workTime;
  String? workHour;
  double? totalPay;
  List<String> totalPaid = [];

  void _calculateWorkingHour(){
    double workhour = double.tryParse(workedHourCtrl.text)!;
    double regularHourRate = 15 * workhour;
    double overtimeHourRate = (15 * 1.5) * workhour;

    if(workhour == null){
      setState(() {
        workHour = 'Please enter your worked hour!';
        workhour = 0;
      });
    }

    setState(() {
      if(workhour <= 40){
        workTime = 'You worked regularly';
        regularHourRate = 15 * workhour;
        totalPay = regularHourRate;
      }
      else if(workhour > 40){
        workTime = 'You worked regularly';
        overtimeHourRate = (15 * 1.5) * workhour;
        totalPay = regularHourRate + overtimeHourRate;
      }
      else{
        return;
      }
    });

    setState(() {
      totalPay.toString();
    });
  }


  Future<void> _saveTotalPaid() async {
    _calculateWorkingHour();
    final prefs = await SharedPreferences.getInstance();
    String? encodeCart = jsonEncode(totalPaid);
    await prefs.setString('Paid', encodeCart);
    Text('Total Paid: $totalPaid');
  }

  Future<void> _loadTotalPaid() async{
    _saveTotalPaid();
    final prefs = await SharedPreferences.getInstance();
    String? encodeCart = prefs.getString('Paid');
    if(encodeCart != null){
      List<dynamic> decodedList = jsonDecode(encodeCart);
      totalPaid = List<String>.from(decodedList);
      for(int i = 0; i < totalPaid.length; i++){
        Text('Total Paid Loaded: ${totalPaid[i]}');

      }
    }
  }

  //Add total paid to cart
  void _addTotalPaid(String paidList){
    totalPaid.add(paidList);
    _saveTotalPaid();
  }

  Future<void> _clearPaidList() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('Paid');
    totalPaid.clear();
    const Text('Total Paid cleared');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Overtime Pay'),
          backgroundColor: Colors.green,
        ),
        body:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              const Text('Worked hour: '),
              TextField(
                keyboardType: TextInputType.number,
                controller: workedHourCtrl,
                decoration: const InputDecoration(
                  prefix: Icon(Icons.search),
                  suffixIcon: Icon(Icons.clear),
                  label: Text('Enter your worked hour.'),
                  hintText: '',
                  helperText: '',
                  border: OutlineInputBorder(),
                ),
              ),

              ElevatedButton(
                  onPressed: _calculateWorkingHour,
                  child: const Text('Calculate')
              ),

              Text(
                'Your total paid is:  RM $totalPay',
              ),

              ElevatedButton(
                  onPressed: _saveTotalPaid,
                  child: const Text('Save your total paid')
              ),

              ElevatedButton(
                  onPressed: _loadTotalPaid,
                  child: const Text('Load your total paid')
              ),

              ElevatedButton(
                  onPressed: _clearPaidList,
                  child: const Text('Clear your total paid')
              ),
            ],
          ),
        ),
      ),
    );
  }
}


