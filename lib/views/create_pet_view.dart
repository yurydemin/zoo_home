import 'package:flutter/material.dart';
import 'package:zoo_home/helpers/pet_visual_helper.dart';
import 'package:zoo_home/models/ModelProvider.dart';

typedef OnSaveCallback = Function(
    PetKind kind, PetStatus status, String title, String description);

class CreatePetView extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Pet pet;

  CreatePetView({
    Key key,
    @required this.onSave,
    @required this.isEditing,
    this.pet,
  }) : super(key: key);

  @override
  _CreatePetViewState createState() => _CreatePetViewState();
}

class _CreatePetViewState extends State<CreatePetView> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _title;
  String _description;
  PetKind _kind;
  PetStatus _status;

  bool get isEditing => widget.isEditing;

  @override
  void initState() {
    if (isEditing) {
      _title = widget.pet.title;
      _description = widget.pet.description;
      _kind = widget.pet.kind;
      _status = widget.pet.status;
    } else {
      _title = '';
      _description = '';
      _kind = PetKind.CAT;
      _status = PetStatus.OPENED;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Изменить' : 'Добавить новое животное'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  hintText: 'Имя животного',
                ),
                validator: (val) {
                  return val.trim().isEmpty ? 'Имя не может быть пустым' : null;
                },
                onSaved: (value) => _title = value,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  hintText: 'Информация о животном',
                ),
                maxLines: 8,
                validator: (val) {
                  return val.trim().isEmpty
                      ? 'Информация о животном не может быть пустой'
                      : null;
                },
                onSaved: (value) => _description = value,
              ),
              DropdownButtonFormField<String>(
                value: PetVisualHelper.petKindToString(_kind),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Выберите категорию';
                  return null;
                },
                items: PetKind.values
                    .map(
                      (label) => DropdownMenuItem(
                        child: Text(PetVisualHelper.petKindToString(label)),
                        value: PetVisualHelper.petKindToString(label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  _kind = PetVisualHelper.petKindFromString(value);
                }),
              ),
              DropdownButtonFormField<String>(
                value: PetVisualHelper.petStatusToString(_status),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Выберите статус карточки';
                  return null;
                },
                items: PetStatus.values
                    .map(
                      (label) => DropdownMenuItem(
                        child: Text(PetVisualHelper.petStatusToString(label)),
                        value: PetVisualHelper.petStatusToString(label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  _status = PetVisualHelper.petStatusFromString(value);
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: isEditing ? 'Сохранить изменения' : 'Добавить',
        child: Icon(isEditing ? Icons.check : Icons.done),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            widget.onSave(_kind, _status, _title, _description);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
