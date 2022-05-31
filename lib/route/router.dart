import 'package:fitnessappadmin/datamodels/challenges_model.dart';
import 'package:fitnessappadmin/datamodels/diet_model.dart';
import 'package:fitnessappadmin/screens/add_new_challenges.dart';
import 'package:fitnessappadmin/screens/add_new_diet.dart';
import 'package:fitnessappadmin/screens/bottom_navigation/bottom_navigation.dart';
import 'package:fitnessappadmin/screens/challenge_detail.dart';
import 'package:fitnessappadmin/screens/edit_diet_page.dart';
import 'package:flutter/material.dart';

const String bottomNavigationRoute = "bottomNavigationPage";
const String addNewDietRoute = "addNewDietPage";
const String addNewChallengeRoute = "addNewChallengePage";
const String workoutRoute = "workoutPage";
const String editDietPageRoute = "editDietPage";

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case bottomNavigationRoute:
        return MaterialPageRoute(
            builder: (context) => const NavigationHandlerPage());
      case addNewDietRoute:
        return MaterialPageRoute(builder: (context) => const AddDewDietPage());
      case workoutRoute:
        if (args is ChallengesModel) {
          return MaterialPageRoute(
              builder: (context) => WorkoutPage(data: args));
        }
        return throw ("error on args on workout page");

      case editDietPageRoute:
        if (args is DietModel) {
          return MaterialPageRoute(
              builder: (context) => EditDietPage(data: args));
        }
        return throw ("error on args on workout page");
      case addNewChallengeRoute:
        return MaterialPageRoute(
            builder: (context) => const AddNewChallenges());

      default:
        throw ("Route name does not exist");
    }
  }
}
