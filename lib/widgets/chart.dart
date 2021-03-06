import 'package:flutter/material.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;
  Chart({this.recentTransaction});

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double sum = 0.0;

      for (int i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekDay.day &&
            recentTransaction[i].date.month == weekDay.month &&
            recentTransaction[i].date.year == weekDay.year) {
          sum = sum + recentTransaction[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay),
        'amount': sum,
      };
    });
  }
   double get totalSpending{
     return groupedTransactionValues.fold(0.0, (sum, element) {

       return sum +element['amount'];

     });
   }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      // row of 7 columns cotain 7 bars of 7 days
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...groupedTransactionValues.map((e) {
              return Flexible(
                  fit: FlexFit.loose,
                  child: ChartBar(
                  lable: e['day'],
                  spendingAmount: e['amount'],
                  spendingPctOfTotal: totalSpending == 0.0? 0.0 :(e['amount']as double )/ totalSpending,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
