import 'package:bus_researve/models/bus_route.dart';
import 'package:bus_researve/models/bus_schedule.dart';
import 'package:bus_researve/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/schedule_item_view.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final BusRoute route = args['route'];
    final departureDate = args['departureDate'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bus Route Search',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // backgroundColor: Colors.black,
        elevation: 4.0,
      ),
      body: ListView(
        // padding: const EdgeInsets.all(12),
        children: [
          Text(
            'Destination: ${route.cityFrom} to ${route.cityTo} on $departureDate',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Consumer<AppDataProvider>(
            builder: (context, provider, _) => FutureBuilder<List<BusSchedule>>(
              future: provider.getScheduleByRouteName(route.routeName),
              builder: (BuildContext context,
                  AsyncSnapshot<List<BusSchedule>> snapshot) {
                if (snapshot.hasData) {
                  final scheduleList = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: scheduleList
                        .map((schedule) => ScheduleItemView(
                            date: departureDate, schedule: schedule))
                        .toList(),
                  );
                }
                if (snapshot.hasError) {
                  return const Text("Failed to fetch data!");
                }
                return const Text("Please Wait");
              },
            ),
          ),
        ],
      ),
    );
  }
}
