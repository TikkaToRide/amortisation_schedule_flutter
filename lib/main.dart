import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Amortisation Schedule'),
          backgroundColor: Colors.grey[700],
        ),
        body: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  //final _clientName = TextEditingController(Text: 'Initial Value');
  //final _financeCompany = TextEditingController();
  //final _assetPurchased = TextEditingController();
  final _date = TextEditingController();
  final _principalAmount = MoneyMaskedTextController(
      leftSymbol: '\$', decimalSeparator: '.', thousandSeparator: ',');
  final _paymentAmount = MoneyMaskedTextController(
      leftSymbol: '\$', decimalSeparator: '.', thousandSeparator: ',');
  final _numberOfYears = TextEditingController();
  final _lumpSumAmount = TextEditingController();

  TextEditingController _clientName, _financeCompany, _assetPurchased;
  var paymentsPerYear;
  var lumpSumType;

  @override
  void initState() {
    _clientName = TextEditingController();
    _financeCompany = TextEditingController();
    _assetPurchased = TextEditingController();
    super.initState();
    /*_clientName.addListener(() {});
    _financeCompany.addListener(() {});
    _assetPurchased.addListener(() {});
    _date.addListener(() {});
    _paymentAmount.addListener(() {});
    _paymentAmount.addListener(() {});
    _numberOfYears.addListener(() {});*/
  }

  @override
  void dispose() {
    _clientName.dispose();
    _financeCompany.dispose();
    _assetPurchased.dispose();
    _date.dispose();
    _principalAmount.dispose();
    _paymentAmount.dispose();
    _numberOfYears.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                    controller: _clientName,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Client Name',
                        contentPadding: EdgeInsets.all(20))),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                    controller: _financeCompany,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Finance Company',
                        contentPadding: EdgeInsets.all(20))),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                    controller: _assetPurchased,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Asset Purchased',
                        contentPadding: EdgeInsets.all(20))),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: DateTimePicker(
                    type: DateTimePickerType.date,
                    dateMask: 'dd/MM/yyyy',
                    controller: _date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Date of First Payment',
                        suffixIcon: Icon(Icons.date_range),
                        contentPadding: EdgeInsets.all(20))),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                    controller: _principalAmount,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Principal Amount',
                        contentPadding: EdgeInsets.all(20))),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                    controller: _paymentAmount,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Payment Amount',
                        contentPadding: EdgeInsets.all(20))),
              ),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                        controller: _numberOfYears,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Term',
                            contentPadding: EdgeInsets.all(20))),
                  ),
                ),
                Container(
                  //I want to add border to this to make look like other fields
                  /*child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),*/
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: DropdownButton<int>(
                      items: [
                        DropdownMenuItem<int>(
                          child: Text('Yearly'),
                          value: 1,
                        ),
                        DropdownMenuItem<int>(
                          child: Text(
                              'Quarterly'), //THIS DOES NOT CALCULATED CORRECTLY
                          value: 4,
                        ),
                        DropdownMenuItem<int>(
                          child: Text('Monthly'),
                          value: 12,
                        ),
                        DropdownMenuItem<int>(
                          child: Text('Weekly'),
                          value: 52,
                        ),
                      ],
                      onChanged: (int value) {
                        setState(() {
                          paymentsPerYear = value;
                        });
                      },
                      hint: Text('Payments Per Year'),
                      value: paymentsPerYear,
                      //contentPadding: EdgeInsets.all(18)),),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                        controller: _lumpSumAmount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Lump Sum Amount',
                            contentPadding: EdgeInsets.all(20))),
                  ),
                ),
                Container(
                  //I want to add border to this to make look like other fields
                  /*child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),*/
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: DropdownButton<int>(
                      items: [

                        DropdownMenuItem<int>(
                          child: Text('Up Front'),
                          value: 101,
                        ),
                        DropdownMenuItem<int>(
                          child: Text('Balloon'),
                          value: 102,
                        ),
                      ],
                      onChanged: (int value) {
                        setState(() {
                          lumpSumType = value;
                        });
                      },
                      hint: Text('None'),
                      value: lumpSumType,
                      //contentPadding: EdgeInsets.all(18)),),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_principalAmount.numberValue == 0 ||
                            _paymentAmount.numberValue == 0 ||
                            _numberOfYears.text == '' ||
                            _date.text == '' ||
                            paymentsPerYear == null) {
                          _helpMessage();
                        } else {
                          _transferInfo(context);
                        }
                      },
                      child: Text('Calculate'),
                      color: Colors.grey[700],
                      textColor: Colors.white,
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _clientName.clear();
                        _financeCompany.clear();
                        _assetPurchased.clear();
                        //date.clear();//does not work
                        _principalAmount.updateValue(0.00);
                        _paymentAmount.updateValue(0.00);
                        _numberOfYears.clear();
                        _lumpSumAmount.clear();
                        setState(() {
                          paymentsPerYear = null;
                          lumpSumType = null;
                        });
                      },
                      child: Text('Clear'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _helpMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tip'),
          content: Text('Make sure all fields are completed'),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _calculateInterestRate() {
    double principal = _principalAmount.numberValue;
    double payment = _paymentAmount.numberValue;
    var term = double.parse(_numberOfYears.text);

    var repaymentFrequency = _getPaymentsPerYear();

    var numberOfPayments = term * repaymentFrequency;

    double calculateInterest() {
      var tolerableError = pow(10, -5);
      var guess = 0.05 / 12;
      var updateGuess;

      double f(x) =>
          principal *
              x *
              pow((1 + x), numberOfPayments) /
              (pow((1 + x), numberOfPayments) - 1) -
          payment;

      double fPrime(x) =>
          principal *
          (pow((1 + x), numberOfPayments) /
                  (-1 + pow((1 + x), numberOfPayments)) -
              numberOfPayments *
                  x *
                  pow((1 + x), (-1 + 2 * numberOfPayments)) /
                  pow(-1 + pow((1 + x), numberOfPayments), 2) +
              numberOfPayments *
                  x *
                  pow((1 + x), (-1 + numberOfPayments)) /
                  (-1 + pow((1 + x), numberOfPayments)));

      var k = 0;

      while (k < 20) {
        updateGuess = guess;
        guess = updateGuess - f(updateGuess) / fPrime(updateGuess);
        var diff = (guess - updateGuess).abs();
        if (diff < tolerableError) {
          break;
        }
        k += 1;
      }

      return guess;
    }

    return calculateInterest();
  }

  double _interestRate() =>
      (_calculateInterestRate() * paymentsPerYear * 10000) / 100;

  _getPaymentsPerYear() {
    switch (paymentsPerYear) {
      case 1:
        {
          return 1;
        }
        break;
      case 4:
        {
          return 4; //THIS DOES NOT CALCULATED CORRECTLY
        }
      case 12:
        {
          return 12;
        }
        break;
      case 52:
        {
          return 52;
        }
        break;
    }
  }
//Have not used yet
  getPrincipalAmount(){
    double principal = _principalAmount.numberValue;
    var lumpSum = double.parse(_lumpSumAmount.text);
    var upFront = principal - lumpSum;

    switch(lumpSumType){
      case 101:
        return upFront;
        break;
      case 102:
        return 0;
        break;
      default:
        return principal;
      break;
    }

  }
  void _transferInfo(BuildContext context) {
    var interestPerPayment = _calculateInterestRate();
    var interestRateDisplay = _interestRate();
    var repaymentFrequency = _getPaymentsPerYear();
    double years = double.parse(_numberOfYears.text);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Schedule(
          client: _clientName.text,
          financier: _financeCompany.text,
          asset: _assetPurchased.text,
          principal: _principalAmount.numberValue,
          repayment: _paymentAmount.numberValue,
          term: years,
          interest: interestPerPayment,
          interestRate: interestRateDisplay,
          paymentsPerYear: repaymentFrequency,
          firstPaymentDate: _date.text,
        ),
      ),
    );
  }
}

