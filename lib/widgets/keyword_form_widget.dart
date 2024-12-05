import 'package:flutter/material.dart';

class KeywordFormWidget extends StatefulWidget {
  final Function(String) saveKeyword;

  const KeywordFormWidget({super.key, required this.saveKeyword});

  @override
  State<KeywordFormWidget> createState() => _KeywordFormWidgetState();
}

class _KeywordFormWidgetState extends State<KeywordFormWidget> {
  final TextEditingController _controllerKeyword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controllerKeyword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _controllerKeyword,
            decoration: const InputDecoration(
                labelText: "Palavra-chave",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor preencha um valor para adicionar uma palavra-chave.';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.saveKeyword(_controllerKeyword.text);
                  String textoDoCampo = 'Salvando: ${_controllerKeyword.text}';

                  var snackBar = SnackBar(
                    content: Text(textoDoCampo),
                    duration: const Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  _controllerKeyword.clear();
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Adicionar',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
