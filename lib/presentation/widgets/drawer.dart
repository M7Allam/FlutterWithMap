import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/others/Methods.dart';
import 'package:flutter_maps/others/values/colors.dart';
import 'package:flutter_maps/others/values/strings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);

  final PhoneAuthCubit _phoneAuthCubit = PhoneAuthCubit();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 280.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[100]
              ),
              child: buildDrawerHeader(context),
            ),
          ),
          buildDrawerListItem(leadingIcon: Icons.person, title: 'Profile'),
          buildDrawerListDivider(),
          buildDrawerListItem(leadingIcon: Icons.history, title: 'Places History', onTap: (){}),
          buildDrawerListDivider(),
          buildDrawerListItem(leadingIcon: Icons.settings, title: 'Settings'),
          buildDrawerListDivider(),
          buildDrawerListItem(leadingIcon: Icons.help, title: 'Help'),
          buildDrawerListDivider(),
          BlocProvider<PhoneAuthCubit>(
              create: (context) => _phoneAuthCubit,
            child: buildDrawerListItem(
                leadingIcon: Icons.logout,
                title: 'Logout',
              onTap: () async {
                  await _phoneAuthCubit.signOut();
                  Navigator.of(context).pushReplacementNamed(MyStrings.loginScreen);
              },
              color: Colors.red,
              trailing: const SizedBox(),
            ),
          ),
          const SizedBox(height: 60.0),
          ListTile(
            leading: Text(
              'Follow us',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          buildSocialIconsList(),
        ],
      ),
    );
  }

  Widget buildDrawerHeader(context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue[100],
          ),

          child: Image.asset(
            'assets/images/profile_image.jpg',
            fit: BoxFit.cover,
          ),
        ),
        const Text(
          'Mahmoud Allam',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5.0),
        BlocProvider<PhoneAuthCubit>(
          create: (context) => _phoneAuthCubit,
          child: Text(
            '${_phoneAuthCubit.getLoggedInUser()?.phoneNumber}',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDrawerListItem({
    required IconData leadingIcon,
    required String title,
    Widget trailing = const Icon(
      Icons.arrow_right,
      color: MyColors.blue,
    ),
    Function()? onTap,
    Color color = MyColors.blue,
  }) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: color,
      ),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget buildDrawerListDivider() {
    return const Divider(
      height: 0.0,
      thickness: 1.0,
      indent: 18,
      endIndent: 24,
    );
  }

  Widget buildSocialIcon(IconData icon, String url) {
    return InkWell(
      onTap: () => launchURL(url),
      child: Icon(
        icon,
        color: MyColors.blue,
        size: 35,
      ),
    );
  }

  Widget buildSocialIconsList() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16.0),
      child: Row(
        children: [
          buildSocialIcon(FontAwesomeIcons.facebook, 'https://www.facebook.com/Maahmoouud/'),
          const SizedBox(width: 16.0),
          buildSocialIcon(FontAwesomeIcons.youtube, 'https://www.youtube.com/'),
          const SizedBox(width: 20.0),
          buildSocialIcon(FontAwesomeIcons.telegram, 'https://t.me/OmarX14'),
        ],
      ),
    );
  }
}
