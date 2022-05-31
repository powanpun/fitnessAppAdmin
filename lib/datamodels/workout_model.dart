import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WorkoutModel extends Equatable {
  final String title;
  final String image;
  final String duration;
  final String description;
  final String rest;

  const WorkoutModel({
    required this.title,
    required this.image,
    required this.duration,
    required this.description,
    required this.rest,
  });

  @override
  List<Object?> get props => [title];

  static WorkoutModel fromSnapshot(DocumentSnapshot snap) {
    WorkoutModel categoryModel = WorkoutModel(
      title: snap['title'],
      image: snap['image'],
      duration: snap['duration'],
      description: snap['description'],
      rest: snap['rest'],
    );
    return categoryModel;
  }
}
