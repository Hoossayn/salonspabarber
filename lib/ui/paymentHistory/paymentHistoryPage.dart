import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:salonspabarber/entity/User.dart';
import 'package:salonspabarber/helper/pref_manager.dart';
import 'package:salonspabarber/ui/paymentHistory/earningHistory/earning_history.dart';
import 'package:salonspabarber/ui/paymentHistory/earningHistory/state/earning_state.dart';
import 'package:salonspabarber/ui/paymentHistory/walletHistory/model/wallet_history_response.dart';
import 'package:salonspabarber/ui/paymentHistory/walletHistory/state/wallet_state.dart';
import 'package:salonspabarber/utilities/custom_loader_indicator.dart';
import 'earningHistory/model/earning_history_response.dart';
import 'walletHistory/wallet_history.dart';

class paymentHistoryPage extends StatefulWidget {
  @override
  _paymentHistoryPageState createState() => _paymentHistoryPageState();
}

class _paymentHistoryPageState extends State<paymentHistoryPage> with SingleTickerProviderStateMixin {
  
  CustomLoader _loader;
  final Logger _logger = Logger();
  WalletState _walletState;
  EarningState _earningState;
  static List<WalletHistory> _walletHistory = [];
  static List<EarnHistory> _earningHistory = [];
  TabController _tabController;
  final _prefManager = SharedPreferencesHelper();
  UserEntity _user;


  @override
  void initState() {
    _loader = CustomLoader(context);
    _tabController = TabController(length: 2, vsync: this);
    _walletState = Provider.of<WalletState>(context, listen: false);
    _earningState = Provider.of<EarningState>(context, listen: false);
    _getUserDetail();
    super.initState();
  }

  void _getUserDetail(){
    _prefManager.getUsersDetails().then((value) {
      setState(() {
        _user = value;
        _getWalletHistory();
      });
      print('Homename: ${_user.id}');
    });
  }


  void _getWalletHistory() {
    var _map = Map<String, dynamic>();
    _map['userid'] = _user.id.toString();

    var _map1 = Map<String, dynamic>();
    _map1['id'] = _user.id.toString();

    _loader.showLoader();
    _walletState.getWalletHistory(url: 'paymenthistory', body: _map).then((walletHistory) {
      _loader.hideLoader();
      setState(() => _walletHistory = walletHistory.history);
      _logger.e('cancelledOrders ${walletHistory.history.toString()}');
    });
    _earningState.getEarningHistory(url: 'withdrawalhistory', body: _map1).then((earnHistory) {
      setState(() => _earningHistory = earnHistory.history);
      _loader.hideLoader();
    });

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // initialIndex: 1,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text('Payment History'),
            bottom: TabBar(
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Wallet History"),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Earning History"),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Center(
                child: WalletHistoryPage(walletHistory: _walletHistory),
              ),
              Center(
                child: EarningHistoryPage(earningHistory: _earningHistory),
              )
            ],
          )
      ),
    );
  }
}



