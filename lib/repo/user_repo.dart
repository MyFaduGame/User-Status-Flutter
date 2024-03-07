//Third Party Imports
import 'dart:convert';
import 'dart:developer';
//Local Imports
import 'package:online_offline/repo/base_repo.dart';

class UserReposiotry extends BaseRepository {
  Future userProfileApi() async {
    final response = await getHttp(api: '/', token: false);
    log(response.body, name: 'response userProfileApi');
    return json.decode(response.body);
  }

  Future onOffApi(Map<String, dynamic> data) async {
    String username = data['username'];
    bool on_off = data['on_off'];
    final response = await postHttp(data: data, api: '/$username/$on_off');
    log(response.body, name: 'response onOffApi');
    return json.decode(response.body);
  }
}
