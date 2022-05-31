import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessappadmin/datamodels/challenges_model.dart';
import 'package:fitnessappadmin/datamodels/workout_model.dart';
import 'package:fitnessappadmin/repositories/client_repo.dart';
import 'package:fitnessappadmin/resources/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class WorkoutPage extends StatefulWidget {
  final ChallengesModel data;
  const WorkoutPage({Key? key, required this.data}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late List<WorkoutModel> data;
  final ClientRepository clientRepository = ClientRepository();

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  _loadEmail() async {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 4,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Image.network(
                  widget.data.image,
                  fit: BoxFit.cover,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(widget.data.title,
                        style: GoogleFonts.lato(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<List<WorkoutModel>>(
                stream: clientRepository.getWorkoutData(
                  widget.data.title.toLowerCase().replaceAll(' ', ''),
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    data = snapshot.data!;
                    return ListView.builder(
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              BottomDialogEdit(
                                context,
                                snapshot.data![index].title,
                                snapshot.data![index].description,
                                snapshot.data![index].image,
                                snapshot.data![index].rest,
                                snapshot.data![index].duration,
                              );
                            },
                            onLongPress: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text('Delete item'),
                                  content: const Text('Are you sure?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => deleteItem(
                                          snapshot.data![index].title),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Lottie.network(
                                        snapshot.data![index].image,
                                        repeat: true,
                                        frameRate: FrameRate(24)),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(snapshot.data![index].title,
                                                style: GoogleFonts.lato(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors
                                                        .secondaryColor)),
                                            Text(
                                                "x ${snapshot.data![index].duration}",
                                                style: GoogleFonts.lato(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: AppColors
                                                        .secondaryColor)),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ),
          const SizedBox(
            height: 80,
          )
        ],
      )),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
        ),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.mainColor,
          onPressed: () {
            BottomDialog(context);
          },
          elevation: 0,
          label: const Text(
            "Add new item",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }

  deleteItem(String title) {
    try {
      clientRepository.deleteChallengeItem(
        title,
        widget.data.title.toLowerCase().replaceAll(' ', ''),
      );
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success",
                  style: GoogleFonts.lato(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  )),
              content: Text("A new diet has been deleted",
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  )),
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Oops Something went wrong",
                  style: GoogleFonts.lato(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  )),
              content: Text(e.toString(),
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  )),
            );
          });
    }
  }

  BottomDialogEdit(BuildContext context, String title, String desc,
      String image, String rest, String duration) {
    ClientRepository clientRepository = ClientRepository();
    final _formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final imageController = TextEditingController();
    final restController = TextEditingController();
    final durationController = TextEditingController();

    titleController.text = title;
    descController.text = desc;
    imageController.text = image;
    restController.text = rest;
    durationController.text = duration;

    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TextFormField(
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter the title';
                          //     }
                          //     return null;
                          //   },
                          //   style: GoogleFonts.lato(),
                          //   controller: titleController,
                          //   decoration: InputDecoration(
                          //     focusedBorder: const OutlineInputBorder(
                          //       borderSide:
                          //           BorderSide(color: Colors.blue, width: 0.1),
                          //     ),
                          //     enabledBorder: const OutlineInputBorder(
                          //       borderSide:
                          //           BorderSide(color: Colors.grey, width: 0.1),
                          //     ),
                          //     hintText: "Title",
                          //     hintStyle: GoogleFonts.lato(),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the image link';
                              }
                              return null;
                            },
                            style: GoogleFonts.lato(),
                            controller: imageController,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 0.1),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.1),
                              ),
                              hintText: "Image Link",
                              hintStyle: GoogleFonts.lato(),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the duration';
                              }
                              return null;
                            },
                            style: GoogleFonts.lato(),
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 0.1),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.1),
                              ),
                              hintText: "Duration (sec)",
                              hintStyle: GoogleFonts.lato(),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the rest period';
                              }
                              return null;
                            },
                            style: GoogleFonts.lato(),
                            controller: restController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 0.1),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.1),
                              ),
                              hintText: "Rest (sec)",
                              hintStyle: GoogleFonts.lato(),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the description';
                              }
                              return null;
                            },
                            style: GoogleFonts.lato(),
                            controller: descController,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 0.1),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.1),
                              ),
                              hintText: "Descriptions",
                              hintStyle: GoogleFonts.lato(),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                if (_formKey.currentState!.validate()) {
                                  updateChallenge(
                                      titleController.text,
                                      widget.data.title
                                          .toLowerCase()
                                          .replaceAll(' ', ''),
                                      imageController.text,
                                      durationController.text,
                                      restController.text,
                                      descController.text);
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              height: 50,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.mainColor,
                                      AppColors.mainColor
                                    ],
                                    end: Alignment.bottomCenter,
                                    begin: Alignment.topCenter,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              alignment: Alignment.center,
                              child: const Text("U P D A T E",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          );
        });
  }

  BottomDialog(BuildContext context) {
    ClientRepository clientRepository = ClientRepository();
    final _formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final imageController = TextEditingController();
    final restController = TextEditingController();
    final durationController = TextEditingController();

    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the title';
                              }
                              return null;
                            },
                            style: GoogleFonts.lato(),
                            controller: titleController,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 0.1),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.1),
                              ),
                              hintText: "Title",
                              hintStyle: GoogleFonts.lato(),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the image link';
                              }
                              return null;
                            },
                            style: GoogleFonts.lato(),
                            controller: imageController,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 0.1),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.1),
                              ),
                              hintText: "Image Link",
                              hintStyle: GoogleFonts.lato(),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the duration';
                              }
                              return null;
                            },
                            style: GoogleFonts.lato(),
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 0.1),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.1),
                              ),
                              hintText: "Duration (sec)",
                              hintStyle: GoogleFonts.lato(),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the rest period';
                              }
                              return null;
                            },
                            style: GoogleFonts.lato(),
                            controller: restController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 0.1),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.1),
                              ),
                              hintText: "Rest (sec)",
                              hintStyle: GoogleFonts.lato(),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the description';
                              }
                              return null;
                            },
                            style: GoogleFonts.lato(),
                            controller: descController,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 0.1),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.1),
                              ),
                              hintText: "Descriptions",
                              hintStyle: GoogleFonts.lato(),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                if (_formKey.currentState!.validate()) {
                                  createNewDiet(
                                      titleController.text,
                                      widget.data.title
                                          .toLowerCase()
                                          .replaceAll(' ', ''),
                                      imageController.text,
                                      durationController.text,
                                      restController.text,
                                      descController.text);
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              height: 50,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.mainColor,
                                      AppColors.mainColor
                                    ],
                                    end: Alignment.bottomCenter,
                                    begin: Alignment.topCenter,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              alignment: Alignment.center,
                              child: const Text("C R E A T E",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          );
        });
  }

  createNewDiet(String title, String docName, String image, String duration,
      String rest, String desc) {
    print(docName);
    try {
      clientRepository.addChallengeItme(
          title, docName, image, duration, rest, desc);

      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success",
                  style: GoogleFonts.lato(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  )),
              content: Text("A new challenge has been created",
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  )),
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Oops Something went wrong",
                  style: GoogleFonts.lato(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  )),
              content: Text(e.toString(),
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  )),
            );
          });
    }
  }

  updateChallenge(String title, String docName, String image, String duration,
      String rest, String desc) {
    print("$title $docName");
    try {
      clientRepository.updateChallengeItem(
          docName, title, image, desc, duration, rest);

      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success",
                  style: GoogleFonts.lato(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  )),
              content: Text("A new challenge has been updated",
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  )),
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Oops Something went wrong",
                  style: GoogleFonts.lato(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  )),
              content: Text(e.toString(),
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  )),
            );
          });
    }
  }
}
