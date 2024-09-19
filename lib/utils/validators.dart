import 'package:bus_researve/utils/constants.dart';

String? validateItems(String? value) {
  if (value == null || value.isEmpty) {
    return emptyFieldErrMessage;
  } else {
    return null;
  }
}
