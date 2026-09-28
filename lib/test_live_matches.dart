import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sporto/core/apiServices/user_api.dart';
import 'package:sporto/core/apiServices/api_helpers.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  var res = await UserApis().getLiveMatches('', 1, 10, '');
  print("LIVE MATCHES: $res");
  exit(0);
}
