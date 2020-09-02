import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:data_connection_checker/data_connection_checker.dart';

abstract class ViewContractConnectivityListener {
  void onConnectivityResponse(bool status) {}
}

class Connectivitys {
  ViewContractConnectivityListener viewContractConnectivityListener;

  Connectivitys._internal();

  static final Connectivitys _instance = Connectivitys._internal();

  static Connectivitys get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  Connectivitys(this.viewContractConnectivityListener) {}

  void initialise() async {
    ConnectivityResult results = await connectivity.checkConnectivity();
    checkConnectivity(results);
    connectivity.onConnectivityChanged.listen((result) {
      checkConnectivity(results);
    });
  }

  void checkConnectivity(ConnectivityResult results) async {
    bool _isOnline = false;
    try {
      bool result = await DataConnectionChecker().hasConnection;
      if (result == true) {
        viewContractConnectivityListener.onConnectivityResponse(true);
      } else {
        viewContractConnectivityListener.onConnectivityResponse(false);
      }
    } on SocketException catch (_) {
      _isOnline = false;
    }
    controller.sink.add({results: _isOnline});
  }

  void disposeStream() => controller.close();
}

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
