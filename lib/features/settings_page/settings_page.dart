import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_to_do_app/models/app_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppPreferences>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                sectionName(context, Icons.person, 'Account'),
                buildDialogOption(context, 'Dart theme'),
                buildDialogOption(context, 'Show delete confirmation'),
                buildDialogOption(context, 'Third option'),
                sectionName(context, Icons.volume_up_outlined, 'Notification'),
                buildSwitchOption(context, 'Dark Theme', 'darkTheme'),
                buildSwitchOption(
                    context, 'Delete Confirmation', 'deleteConfirm'),
              ],
            ),
          ),
        );
      },
    );
  }

  Column sectionName(BuildContext context, IconData icon, String title) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Divider(height: 5, thickness: 1),
      ],
    );
  }

  GestureDetector buildDialogOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Container buildSwitchOption(
      BuildContext context, String title, String optionName) {
    bool optionValue =
        context.read<AppPreferences>().getOptionValue(optionName)!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Switch(
            value: optionValue,
            onChanged: (bool newValue) {
              context.read<AppPreferences>().toggleOption(optionName, newValue);
            },
          )
        ],
      ),
    );
  }
}
