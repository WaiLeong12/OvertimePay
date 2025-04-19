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
  TextEditingController loanAmountCtrl = TextEditingController();
  TextEditingController netIncomeCtrl = TextEditingController();
  TextEditingController loanInterestCtrl = TextEditingController();
  int? selectedItem;
  bool? isGuarantorChecked = false;
  String? selectedCarType;
  double totalRepayment = 0;
  bool? eligible;
  double totalInterest = 0;
  String? loanApplicationResult;

  bool isInterestRateValid(){
    double? interest = double.tryParse(loanInterestCtrl.text);
    if(interest == null || selectedCarType == null){
      return false;
    }

    if(selectedCarType == 'New'){
      return interest >= 2.5 && interest <= 3.2;
    }
    else if(selectedCarType == 'Used'){
      return interest >= 2.5 && interest <= 3.2;
    }else{
      return false;
    }
  }


  void _calculateInterest(){
    double loan = double.tryParse(loanAmountCtrl.text)!;
    double interest = double.tryParse(loanInterestCtrl.text)!;
    int loanPeriod = selectedItem!;

    totalInterest = loan * (interest / 100) * loanPeriod;

    setState(() {
      totalInterest.toString();
    });
  }

  void _calculateRepayment(){
    double? loan = double.tryParse(loanAmountCtrl.text);
    double? netIncome = double.tryParse(netIncomeCtrl.text);
    double? interest = double.tryParse(loanInterestCtrl.text);
    int loanPeriod = selectedItem!;
    bool? guarantor = isGuarantorChecked;

    if (loan == null || netIncome == null || interest == null || loanPeriod == null || selectedCarType == null) {
      setState(() {
        loanApplicationResult = 'Please fill in all fields correctly.';
        totalRepayment = 0;
        eligible = false;
      });
      return;
    }

    if(!isInterestRateValid()){
      setState(() {
        loanApplicationResult = 'Invalid interest rate for selected car type!';
        totalRepayment = 0;
        eligible = false;
      });
      return;
    }

    _calculateInterest();

    totalRepayment = (loan + totalInterest) / (loanPeriod * 12);

    setState(() {
      if(totalRepayment <= (0.3 * netIncome)){
        eligible = true;
        loanApplicationResult = 'Eligible, You passed your loan application.';
      }
      else if(totalRepayment > (0.3 * netIncome) && guarantor == true){
        eligible = true;
        loanApplicationResult = 'Eligible(with guarantor), You passed your loan application.';
      }
      else if(totalRepayment > (0.3 * netIncome) && guarantor == false){
        eligible = false;
        loanApplicationResult = 'not Eligible, You failed the loan application.';
      }else{
        return;
      }
    });

    setState(() {
      loanApplicationResult.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: const Text('Car Loan'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              const Text('Loan Amount'),
              TextField(
                controller: loanAmountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefix: Icon(Icons.search),
                  suffixIcon: Icon(Icons.clear),
                  label: Text('Enter your loan amount'),
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const Text('Net Income'),
              TextField(
                controller: netIncomeCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefix: Icon(Icons.search),
                  suffixIcon: Icon(Icons.clear),
                  label: Text('Enter your net income'),
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),

              DropdownButton<int>(
                value: selectedItem,
                hint: const Text('Select loan period(Year)'),
                items: <int>[1, 2, 3, 4, 5].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedItem = newValue;
                  });
                },
              ),

              const Text('Interest Rate'),
              TextField(
                controller: loanInterestCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefix: Icon(Icons.search),
                  suffixIcon: Icon(Icons.clear),
                  label: Text('Enter your interest Rate'),
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),

              CheckboxListTile(
                title: const Text('I have a guarantor'),
                value: isGuarantorChecked,
                onChanged: (bool? newValue) {
                  setState(() {
                    isGuarantorChecked = newValue ?? false;
                  });
                },
              ),

              RadioListTile(
                title: const Text('New'),
                  value: 'New',
                  groupValue: selectedCarType,
                  onChanged: (newValue){
                    setState(() {
                      selectedCarType = newValue.toString();
                    });
                  },
              ),

              RadioListTile(
                title: const Text('Used'),
                value: 'Used',
                groupValue: selectedCarType,
                onChanged: (newValue){
                  setState(() {
                    selectedCarType = newValue.toString();
                  });
                },
              ),

              Text(
                'Repayment : RM $totalRepayment',
              ),

              Text(
                'Eligibility : $loanApplicationResult',
              ),

              ElevatedButton(
                  onPressed: _calculateRepayment,
                  child: const Text('Calculate'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
