import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/settings/editProfilePhoto.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
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
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, PageTransition(
                      child: const EditProfilePhotoScreen(),
                      type: PageTransitionType.rightToLeft));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Consts.primaryColor,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Edit Profile Picture',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            ProfileMenuOption(
              title: 'Settings',
              icon: LineAwesomeIcons.cog,
              onPress: () {},
            ),
            ProfileMenuOption(
              title: 'Notifications',
              icon: LineAwesomeIcons.bell,
              onPress: () {},
            ),
            ProfileMenuOption(
              title: 'User Management',
              icon: LineAwesomeIcons.user_check,
              onPress: () {},
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
              onPress: () {},
            ),
            ProfileMenuOption(
              title: 'Logout',
              icon: LineAwesomeIcons.alternate_sign_out,
              onPress: () {},
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
    return ListTile(
        onTap: onPress,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Consts.primaryColor.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: Consts.primaryColor,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18).apply(color: textColor),
        ),
        trailing: endIcon
            ? Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Consts.primaryColor.withOpacity(0.1),
                ),
                child: Icon(
                  LineAwesomeIcons.angle_right,
                  color: Consts.primaryColor,
                ),
              )
            : null);
  }
}
