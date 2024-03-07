//Third Party Imports
import 'dart:developer';
import 'package:flutter/material.dart';

//Local Imports
import 'package:online_offline/models/user_model.dart';
import 'package:online_offline/repo/user_repo.dart';

class UserProfileProvider extends ChangeNotifier {
  final repo = UserReposiotry();
  List<User>? userModel;
  bool isLoading = false;

  Future<dynamic> getProfileInfoProvider() async {
    try {
      isLoading = true;
      Map<String, dynamic> responseData = await repo.userProfileApi();
      if (responseData['status_code'] == 200) {
        userModel = List<User>.from(
            responseData["data"]!.map((x) => User.fromJson(x)));
        isLoading = false;
        notifyListeners();
        // log(userModel.toString(), name: "User Models");
        return userModel;
      } else {
        log(responseData.toString(), name: 'logging');
      }
    } catch (e) {
      log("$e", name: "Error");
    }
  }

  Future<bool> login(String username, bool on_off) async {
    try {
      Map<String, dynamic> data = {'username': username, 'on_off': on_off};
      final response = await repo.onOffApi(data);
      if (response['status_code'] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString(),name: "Error");
    }
    return false;
  }

}
