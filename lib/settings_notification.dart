import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNotification extends StatefulWidget {
  const SettingsNotification({super.key});

  @override
  State<SettingsNotification> createState() => _SettingsNotificationState();
}

class _SettingsNotificationState extends State<SettingsNotification> {
  bool _showErrorNotification = true;
  bool _showSuccessNotification = true;
  bool _highPriority = true;
  List<String> sounds = ['', 'waku_waku', 'magnetic_ringtone'];
  String selectedSound = "";

  @override
  void initState() {
    super.initState();

    loadSettings();
  }

  void loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _showErrorNotification = prefs.getBool('set_error_notification') ?? true;
      _showSuccessNotification =
          prefs.getBool('set_success_notification') ?? true;
      _highPriority = prefs.getBool('set_high_priority') ?? true;
      selectedSound = prefs.getString('notification_sound') ?? '';
    });
  }

  void saveSettings(String sound) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('set_error_notification', _showErrorNotification);
    await prefs.setBool('set_success_notification', _showSuccessNotification);
    await prefs.setBool('set_high_priority', _highPriority);
    await prefs.setString('notification_sound', sound);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0),
          title: const Text("Configurações"),
          leading: const Center(
            child: FaIcon(
              FontAwesomeIcons.shieldCat,
              size: 40,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.5),
            child: Container(
              color: Colors.grey,
              height: 0.8,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(FontAwesomeIcons.gear),
              tooltip: 'Configurações',
              onPressed: () {},
            ),
          ],
        ),
        // body: Parte2ComWorkmanager());
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              switchPermission(
                title: "Notificar sincronização finalizada:",
                value: _showSuccessNotification,
                onChanged: (newValue) => setState(() {
                  _showSuccessNotification = newValue;
                  saveSettings(selectedSound);
                }),
              ),
              switchPermission(
                  title: "Notificar erros na sincronização:",
                  value: _showErrorNotification,
                  onChanged: (newValue) => setState(() {
                        _showErrorNotification = newValue;
                        saveSettings(selectedSound);
                      })),
              switchPermission(
                  title: "Notificações de alta prioridade:",
                  value: _highPriority,
                  onChanged: (newValue) => setState(() {
                        _highPriority = newValue;
                        saveSettings(selectedSound);
                      })),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Toque:", style: TextStyle(fontSize: 18)),
                  DropdownButton<String>(
                    value: selectedSound,
                    onChanged: (String? newSound) {
                      setState(() {
                        selectedSound = newSound!;
                      });
                      saveSettings(newSound!);
                    },
                    items: sounds.map<DropdownMenuItem<String>>((String sound) {
                      return DropdownMenuItem<String>(
                        value: sound,
                        child: Text(sound),
                      );
                    }).toList(),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Widget switchPermission(
      {required String title,
      required bool value,
      required Function onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          Switch(
              value: value, onChanged: (bool newValue) => onChanged(newValue))
        ],
      ),
    );
  }
}