class Schedule extends StatelessWidget {
  final client;
  final financier;
  final asset;
  final principal;
  final repayment;
  final term;
  final interest;
  final interestRate;
  final paymentsPerYear;
  final firstPaymentDate;

  Schedule({
    Key key,
    @required this.client,
    this.financier,
    this.asset,
    this.principal,
    this.repayment,
    this.term,
    this.interest,
    this.interestRate,
    this.paymentsPerYear,
    this.firstPaymentDate, //Need to fix formatting
  }) : super(key: key);

  _totalInterest() {
    //Move to first page
    var totalPayments = term * paymentsPerYear;
    var totalInterest = (totalPayments * repayment) - principal;
    return totalInterest.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amortisation Schedule'),
        backgroundColor: Colors.grey[700],
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              client + ' - ' + financier + ' - ' + asset,
              textScaleFactor: 1.5,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Principal: \$' + principal.toStringAsFixed(2),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Payment: \$' + repayment.toStringAsFixed(2),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Interest Rate: ' + interestRate.toStringAsFixed(2) + '%',
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Total Interest: \$' + _totalInterest(),
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        Text(
                          'Date',
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Payment',
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Interest',
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Principal',
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Balance',
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            //need to replace this code to reflect dynamic table rows
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        Text(
                          'Date',
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Payment',
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Interest',
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Principal',
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Balance',
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                  //Need to add code to create table and double below code works
                  /*for (var count = 0; count < term; ++count){
                        var interestPerPayment = 0;
                        var principalBalance = principal - repayment;
                        var addDate = 0;
                        addDate = ++addDate;
                        var paymentDate = firstPaymentDate;
                        paymentDate.add(addDate, paymentsPerYear);
                        }TableRow(
                      children: [
                        Text(
                          paymentDate.format('dd-MM-yyyy),
                          textScaleFactor: 0.75,
                        ),
                        Text(
                          '/$' + Payment.toStringAsFixed(2),
                          textScaleFactor: 0.75,
                        ),
                        Text(
                          '/$' + interestPerPayment.toStringAsFixed(2) = principal * interest,
                          textScaleFactor: 0.75,
                        ),
                        Text(
                          '/$', + principalAmount.toStringAsFixed(2) = payment - interest,
                          textScaleFactor: 0.75,
                        ),
                        Text(
                          '/$' var balance.toStringAsFixed(2) = principal - PrincipalBalance,
                          textScaleFactor: 0.75,
                        ),
                      ],
                    ),
                   */
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
