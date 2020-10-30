import 'package:flutter/material.dart';
import 'package:kai_mobile_app/elements/loader.dart';
import 'package:kai_mobile_app/model/user_response.dart';
import 'package:kai_mobile_app/bloc/auth_user_bloc.dart';
import 'package:kai_mobile_app/screens/tabs/profile_screen.dart';
import 'package:kai_mobile_app/screens/util/auth_screen.dart';

import '../tabs/news_screen.dart';

class AuthCheckScreen extends StatefulWidget {
  @override
  _AuthCheckScreenState createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {

    //authBloc..auth("AdiullovIR", "m7vro72n");
    authBloc..authWithLocal();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<UserResponse>(
          stream: authBloc.subject.stream,
          builder: (context, AsyncSnapshot<UserResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return AuthScreen();
              }
              print("Container");
              return ProfileScreen();
            } else if (snapshot.hasError) {
              return AuthScreen();
            } else {
              return buildLoadingWidget();
            }
          },
        )
    );
  }

}