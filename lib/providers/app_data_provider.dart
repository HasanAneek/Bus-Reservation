import 'package:bus_researve/datasource/data_source.dart';
import 'package:bus_researve/datasource/dummy_data_source.dart';
import 'package:bus_researve/models/bus_route.dart';
import 'package:bus_researve/models/bus_schedule.dart';
import 'package:flutter/cupertino.dart';

class AppDataProvider extends ChangeNotifier {
  final List<BusSchedule> _scheduleList = [];
  List<BusSchedule> get scheduleList => _scheduleList;

  final DataSource _dataSource = DummyDataSource();

  Future<BusRoute?> getRouteByCityFromAndCityTo(
      String cityFrom, String cityTo) {
    return _dataSource.getRouteByCityFromAndCityTo(cityFrom, cityTo);
  }

  Future<List<BusSchedule>> getScheduleByRouteName(String routeName) async {
    return _dataSource.getSchedulesByRouteName(routeName);
  }
}
