import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/service/httpService.dart';
import 'package:frontend/settings/informationScreen.dart';
import 'package:frontend/settings/settings.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../logins/loginScreen.dart';
import '../service/googleSignIn.dart';
import '../service/widgets.dart';

class MyProfile extends StatefulWidget {
  final String? token;

  const MyProfile({Key? key, required this.token}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  Future<void> _signOut() async {
    int statusCode = await logOut(widget.token);
    if (statusCode == 200){
      final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
      await provider.logOut();
    } else {
      Consts.alertPopup(context, Consts.cantConnect);
    }
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to close the dialog.
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _signOut();
                Navigator.push(
                    context,
                    PageTransition(
                        child: const Login(),
                        type: PageTransitionType.bottomToTop));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(27.0),
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: const Image(
                      image: AssetImage('assets/default-profile.png'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Profile page header',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'Profile page subheader',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            ProfileMenuOption(
              title: 'Settings',
              icon: LineAwesomeIcons.cog,
              onPress: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: SettingsScreen(token: widget.token,),
                        type: PageTransitionType.rightToLeft));
              },
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            ProfileMenuOption(
              title: 'Information',
              icon: LineAwesomeIcons.info,
              onPress: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const InformationScreen(),
                        type: PageTransitionType.rightToLeft));
              },
            ),
            ProfileMenuOption(
              title: 'Logout',
              icon: LineAwesomeIcons.alternate_sign_out,
              onPress: () async {
                await _showLogoutConfirmationDialog(context);
              },
              endIcon: false,
              textColor: Colors.red,
            ),
          ],
        ),
      ),
    ));
  }
}

class ProfileMenuOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  const ProfileMenuOption({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    Color settingColor = currentTheme.brightness == Brightness.light
        ? Consts.primaryColor
        : Colors.white;
    return ListTile(
        onTap: onPress,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: settingColor.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: settingColor,
          ),
        ),
        title: CustomFontText(text:
        title,
          style: const TextStyle(fontSize: 18).apply(color: textColor),
        ),
        trailing: endIcon
            ? Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: settingColor.withOpacity(0.1),
                ),
                child: Icon(
                  LineAwesomeIcons.angle_right,
                  color: settingColor,
                ),
              )
            : null);
  }
}
