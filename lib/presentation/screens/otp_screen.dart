import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/business_logic/cubit/phone_auth/phone_auth_states.dart';
import 'package:flutter_maps/others/values/colors.dart';
import 'package:flutter_maps/others/values/strings.dart';
import 'package:flutter_maps/presentation/widgets/progress.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {

  final phoneNumber;
  late String otpCode;

  OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 88.0),
        child: Column(
          children: [
            _buildIntroText(),
            const SizedBox(height: 40.0),
            _buildPinCodeFields(context),
            const SizedBox(height: 40.0),
            _buildVerifyButton(context),
            _buildPhoneVerificationBLoc(),
          ],
        ),
      ),
    ));
  }

  Widget _buildIntroText(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verify your phone number',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24.0
          ),
        ),
        const SizedBox(height: 20.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          child: RichText(
            text: TextSpan(
              text: 'Enter your 6 digit code numbers sent to',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                height: 1.4,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '$phoneNumber',
                  style: const TextStyle(
                    color: MyColors.blue,
                  ),
                ),
              ]
            ),

          ),
        ),
      ],
    );
  }

  Widget _buildPinCodeFields(BuildContext context){
    return PinCodeTextField(
      appContext: context,
      length: 6,
      autoFocus: true,
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5.0),
        fieldHeight: 50.0,
        fieldWidth: 40.0,
        borderWidth: 1.0,
        activeColor: MyColors.blue,
        inactiveColor: Colors.black,
        activeFillColor: Colors.lightBlue,
        inactiveFillColor: Colors.white,
        selectedColor: MyColors.blue,
        selectedFillColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      enableActiveFill: true,
      onCompleted: (String code){
        print('PIN CODE ON COMPLETED VALUE : $code');
        otpCode = code;
      },
      onChanged: (String value){
        print('PIN CODE ON CHANGED VALUE : $value');
      },
    );
  }

  Widget _buildVerifyButton(BuildContext context){
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: (){
          showProgressIndicator(context);
          _login(context);
        },
        child: const Text(
          'Verify',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(110.0, 50.0),
          primary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneVerificationBLoc(){
    return BlocListener<PhoneAuthCubit, PhoneAuthStates>(
      listenWhen: (previousState, currentState) {
        return previousState != currentState;
      },
      listener: (context, state) {
        if (state is LoadingPhoneAuthState) {
          showProgressIndicator(context);
        }
        if (state is OTPVerifiedPhoneAuthState) {
          Navigator.pop(context);
          Navigator.of(context).pushReplacementNamed(
            MyStrings.mapScreen,
            arguments: phoneNumber,
          );
        }
        if (state is ErrorPhoneAuthState) {
          String errorMsg = (state).errorMsg;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 5),
          ));
        }
      },
      child: Container(),
    );
  }

  void _login(BuildContext context){
    BlocProvider.of<PhoneAuthCubit>(context).submitOTP(otpCode);
  }

}
