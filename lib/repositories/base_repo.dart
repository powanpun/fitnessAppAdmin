import 'package:fitnessappadmin/datamodels/challenges_model.dart';
import 'package:fitnessappadmin/datamodels/diet_model.dart';
import 'package:fitnessappadmin/datamodels/workout_model.dart';

abstract class BaseRepository {
  Stream<List<ChallengesModel>> getAllChallenges();
  Stream<List<DietModel>> getAllDiets();
  Stream<List<WorkoutModel>> getWorkoutData(String title);
  Future<void> createNewDiet(
      String title, String description, String image, String type);
  Future<void> createNewChallenge(String docName, String caloriesBurnt,
      String image, bool isPopular, String title, String type);
  Future<void> deleteDietItem(String title);
  Future<void> deleteChallengeItem(String title, String docName);
  Future<void> updateChallengeItem(String docName, String title, String image,
      String desc, String duration, String rest);
  Future<void> updateDietItem(
      String title, String image, String type, String desc, String docTitle);
}
