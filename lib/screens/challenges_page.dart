import 'package:fitnessappadmin/datamodels/challenges_model.dart';
import 'package:fitnessappadmin/repositories/client_repo.dart';
import 'package:fitnessappadmin/resources/appcolors.dart';
import 'package:fitnessappadmin/route/router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({Key? key}) : super(key: key);

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
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
                  Navigator.pushNamed(context, addNewChallengeRoute);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "Add New Challenge",
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
              Text("All Challenges",
                  style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor)),
              const SizedBox(
                height: 16,
              ),
              StreamBuilder<List<ChallengesModel>>(
                  stream: clientRepository.getAllChallenges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              margin: const EdgeInsets.only(bottom: 8),
                              width: double.infinity,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, workoutRoute,
                                      arguments: snapshot.data![index]);
                                },
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
}
