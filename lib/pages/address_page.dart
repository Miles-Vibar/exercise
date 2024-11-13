import 'package:address_app/bloc/address_bloc/address_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/address_bloc/address_bloc.dart';
import '../bloc/address_bloc/address_state.dart';
import '../widgets/drop_down_widget.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final regionController = TextEditingController();
  final provinceController = TextEditingController();
  final cityController = TextEditingController();
  final barangayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listenWhen: (prev, curr) => prev.isLoading != curr.isLoading,
        listener: (context, state) {
          print(state.isLoading);
        },
        builder: (context, state) {
          if (state.region != null) regionController.text = state.region!;
          if (state.province != null) provinceController.text = state.province!;
          if (state.city != null) cityController.text = state.city!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                DropDownWidget(
                  label: "Region",
                  location: state.regionsList?.regions,
                  controller: regionController,
                  onChanged: (String value) {
                    context
                        .read<AddressBloc>()
                        .add(GetProvincesEvent(region: value));
                    provinceController.clear();
                    cityController.clear();
                    barangayController.clear();
                  },
                ),
                const SizedBox(
                  height: 4.0,
                ),
                DropDownWidget(
                  label: "Province",
                  location: state.provincesList,
                  controller: provinceController,
                  onChanged: (String value) {
                    context
                        .read<AddressBloc>()
                        .add(GetCitiesEvent(province: value));
                    cityController.clear();
                    barangayController.clear();
                  },
                ),
                const SizedBox(
                  height: 4.0,
                ),
                DropDownWidget(
                  label: "City",
                  location: state.citiesList,
                  controller: cityController,
                  onChanged: (String value) {
                    context
                        .read<AddressBloc>()
                        .add(GetBarangaysEvent(city: value));
                    barangayController.clear();
                  },
                ),
                const SizedBox(
                  height: 4.0,
                ),
                DropDownWidget(
                  label: "Barangay",
                  location: state.barangaysList,
                  controller: barangayController,
                  onChanged: (String value) {
                    context
                        .read<AddressBloc>()
                        .add(InsertMissingFieldsEvent(barangay: value));
                  },
                ),
                const SizedBox(
                  height: 4.0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
