import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_com/core/layouts/bottom_bar_layout.dart';
import 'package:tree_com/core/utils/api.dart';
import 'package:tree_com/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:tree_com/presentation/pages/settings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();
    userBloc.add(GetUserProfile(null));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BottomBarLayout(
        currentIndex: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (context, anim1, anim2) =>
                                    const SettingsPage(),
                                transitionsBuilder:
                                    (context, anim1, anim2, child) {
                                  return SlideTransition(
                                    position: Tween(
                                            begin: const Offset(1, 0),
                                            end: Offset.zero)
                                        .animate(anim1),
                                    child: child,
                                  );
                                }));
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ))
                ],
              ),
              BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                if (state is UserProfileLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is UserProfileLoadingFailed) {
                  return Text(state.message);
                }
                if (state is UserProfileLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Positioned(child: Container(
                                  width: 76,
                                  height: 76,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    gradient: LinearGradient(
                                        begin: Alignment
                                            .topLeft,
                                        end: Alignment
                                            .bottomRight,
                                        colors: [
                                          Color(0xff7A57D1),
                                          Color(0xff4FC1E9),
                                          Color(0xff009E76)
                                        ]),
                                  ),
                                )),
                                Positioned(
                                  width: 70,
                                  height: 70,
                                  top: 3,
                                  left: 3,
                                  child: Image.asset(
                                    "assets/images/profile_placeholder.png",
                                    width: 70,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.userProfile.name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("@${state.userProfile.username}"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(state.userProfile.bio == null ? "Bio not added!" : state.userProfile.bio!),
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text("Tree Stories", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600),),
                      ),
                      Container(
                        width: width,
                        child: SingleChildScrollView(
                          child: Row(
                            children: state.userProfile.trees
                                .map((e) => Container(
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              SizedBox(
                                                width: 66,
                                                height: 66,
                                              ),
                                              Positioned(
                                                  width: 66,
                                                  height: 66,
                                                  top: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Color(0xff7A57D1),
                                                              Color(0xff5BE7C4)
                                                            ]),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                  )),
                                              Positioned(
                                                width: 60,
                                                height: 60,
                                                top: 3,
                                                left: 3,
                                                child: ClipRRect(
                                                  child: Image.network(
                                                    API.getImageUrl(e.imageUrl),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              e.title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade700),
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                }
                return const SizedBox();
              })
            ],
          ),
        ));
  }
}
