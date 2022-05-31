import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessappadmin/datamodels/challenges_model.dart';
import 'package:fitnessappadmin/datamodels/diet_model.dart';
import 'package:fitnessappadmin/datamodels/workout_model.dart';
import 'package:fitnessappadmin/repositories/base_repo.dart';

class ClientRepository extends BaseRepository {
  final FirebaseFirestore _firebaseFirestore;

  ClientRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<ChallengesModel>> getAllChallenges() {
    return _firebaseFirestore
        .collection("challenges")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChallengesModel.fromSnapshot(doc))
          .toList();
    });
  }

  @override
  Stream<List<DietModel>> getAllDiets() {
    return _firebaseFirestore.collection("diets").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => DietModel.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> createNewDiet(
      String title, String description, String image, String type) {
    return _firebaseFirestore.collection("diets").add({
      "title": title,
      "description": description,
      "image": image,
      "type": type
    });
  }

  @override
  Future<void> deleteDietItem(String title) async {
    CollectionReference s = _firebaseFirestore.collection("diets");
    Query query = s.where("title", isEqualTo: title);
    QuerySnapshot querySnapshot = await query.get();

    querySnapshot.docs.forEach((element) {
      element.reference.delete();
    });
  }

  @override
  Future<void> deleteChallengeItem(String title, String docName) async {
    CollectionReference s = _firebaseFirestore
        .collection("challenges")
        .doc(docName)
        .collection("data");
    Query query = s.where("title", isEqualTo: title);
    QuerySnapshot querySnapshot = await query.get();

    querySnapshot.docs.forEach((element) {
      element.reference.delete();
    });
  }

  @override
  Future<void> addChallengeItme(String title, String docName, String image,
      String duration, String rest, String description) async {
    _firebaseFirestore
        .collection("challenges")
        .doc(docName)
        .collection("data")
        .add({
      "description": description,
      "duration": duration,
      "image": image,
      "rest": rest,
      "title": title
    });
  }

  @override
  Future<void> createNewChallenge(String docName, String caloriesBurnt,
      String image, bool isPopular, String title, String type) {
    return _firebaseFirestore.collection("challenges").doc(docName).set({
      "title": title,
      "caloriesBurnt": caloriesBurnt,
      "image": image,
      "type": type,
      "popular": isPopular
    });
  }

  @override
  Stream<List<WorkoutModel>> getWorkoutData(String title) {
    return _firebaseFirestore
        .collection("challenges")
        .doc(title)
        .collection("data")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => WorkoutModel.fromSnapshot(doc))
          .toList();
    });
  }

  @override
  Future<void> updateDietItem(String title, String image, String type,
      String desc, String docTitle) async {
    CollectionReference s = _firebaseFirestore.collection("diets");
    Query query = s.where("title", isEqualTo: docTitle);
    QuerySnapshot querySnapshot = await query.get();
    querySnapshot.docs.forEach((doc) {
      doc.reference.update(
          {'description': desc, 'image': image, 'title': title, 'type': type});
    });
  }

  @override
  Future<void> updateChallengeItem(String docName, String title, String image,
      String desc, String duration, String rest) async {
    CollectionReference s = _firebaseFirestore
        .collection("challenges")
        .doc(docName)
        .collection("data");
    Query query = s.where("title", isEqualTo: title);
    QuerySnapshot querySnapshot = await query.get();
    querySnapshot.docs.forEach((doc) {
      doc.reference.update({
        'description': desc,
        'image': image,
        'title': title,
        'duration': duration,
        'rest': rest
      });
    });
  }
}
