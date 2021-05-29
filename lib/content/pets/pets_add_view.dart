import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:zoo_home/models/ModelProvider.dart';

typedef OnSaveCallback = Function(
    PetKind kind, PetStatus status, String title, String description);

class PetsAddView extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Pet pet;

  PetsAddView({
    Key key,
    @required this.onSave,
    @required this.isEditing,
    this.pet,
  }) : super(key: key);

  @override
  _PetsAddViewState createState() => _PetsAddViewState();
}

class _PetsAddViewState extends State<PetsAddView> {
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
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              initialValue: _title,
              decoration: InputDecoration(
                hintText: 'Имя',
              ),
              validator: (val) {
                return val.trim().isEmpty ? 'Имя не может быть пустым' : null;
              },
              onSaved: (value) => _title = value,
            ),
            TextFormField(
              initialValue: _description,
              decoration: InputDecoration(
                hintText: 'Описание',
              ),
              maxLines: 8,
              validator: (val) {
                return val.trim().isEmpty
                    ? 'Описание не может быть пустым'
                    : null;
              },
              onSaved: (value) => _description = value,
            ),
            DropdownButtonFormField<String>(
              value: EnumToString.convertToString(_kind),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Выберите категорию';
                return null;
              },
              items: PetKind.values
                  .map(
                    (label) => DropdownMenuItem(
                      child: Text(EnumToString.convertToString(label)),
                      value: EnumToString.convertToString(label),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                _kind = EnumToString.fromString(PetKind.values, value);
              }),
            ),
            DropdownButtonFormField<String>(
              value: EnumToString.convertToString(_status),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Выберите статус карточки';
                return null;
              },
              items: PetStatus.values
                  .map(
                    (label) => DropdownMenuItem(
                      child: Text(EnumToString.convertToString(label)),
                      value: EnumToString.convertToString(label),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                _status = EnumToString.fromString(PetStatus.values, value);
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: isEditing ? 'Сохранить изменения' : 'Добавить',
        child: Icon(isEditing ? Icons.check : Icons.add),
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
