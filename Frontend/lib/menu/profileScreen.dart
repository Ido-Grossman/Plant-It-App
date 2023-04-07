import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
        padding: EdgeInsets.all(27.0),
        child: Column(
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Consts.primaryColor,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
                child: const Text('Edit Profile Picture',
                style: TextStyle(
                  fontSize: 17
                ),),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            ProfileMenuOption(title: 'Settings',),
            ProfileMenuOption(title: 'Settings',),
            ProfileMenuOption(title: 'Settings',),
            ProfileMenuOption(title: 'Settings',),
            ProfileMenuOption(title: 'Settings',),
          ],
        ),
      ),
    ));
  }
}

class ProfileMenuOption extends StatelessWidget {
  final String title;
  const ProfileMenuOption({
    super.key, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Consts.primaryColor.withOpacity(0.1),
          ),
          child: Icon(
            LineAwesomeIcons.cog,
            color: Consts.primaryColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 20),
        ),
        trailing: Container(
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
        ));
  }
}
