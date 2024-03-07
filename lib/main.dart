import 'dart:developer';
import 'package:flutter/material.dart';

//Local Imports
import 'package:online_offline/models/user_model.dart';
import 'package:online_offline/provider/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProfileProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late UserProfileProvider provider;
  List<User>? userModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    provider = Provider.of<UserProfileProvider>(context, listen: false);
    provider.getProfileInfoProvider().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // Make your backend API call here
      provider.login('random1',false).then(
        (values) {
          log('true',name: "succes");
        },
      );
      log('Its Offline', name: 'Backend API');
    }
    else{
      provider.login('random1',true).then(
        (values) {
          log('false',name: "succes");
        },
      );
      log('its online', name: 'log');
    }
  }

  @override
  Widget build(BuildContext context) {
    userModel = context.select((UserProfileProvider value) => value.userModel);
    // return Container();
    return ListView.builder(
      itemCount: userModel?.length ?? 1,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color:
                userModel?[index].user == 'online' ? Colors.green : Colors.blue,
          ),
          child: Text(userModel?[index].username ?? "User"),
        );
      },
    );
  }
}
