import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePickerrView extends StatefulWidget {
  const DateRangePickerrView({super.key});

  @override
  State<DateRangePickerrView> createState() => _DateRangePickerrViewState();
}

class _DateRangePickerrViewState extends State<DateRangePickerrView> {
  final DateRangePickerController _dateRangePickerController =
      DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfDateRangePicker(
          view: DateRangePickerView.month,
          monthViewSettings:
              const DateRangePickerMonthViewSettings(firstDayOfWeek: 6),
          selectionMode: DateRangePickerSelectionMode.multiRange,
          onSelectionChanged: _onSelectionChanged,
          showActionButtons: true,
          controller: _dateRangePickerController,
          onSubmit: (Object? value) {
            print(value);
          },
          onCancel: () {
            _dateRangePickerController.selectedRanges = null;
          },
        ),
      ),
    );
  }

  void _onSelectionChanged(
      DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
    print(dateRangePickerSelectionChangedArgs.value);
  }
}
