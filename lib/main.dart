import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/new_transaction.dart';
import './widgets/charts.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Planner',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: const TextTheme(
              headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              button: TextStyle(color: Colors.white)),
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20.0,
          ))),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //const ({ Key? key }) : super(key: key);

  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: '11', title: 'Groceries', amount: 20, datetime: DateTime.now()),
    // Transaction(id: '12', title: 'Watch', amount: 34, datetime: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransactions(String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        datetime: chosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _openAddNewTarnsaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addTransactions),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _BuilderLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Show Chart",
          style: Theme.of(context).textTheme.headline6,
        ),
        Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            })
      ]),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _BuilderPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3,
          child: Chart(_recentTransactions)),
      txListWidget
    ];
  }

  Widget _BuilderIOSAppBar() {
    return CupertinoNavigationBar(
      middle: const Text("Expense Planner"),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        GestureDetector(
          onTap: () => _openAddNewTarnsaction(context),
          child: const Icon(CupertinoIcons.add),
        )
      ]),
    );
  }

  Widget _BuilderAndroidAppBar() {
    return AppBar(
      title: const Text("Expense Planner"),
      actions: [
        IconButton(
            onPressed: () => _openAddNewTarnsaction(context),
            icon: const Icon(Icons.add))
      ],
    );
  }

  bool _showChart = false;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? _BuilderIOSAppBar() as PreferredSizeWidget
        : _BuilderAndroidAppBar() as PreferredSizeWidget;
    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final bodyPart = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape)
            ..._BuilderLandscapeContent(
                mediaQuery, appBar as AppBar, txListWidget),
          if (!isLandscape)
            ..._BuilderPortraitContent(
                mediaQuery, appBar as AppBar, txListWidget),
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: bodyPart,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPart,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _openAddNewTarnsaction(context),
                    child: const Icon(Icons.add),
                  ),
          );
  }
}
