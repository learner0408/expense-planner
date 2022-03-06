import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  //const ({ Key? key }) : super(key: key);
  String _titleInput = "";
  String _amountInput = "";
  DateTime? _selectedDate;

  void _submitData() {
    if (_titleInput == "" ||
        double.parse(_amountInput) <= 0 ||
        _selectedDate == null) {
      return;
    }
    widget.addTx(_titleInput, double.parse(_amountInput), _selectedDate);

    Navigator.of(context).pop();
  }

  void _openDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5.0,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                onChanged: (val) => _titleInput = val,
                onSubmitted: (_) => _submitData(),
                style: TextStyle(fontFamily: "OpenSans-Regular"),
              ),
              TextField(
                  decoration: InputDecoration(labelText: "Amount"),
                  onChanged: (val) => _amountInput = val,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _submitData(),
                  style: TextStyle(fontFamily: "OpenSans-Regular")),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? "No Date Chosen!"
                          : "Date: ${DateFormat.yMd().format(_selectedDate!)}"),
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        onPressed: () {
                          _openDatePicker();
                        },
                        child: Text(
                          "Choose Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  // onPrimary: Theme.of(context).textTheme.button.color==null ? null : Theme.of(context).textTheme.button.color
                ),
                onPressed: _submitData,
                child: Text(
                  "Add Transaction",
                  // style: TextStyle(
                  //   color: Theme.of(context).textTheme.button.color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
