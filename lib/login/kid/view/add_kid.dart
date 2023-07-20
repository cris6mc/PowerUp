import 'package:flutter/material.dart';
import 'package:jueguito2/login/kid/provider/firestore_kid.dart';

class AddKid extends StatefulWidget {
  const AddKid({super.key});
  @override
  State<AddKid> createState() => _AddKidState();
}

class _AddKidState extends State<AddKid> {
  String? name;
  String observaciones = '';
  String school = '';
  final TextEditingController _birthdateController = TextEditingController();
  DateTime? birthdate;
  bool? _textIsValid;
  bool isSaving = false;
  String _gender = 'm';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.transparent,
                Colors.blue,
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  maxLength: 20,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      labelText: 'Nombre',
                      errorText: _textIsValid == true ? null : 'Value no valid',
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                  onChanged: (String value) {
                    if (value.isNotEmpty &&
                        value.length >= 2 &&
                        value.length <= 20) {
                      setState(() {
                        _textIsValid = true;
                      });
                      name = value;
                    } else {
                      setState(() {
                        _textIsValid = false;
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  maxLines: 3,
                  maxLength: 100,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Observaciones',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                  onChanged: (value) {
                    observaciones = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  maxLines: 3,
                  maxLength: 100,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Escuela',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                  onChanged: (value) {
                    school = value;
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  readOnly: true,
                  controller: _birthdateController,
                  decoration: const InputDecoration(
                    labelText: 'Selecciona tu fecha de nacimiento',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now(),
                    ).then((value) {
                      if (value != null) {
                        birthdate = value;
                        setState(() {
                          _birthdateController.text =
                              '${value.day} / ${value.month} / ${value.year}';
                        });
                      }
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Genero:'),
                    Row(
                      children: [
                        const Text('Masculino'),
                        Radio(
                            value: 'm',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value as String;
                              });
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Femenino'),
                        Radio(
                            value: 'f',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value as String;
                              });
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Stack(
                children: [
                  ElevatedButton(
                    onPressed:
                        (!isSaving && _textIsValid == true && birthdate != null)
                            ? () async {
                                await saveKid(name, observaciones, _gender,
                                    birthdate, school, null, null, 0);
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              }
                            : null,
                    child: const Text('GUARDAR'),
                  ),
                  if (isSaving) const CircularProgressIndicator(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
