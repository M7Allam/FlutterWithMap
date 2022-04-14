import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/business_logic/cubit/phone_auth/phone_auth_states.dart';
import 'package:flutter_maps/others/values/colors.dart';
import 'package:flutter_maps/others/values/strings.dart';
import 'package:flutter_maps/presentation/widgets/progress.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  late final String phoneNumber;
  final GlobalKey<FormState> _phoneFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _phoneFormKey,
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 88.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIntroTexts(),
                const SizedBox(height: 60.0),
                _buildPhoneFormField(),
                const SizedBox(height: 40.0),
                _buildButtonNext(context),
                _buildPhoneNumberSubmittedBloc(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is your phone number?',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
        const SizedBox(height: 20.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          child: const Text(
            'Please enter your phone number to verify your account.',
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneFormField() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.lightGrey),
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
            ),
            child: Text(
              _generateCountryFlag() + ' +20',
              style: const TextStyle(
                fontSize: 18.0,
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.blue),
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
            ),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(
                fontSize: 18.0,
                letterSpacing: 2.0,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please enter your phone number!';
                } else if (value.length < 11) {
                  return 'Too short a phone number!';
                }
                return null;
              },
              onSaved: (String? value) {
                phoneNumber = value!;
              },
            ),
          ),
        ),
      ],
    );
  }

  String _generateCountryFlag() {
    String countryCode = 'eg';
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  Widget _buildButtonNext(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgressIndicator(context);
          //Navigator.pushNamed(context, MyStrings.otpScreen);
          _register(context);
        },
        child: const Text(
          'Next',
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

  Future<void> _register(BuildContext context) async{
    if(!_phoneFormKey.currentState!.validate()){
      Navigator.pop(context);
      return;
    }else {
      Navigator.pop(context);
      _phoneFormKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNumber(phoneNumber);
    }
  }

  Widget _buildPhoneNumberSubmittedBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthStates>(
      listenWhen: (previousState, currentState) {
        return previousState != currentState;
      },
      listener: (context, state) {
        if (state is LoadingPhoneAuthState) {
          showProgressIndicator(context);
        }
        if (state is SubmittedPhoneAuthState) {
          Navigator.pop(context);
          Navigator.of(context).pushNamed(
            MyStrings.otpScreen,
            arguments: phoneNumber,
          );
        }
        if (state is ErrorPhoneAuthState) {
          Navigator.pop(context);
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
}
