import 'package:address_app/Pages/address_page.dart';
import 'package:address_app/bloc/address_bloc/address_bloc.dart';
import 'package:address_app/bloc/address_bloc/address_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBlocProvider extends StatelessWidget {
  const AddressBlocProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressBloc()..add(GetAllEvent()),
      child: const AddressPage(),
    );
  }
}
