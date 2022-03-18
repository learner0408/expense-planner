import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  // ignore: use_key_in_widget_constructors
  const TransactionList(this.transactions, this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: ((context, constraints) {
            return Column(
              children: [
                Text(
                  "No Transactions Yet!",
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ))
              ],
            );
          }))
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5.0,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: FittedBox(
                        child: Text(
                          "\$${transactions[index].amount}",
                        ),
                      ),
                    ),
                  ),
                  title: Text("${transactions[index].title}",
                      style: Theme.of(context).textTheme.headline6),
                  subtitle:
                      Text(DateFormat.yMMMd().format(transactions[index].date)),
                  trailing: MediaQuery.of(context).size.width > 450
                      ? TextButton.icon(
                          onPressed: () => deleteTx(transactions[index].id),
                          icon: Icon(Icons.delete,
                              color: Theme.of(context).errorColor),
                          label: Text(
                            "Delete",
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          ))
                      : IconButton(
                          onPressed: () => deleteTx(transactions[index].id),
                          color: Theme.of(context).errorColor,
                          icon: Icon(Icons.delete)),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
