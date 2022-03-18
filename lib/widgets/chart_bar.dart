import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  //const ChartBar({Key? key}) : super(key: key);

  final String day;
  final double spendingAmount;
  final double percentageSpending;
  // ignore: use_key_in_widget_constructors
  const ChartBar(this.day, this.spendingAmount, this.percentageSpending);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: [
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  child: Text("\$${spendingAmount.toStringAsFixed(0)}")),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(220, 220, 220, 1),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  FractionallySizedBox(
                    heightFactor: percentageSpending,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
                height: constraints.maxHeight * 0.15,
                child: FittedBox(child: Text(day)))
          ],
        );
      },
    );
  }
}
