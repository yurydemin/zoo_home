import 'package:flutter/material.dart';

class SearchTextfield extends StatefulWidget {
  final String searchFilter;
  final ValueChanged<String> onChanged;

  const SearchTextfield(
      {@required this.searchFilter, @required this.onChanged});

  @override
  _SearchTextfieldState createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchFilter);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Найти зоодом',
        labelStyle: TextStyle(color: Colors.white),
        //floatingLabelBehavior: FloatingLabelBehavior.never,
        icon: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      onChanged: widget.onChanged,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
