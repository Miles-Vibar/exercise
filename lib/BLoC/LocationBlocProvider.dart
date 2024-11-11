import 'package:address_app/BLoC/LocationCubit.dart';
import 'package:address_app/Models/StateModel.dart';
import 'package:address_app/Pages/AddressPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Locationblocprovider extends StatelessWidget {
  const Locationblocprovider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationCubit(StateModel(region: null, province: null, city: null)),
      child: const AddressPage(),
    );
  }
}
