import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({super.key, required this.label, required this.location, required this.controller, required this.function, required this.onChanged});

  final List<dynamic>? location;
  final void function;
  final ValueChanged<String> onChanged;
  final String label;
  final TextEditingController controller;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  final focusNode = FocusNode();

  void check() {
    if (focusNode.hasFocus) {
      widget.function;
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(check);
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.removeListener(check);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      dropdownMenuEntries: widget.location?.map((location) => DropdownMenuEntry(value: location.name, label: location.name)).toList() ?? [].map((location) => DropdownMenuEntry(value: location, label: location)).toList(),
      menuHeight: 300.0,
      enableFilter: true,
      controller: widget.controller,
      enableSearch: true,
      focusNode: focusNode,
      expandedInsets: EdgeInsets.zero,
      label: Text(widget.label),
      onSelected: (value) => widget.onChanged(value),
      filterCallback: (entries, filter) {
        //returning only the first 20 entries before and after filtering because of lag if all entries are rendered.
        return entries.where((entry) => entry.label.toLowerCase().contains(filter.toLowerCase())).take(20).toList();
      },
      hintText: 'Showing first 20 entries...',
    );
  }
}