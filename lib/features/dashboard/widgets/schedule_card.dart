import 'package:flutter/material.dart';

import '../../../core/services/firebase_service.dart';

class ScheduleCard extends StatefulWidget {

  final Map schedules;

  const ScheduleCard({
    super.key,
    required this.schedules,
  });

  @override
  State<ScheduleCard> createState() =>
      _ScheduleCardState();
}

class _ScheduleCardState
    extends State<ScheduleCard> {

  final FirebaseService firebaseService =
      FirebaseService();

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> pickStartTime() async {

    final picked =
        await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.now(),
    );

    if (picked != null) {

      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> pickEndTime() async {

    final picked =
        await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.now(),
    );

    if (picked != null) {

      setState(() {
        endTime = picked;
      });
    }
  }

  void showAddScheduleDialog() {

    showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(24),
          ),

          title: const Text(
            "Add Schedule",
          ),

          content: Column(

            mainAxisSize:
                MainAxisSize.min,

            children: [

              ElevatedButton(

                onPressed:
                    pickStartTime,

                child: Text(
                  startTime == null
                      ? "Select Start Time"
                      : startTime!
                          .format(
                            context,
                          ),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton(

                onPressed:
                    pickEndTime,

                child: Text(
                  endTime == null
                      ? "Select End Time"
                      : endTime!
                          .format(
                            context,
                          ),
                ),
              ),
            ],
          ),

          actions: [

            TextButton(

              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                "Cancel",
              ),
            ),

            ElevatedButton(

              onPressed: () async {

                if (startTime != null &&
                    endTime != null) {

                  await firebaseService
                      .addSchedule(

                    start:
                        startTime!.format(
                          context,
                        ),

                    end:
                        endTime!.format(
                          context,
                        ),
                  );

                  Navigator.pop(context);

                  setState(() {});
                }
              },

              child: const Text(
                "Save",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: const [

                  Text(
                    "Pump Schedule",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "Automatic timing control",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              ElevatedButton.icon(

                onPressed:
                    showAddScheduleDialog,

                icon: const Icon(
                  Icons.add,
                ),

                label: const Text(
                  "Add",
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ...widget.schedules.entries
              .map((entry) {

            final scheduleId =
                entry.key;

            final schedule =
                entry.value;

            return Container(

              margin:
                  const EdgeInsets.only(
                bottom: 16,
              ),

              padding:
                  const EdgeInsets.all(16),

              decoration: BoxDecoration(

                color: schedule[
                        "enabled"]
                    ? Colors.purple.shade50
                    : Colors.grey.shade200,

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: Column(

                children: [

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    children: [

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Text(
                            "${schedule["start"]} → ${schedule["end"]}",

                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,

                              color:
                                  Colors.purple,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            schedule[
                                    "enabled"]
                                ? "Active"
                                : "Disabled",
                          ),
                        ],
                      ),

                      Switch(

                        value:
                            schedule[
                                "enabled"],

                        onChanged:
                            (value) async {

                          await firebaseService
                              .toggleSchedule(

                            scheduleId:
                                scheduleId,

                            enabled:
                                value,
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Align(

                    alignment:
                        Alignment.centerRight,

                    child: TextButton.icon(

                      onPressed: () async {

                        await firebaseService
                            .deleteSchedule(
                          scheduleId,
                        );
                      },

                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),

                      label: const Text(
                        "Delete",

                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}