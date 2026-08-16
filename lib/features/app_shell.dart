import 'package:flutter/material.dart';
import '../core/data/exercise_library.dart';
import '../core/models/exercise_model.dart';

import '../core/theme/app_colors.dart';
import 'home/presentation/home_screen.dart';
import 'practice/presentation/exercise_list_screen.dart';
import 'practice/presentation/paced_practice_screen.dart';
import 'progress/presentation/progress_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onNavigateToLibrary: () => _onTabSelected(1),
      ),
      const ExerciseListScreen(),
      PacedPracticeScreen(
        exercise: ClinicalExerciseLibrary.allExercises.firstWhere(
          (e) => e.category == ExerciseCategory.fluencyPacing,
          orElse: () => ClinicalExerciseLibrary.allExercises[0],
        ),
      ),
      const ProgressScreen(),

    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center, color: AppColors.primary),
            label: 'Exercises',
          ),
          NavigationDestination(
            icon: Icon(Icons.graphic_eq),
            selectedIcon: Icon(Icons.graphic_eq, color: AppColors.primary),
            label: 'Pacer',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart, color: AppColors.primary),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}
