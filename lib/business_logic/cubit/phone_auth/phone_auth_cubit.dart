import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/cubit/phone_auth/phone_auth_states.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthStates> {

  late String verificationId;

  PhoneAuthCubit() : super(InitialPhoneAuthState());

  Future<void> submitPhoneNumber(String phoneNumber) async {
    emit(LoadingPhoneAuthState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      timeout: const Duration(seconds: 20),
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
    );
  }

  void _verificationCompleted(PhoneAuthCredential credential) async {
    print('verificationCompleted @SMS_CODE: ${credential.smsCode}');
    await _signIn(credential);
  }

  void _verificationFailed(FirebaseAuthException e) {
    print('verificationFailed @Error: ${e.toString()}');
    emit(ErrorPhoneAuthState(e.toString()));
  }

  void _codeSent(String verificationId, int? resendToken) {
    print('codeSent..');
    this.verificationId = verificationId;
    emit(SubmittedPhoneAuthState());
  }

  void _codeAutoRetrievalTimeout(String verificationId) {
    print('codeAutoRetrievalTimeout..');
  }

  Future<void> submitOTP(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
    );

    await _signIn(credential);
  }

  Future<void> _signIn(PhoneAuthCredential credential) async {
    try{
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(OTPVerifiedPhoneAuthState());
    }catch(error){
      print('_signIn @ERROR: ${error.toString()}');
      emit(ErrorPhoneAuthState(error.toString()));
    }
  }

  Future<void> signOut() async {
      await FirebaseAuth.instance.signOut();
  }

  User? getLoggedInUser(){
    return FirebaseAuth.instance.currentUser;
  }

}