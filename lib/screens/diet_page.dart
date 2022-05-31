import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessappadmin/datamodels/diet_model.dart';
import 'package:fitnessappadmin/repositories/client_repo.dart';
import 'package:fitnessappadmin/resources/appcolors.dart';
import 'package:fitnessappadmin/route/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class DietPage extends StatefulWidget {
  const DietPage({Key? key}) : super(key: key);

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  final ClientRepository clientRepository = ClientRepository();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, addNewDietRoute);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "Add New Diet",
                    style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text("All Diets",
                  style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor)),
              const SizedBox(
                height: 16,
              ),
              StreamBuilder<List<DietModel>>(
                  stream: clientRepository.getAllDiets(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, editDietPageRoute,
                                    arguments: snapshot.data![index]);
                              },
                              onLongPress: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text('Delete item'),
                                    content: const Text('Are you sure?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => deleteDietItem(
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
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            bottomLeft: Radius.circular(8)),
                                        child: Image.network(
                                          snapshot.data![index].image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      height: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(snapshot.data![index].title,
                                              style: GoogleFonts.lato(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors
                                                      .secondaryColor)),
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ],
          ),
        ),
      )),
    );
  }

  deleteDietItem(String title) {
    try {
      clientRepository.deleteDietItem(title);

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
}
