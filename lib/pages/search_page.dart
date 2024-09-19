import 'package:bus_researve/providers/app_data_provider.dart';
import 'package:bus_researve/utils/colors.dart';
import 'package:bus_researve/utils/custom_elevated_button.dart';
import 'package:bus_researve/utils/helper_functions.dart';
import 'package:bus_researve/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _fromCity, _toCity;
  DateTime? _departureDate;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Reservation"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            children: [
              // Select a City
              DropdownButtonFormField<String>(
                value: _fromCity,
                validator: validateItems,
                decoration: const InputDecoration(
                  labelText: 'Select a City',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
                items: cities
                    .map((city) => DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _fromCity = newValue; // Update selected city
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              // Destination
              DropdownButtonFormField<String>(
                value: _toCity,
                validator: validateItems,
                decoration: const InputDecoration(
                  label: Text("Destination"),
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
                items: cities
                    .map((city) => DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _toCity = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomElevatedButton(
                      label: "Departure Date",
                      onPressed: _selectDate,
                      backgroundColor: primaryColor,
                      textColor: secondaryColor),
                  const SizedBox(width: 10),
                  Text(
                    _departureDate == null
                        ? "No Date Chosen"
                        : getFormattedDate(_departureDate!,
                            pattern: 'dd MMM, EEE, yyyy'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              // Search Button
              CustomElevatedButton(
                  label: "Search",
                  onPressed: _search,
                  backgroundColor: primaryColor,
                  textColor: secondaryColor)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (selectedDate != null) {
      setState(() {
        _departureDate = selectedDate;
      });
    }
  }

  void _search() {
    if (_departureDate == null) {
      showMsg(context, emptyDateErrMessage);
      return;
    }
    if (_formKey.currentState!.validate()) {
      Provider.of<AppDataProvider>(context, listen: false)
          .getRouteByCityFromAndCityTo(_fromCity!, _toCity!)
          .then((route) {
        if (!mounted) return;
        if (route != null) {
          Navigator.pushNamed(
            context,
            routeNameSearchResultPage,
            arguments: {
              'route': route,
              'departureDate': getFormattedDate(_departureDate!),
            },
          );
        } else {
          showMsg(context, 'No route found for the selected cities.');
        }
      });
    }
  }
}
