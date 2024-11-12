import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({
    super.key,
    required this.label,
    required this.location,
    required this.controller,
    required this.onChanged,
  });

  final List<dynamic>? location;
  final ValueChanged<String> onChanged;
  final String label;
  final TextEditingController controller;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      dropdownMenuEntries: widget.location
              ?.map((location) => DropdownMenuEntry(
                    value: location.name,
                    label: location.name,
                  ))
              .toList() ?? [' ']
              .map((location) => DropdownMenuEntry(
                    enabled: false,
                    value: location,
                    label: location,
                  ))
              .toList(),
      menuHeight: 300.0,
      enableFilter: true,
      focusNode: FocusNode(),
      controller: widget.controller,
      enableSearch: true,
      expandedInsets: EdgeInsets.zero,
      label: Text(widget.label),
      onSelected: (value) => widget.onChanged(value),
      filterCallback: (entries, filter) {
        //returning only the first 10 entries before and after filtering because of lag if all entries are rendered.
        var list = entries
            .where((entry) => entry.label.toLowerCase().contains(filter.toLowerCase()))
            .take(10)
            .toList();

        return list.isEmpty ? ['No entry found!']
            .map((location) => DropdownMenuEntry(
          enabled: false,
          value: location,
          label: location,
        ))
            .toList()
            : list;
      },
      hintText: 'Showing first 10 entries...',
    );
  }
}
