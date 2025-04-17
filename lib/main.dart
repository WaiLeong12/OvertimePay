import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? selectedRate;
  double bonusRate = 0 ?? 0;
  double calRate = 0 ?? 0;
  double calBonusSalary = 0 ?? 0;
  double totalBonusSalary = 0;

  final TextEditingController empAnnual = TextEditingController();

  void _calculateBonus() {
    double annualSalary = double.tryParse(empAnnual.text)!;
    String? rate = selectedRate;

    setState(() {
      if (rate == 'Rate 1, no bonus') {
        bonusRate = 0;
        calBonusSalary = annualSalary;
      } else if (rate == 'Rate 2, no bonus') {
        bonusRate = 0;
        calBonusSalary = annualSalary;
      } else if (rate == 'Rate 3, 5% bonus') {
        bonusRate = 0.05;
        calRate = annualSalary * bonusRate;
        calBonusSalary = annualSalary + calRate;
      } else if (rate == 'Rate 4, 10% bonus') {
        bonusRate = 0.1;
        calRate = annualSalary * bonusRate;
        calBonusSalary = annualSalary + calRate;
      } else if (rate == 'Rate 5, 15% bonus') {
        bonusRate = 0.15;
        calRate = annualSalary * bonusRate;
        calBonusSalary = annualSalary + calRate;
      } else {
        return;
      }

      setState(() {
        totalBonusSalary = calBonusSalary;
      });
    });
  }

  void _clearInput() {
    empAnnual.clear();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Employee Bonus Calculation'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              const Text('Employee Bonus Calculation'),
              TextField(
                controller: empAnnual,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefix: Icon(Icons.search),
                  suffixIcon: Icon(Icons.clear),
                  label: Text('Enter your salary'),
                  hintText: '5000',
                  helperText: '',
                  border: OutlineInputBorder(),
                ),
              ),
              DropdownButton<String>(
                value: selectedRate,
                hint: const Text('Please select a rate'),
                items: <String>[
                  'Rate 1, no bonus',
                  'Rate 2, no bonus',
                  'Rate 3, 5% bonus',
                  'Rate 4, 10% bonus',
                  'Rate 5, 15% bonus'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRate = newValue;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _calculateBonus,
                child: const Text('Calculate'),
              ),
              Text(
                'Total Salary with Bonus: RM $totalBonusSalary',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
