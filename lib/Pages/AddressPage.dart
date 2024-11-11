import 'package:address_app/BLoC/LocationCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Models/StateModel.dart';
import '../Widgets/DropDownWidget.dart';

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
      body: BlocBuilder<LocationCubit, StateModel>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                DropDownWidget(
                  label: "Region",
                  location: context.read<LocationCubit>().regionsList?.regions,
                  controller: regionController,
                  function: context.read<LocationCubit>().getRegions(),
                  onChanged: (String value) {
                    context.read<LocationCubit>().filterProvinces(value);
                    provinceController.clear();
                    cityController.clear();
                    barangayController.clear();
                  },
                ),
                const SizedBox(height: 4.0,),
                DropDownWidget(
                  label: "Province",
                  location: context.read<LocationCubit>().provincesList,
                  controller: provinceController,
                  function: context.read<LocationCubit>().getRegions(),
                  onChanged: (String value) {
                    context.read<LocationCubit>().filterCities(value);
                    cityController.clear();
                    barangayController.clear();
                  },
                ),
                const SizedBox(height: 4.0,),
                DropDownWidget(
                  label: "City",
                  location: context.read<LocationCubit>().citiesList,
                  controller: cityController,
                  function: context.read<LocationCubit>().getRegions(),
                  onChanged: (String value) {
                    context.read<LocationCubit>().filterBarangays(value);
                    barangayController.clear();
                  },
                ),
                const SizedBox(height: 4.0,),
                DropDownWidget(
                  label: "Barangay",
                  location: context.read<LocationCubit>().barangaysList,
                  controller: barangayController,
                  function: context.read<LocationCubit>().getRegions(),
                  onChanged: (String value) => (),
                ),
                const SizedBox(height: 4.0,),
              ],
            ),
          );
        },
      ),
    );
  }
}