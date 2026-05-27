import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavbar extends StatelessWidget {

  final int currentIndex;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(

      currentIndex:
          currentIndex,

      onTap: (index) {

        if (index == 0) {

          context.go('/');
        }

        if (index == 1) {

          context.go('/valves');
        }
      },

      selectedItemColor:
          Colors.orange,

      unselectedItemColor:
          Colors.grey,

      type:
          BottomNavigationBarType.fixed,

      items: const [

        BottomNavigationBarItem(

          icon:
              Icon(Icons.home),

          label:
              'Dashboard',
        ),

        BottomNavigationBarItem(

          icon:
              Icon(Icons.water_drop),

          label:
              'Valves',
        ),
      ],
    );
  }
}