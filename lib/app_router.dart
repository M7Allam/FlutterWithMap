import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/others/values/strings.dart';
import 'package:flutter_maps/presentation/screens/login_screen.dart';
import 'package:flutter_maps/presentation/screens/map_screen.dart';
import 'package:flutter_maps/presentation/screens/otp_screen.dart';

class AppRouter {

  PhoneAuthCubit? phoneAuthCubit;

  AppRouter(){
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch(settings.name){
      case MyStrings.loginScreen:
        return MaterialPageRoute(builder: (_) => BlocProvider.value(
            value: phoneAuthCubit!,
            child: LoginScreen(),
        ));
      case MyStrings.otpScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(builder: (_) => BlocProvider.value(
            value: phoneAuthCubit!,
            child: OtpScreen(phoneNumber: phoneNumber,),
        ));
      case MyStrings.mapScreen:
        return MaterialPageRoute(builder: (_) => const MapScreen());
    }
  }
}
