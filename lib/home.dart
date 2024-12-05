import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:noticias/app_global.dart';
import 'package:noticias/models/article.dart';
import 'package:noticias/models/source.dart';
import 'package:noticias/models/suggestion.dart';
import 'package:noticias/background_tasks.dart';
import 'package:noticias/services/notification_service.dart';
import 'package:noticias/settings_notification.dart';
import 'package:noticias/widgets/keyword_form_widget.dart';
import 'package:noticias/widgets/keyword_suggestion_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _keywords = [];
  final List<Suggestion> _suggestions = [
    Suggestion(title: "Jogos", icon: FontAwesomeIcons.gamepad),
    Suggestion(title: "Esportes", icon: FontAwesomeIcons.medal),
    Suggestion(title: "Finanças", icon: FontAwesomeIcons.moneyBills),
    Suggestion(title: "Cinema", icon: FontAwesomeIcons.film),
    Suggestion(title: "Viagem", icon: FontAwesomeIcons.planeDeparture),
    Suggestion(title: "Estudos", icon: FontAwesomeIcons.graduationCap),
  ];

  @override
  void initState() {
    super.initState();

    loadKeywords();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notícias',
      navigatorKey: AppGlobal.navigatorKey,
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color.fromARGB(255, 101, 120, 150)),
      home: homePage(),
    );
  }

  Widget homePage() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0),
          title: const Text("Notícias"),
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
              onPressed: () {
                Navigator.push(
                    AppGlobal.navigatorKey.currentState!.context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsNotification()));
              },
            ),
          ],
        ),
        body: body());
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton(
              onPressed: () {
                backgroundCallback('searchNews');
              },
              child: const Text("Notificar")),
          // const Parte2ComWorkmanager(),
          const Text(
            "Selecione os tópicos do seu interesse:",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            flex: 1,
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: (4 / 3.5),
              children: _suggestions
                  .mapIndexed<Widget>(
                      (int index, suggestion) => KeywordSuggestionWidget(
                            title: suggestion.title,
                            icon: suggestion.icon,
                            selected: suggestion.selected,
                            onPress: () => onPressSuggestion(index),
                          ))
                  .toList(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Digite tags para filtrar:',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                          children: _keywords
                              .map((keyword) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: OutlinedButton(
                                        onLongPress: () =>
                                            removeKeyword(keyword),
                                        onPressed: () => {},
                                        child: Text(
                                          keyword,
                                          style: const TextStyle(fontSize: 16),
                                        )),
                                  ))
                              .toList()),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: KeywordFormWidget(saveKeyword: saveKeyword)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void saveKeyword(String newKeyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> keywords = prefs.getStringList('keywords') ?? [];

    if (!keywords.contains(newKeyword)) {
      keywords.add(newKeyword);
      await prefs.setStringList('keywords', keywords);
    }

    loadKeywords();
  }

  void loadKeywords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _keywords = prefs.getStringList('keywords') ?? [];
    });

    updateSuggestions();
  }

  void updateSuggestions() {
    setState(() {
      _suggestions.forEach((suggestion) {
        suggestion.selected =
            false; // Garante para q quando removido, seja desselecionado
        if (_keywords.contains(suggestion.title)) {
          suggestion.selected = true;
        }
      });
    });
  }

  void removeKeyword(String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var index = _keywords.indexOf(keyword);

    setState(() {
      _keywords.removeAt(index);
    });

    await prefs.remove('keywords');
    await prefs.setStringList('keywords', _keywords);

    updateSuggestions();
  }

  void onPressSuggestion(int index) {
    if (_suggestions[index].selected) {
      removeKeyword(_suggestions[index].title);
    } else {
      saveKeyword(_suggestions[index].title);
    }

    setState(() {
      _suggestions[index].selected = !_suggestions[index].selected;
    });
  }
}
