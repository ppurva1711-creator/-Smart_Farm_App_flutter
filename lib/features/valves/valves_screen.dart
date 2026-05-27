import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dashboard/providers/dashboard_provider.dart';
import '../dashboard/widgets/bottom_navbar.dart';

import 'widgets/valve_card.dart';

class ValvesScreen extends ConsumerWidget {

  const ValvesScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {

    final dashboardAsync =
        ref.watch(
      dashboardStreamProvider,
    );

    return dashboardAsync.when(

      data: (event) {

        final data =
            event.snapshot.value
                as Map<dynamic, dynamic>;

        final valves =
            data["valves"] ?? {};

        return Scaffold(

          backgroundColor:
              const Color(
            0xFFF7F3EE,
          ),

          appBar: AppBar(

            title: const Text(
              "Valves Control",
            ),

            centerTitle: true,

            backgroundColor:
                Colors.orange,

            foregroundColor:
                Colors.white,
          ),

          body: ListView(

            padding:
                const EdgeInsets.all(
              16,
            ),

            children: [

              ...valves.entries
                  .map((entry) {

                return ValveCard(

                  valveId:
                      entry.key,

                  valveData:
                      entry.value,
                );
              }).toList(),
            ],
          ),

          bottomNavigationBar:
              const BottomNavbar(
            currentIndex: 1,
          ),
        );
      },

      loading: () =>
          const Scaffold(

        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      ),

      error: (e, _) =>
          Scaffold(

        body: Center(
          child:
              Text(e.toString()),
        ),
      ),
    );
  }
}