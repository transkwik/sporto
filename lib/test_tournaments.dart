import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sporto/core/apiServices/user_api.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  var res = await UserApis().getMyTournaments(1, 10, status: '2');
  print("STATUS 2: $res");
  exit(0);
}
