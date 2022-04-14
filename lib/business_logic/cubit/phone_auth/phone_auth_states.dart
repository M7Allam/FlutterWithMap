import 'package:flutter/material.dart';

@immutable
abstract class PhoneAuthStates {}

class InitialPhoneAuthState extends PhoneAuthStates {}

class LoadingPhoneAuthState extends PhoneAuthStates {}

class SubmittedPhoneAuthState extends PhoneAuthStates {}

class ErrorPhoneAuthState extends PhoneAuthStates {
  final String errorMsg;
  ErrorPhoneAuthState(this.errorMsg);
}

class OTPVerifiedPhoneAuthState extends PhoneAuthStates {}