import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessappadmin/repositories/client_repo.dart';
import 'package:fitnessappadmin/resources/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNewChallenges extends StatefulWidget {
  const AddNewChallenges({Key? key}) : super(key: key);

  @override
  State<AddNewChallenges> createState() => _AddNewChallengesPageState();
}

class _AddNewChallengesPageState extends State<AddNewChallenges> {
  ClientRepository clientRepository = ClientRepository();
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final calorieBurntController = TextEditingController();
  final imageController = TextEditingController();
  String dropdownGoal = "Weight Loss";
  bool isPopular = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    borderSide: BorderSide(color: Colors.blue, width: 0.1),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.1),
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
                    borderSide: BorderSide(color: Colors.blue, width: 0.1),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.1),
                  ),
                  hintText: "Image Link",
                  hintStyle: GoogleFonts.lato(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text("Select goal",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: DropdownButton<String>(
                  value: dropdownGoal,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownGoal = newValue!;
                    });
                  },
                  items: <String>[
                    'Weight Loss',
                    'Build Muscle',
                    'Body Tone',
                    'Fitness'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the calories burnt';
                  }
                  return null;
                },
                style: GoogleFonts.lato(),
                keyboardType: TextInputType.number,
                controller: calorieBurntController,
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 0.1),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.1),
                  ),
                  hintText: "Calories burnt",
                  hintStyle: GoogleFonts.lato(),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    value: isPopular,
                    onChanged: (bool? value) {
                      setState(() {
                        isPopular = value!;
                      });
                    },
                  ),
                  Text("is Popular")
                ],
              ),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    if (_formKey.currentState!.validate()) {
                      createNewChallenge();
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  height: 50,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.mainColor, AppColors.mainColor],
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
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
          )),
    ));
  }

  createNewChallenge() {
    try {
      clientRepository.createNewChallenge(
          titleController.text.toLowerCase().replaceAll(' ', ''),
          calorieBurntController.text,
          imageController.text,
          isPopular,
          titleController.text,
          dropdownGoal);

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
}
