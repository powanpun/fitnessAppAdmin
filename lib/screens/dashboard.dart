import 'package:fitnessappadmin/datamodels/challenges_model.dart';
import 'package:fitnessappadmin/repositories/client_repo.dart';
import 'package:fitnessappadmin/resources/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final ClientRepository clientRepository = ClientRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          margin: const EdgeInsets.only(bottom: 8),
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              // Navigator.pushNamed(context, workoutRoute,
                              //     arguments: snapshot.data![index]);
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: 150,
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
                                  height: 150,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(snapshot.data![index].title,
                                          style: GoogleFonts.lato(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.secondaryColor)),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.local_fire_department,
                                            color: AppColors.mainColor,
                                            size: 16,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text("200 k/cl",
                                              style: GoogleFonts.lato(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors
                                                      .secondaryColor)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.timer,
                                            color: AppColors.mainColor,
                                            size: 16,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text("20 mins per day",
                                              style: GoogleFonts.lato(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors
                                                      .secondaryColor)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.wb_sunny,
                                            color: AppColors.mainColor,
                                            size: 16,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text("7 days",
                                              style: GoogleFonts.lato(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors
                                                      .secondaryColor)),
                                        ],
                                      )
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
    ));
  }
}
