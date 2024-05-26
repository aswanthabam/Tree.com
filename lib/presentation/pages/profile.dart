import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_com/core/layouts/bottom_bar_layout.dart';
import 'package:tree_com/core/utils/api.dart';
import 'package:tree_com/data/models/tree_model.dart';
import 'package:tree_com/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:tree_com/presentation/pages/settings.dart';
import 'package:tree_com/presentation/pages/story_viewer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late UserBloc userBloc;
  late OverlayEntry _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();
    userBloc.add(GetUserProfile(null));
  }

  OverlayEntry _createOverlayEntry(BuildContext context, Offset tapPosition) {
    return OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          double radius = 0;
          if (_animation.value < 1.0) {
            radius = 50 * _animation.value +
                MediaQuery.of(context).size.width * (1 - _animation.value);
          } else {
            radius = MediaQuery.of(context).size.width;
          }

          return Positioned(
            left: tapPosition.dx - radius / 2,
            top: tapPosition.dy - radius / 2,
            width: radius,
            height: radius,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                child: _animation.value == 1.0
                    ? Center(
                        child: GestureDetector(
                          onTap: () {
                            _controller.reverse().then((_) {
                              _overlayEntry.remove();
                            });
                          },
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPopup(BuildContext context, Offset tapPosition) {
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _overlayEntry = _createOverlayEntry(context, tapPosition);
    Overlay.of(context).insert(_overlayEntry);
    _controller.forward();
  }

  Widget _getStoryCard(TreeInfo tree) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => StoryViewer(
                treeInfo: tree,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = 0.0;
                var end = 1.0;
                var curve = Curves.easeOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var fadeAnimation = animation.drive(tween);

                return FadeTransition(
                  opacity: fadeAnimation,
                  child: ScaleTransition(
                    scale: fadeAnimation,
                    child: child,
                  ),
                );
              },
            ));
      },
      child: Container(
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
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xff7A57D1), Color(0xff5BE7C4)]),
                          borderRadius: BorderRadius.circular(50)),
                    )),
                Positioned(
                  width: 60,
                  height: 60,
                  top: 3,
                  left: 3,
                  child: ClipRRect(
                    child: Image.network(
                      API.getImageUrl(tree.imageUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(50),
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
                tree.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BottomBarLayout(
        currentIndex: 2,
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
            ),
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                    if (state is UserProfileLoading) {
                      return SizedBox(
                          height: height - 100,
                          child:
                              Center(child: const CircularProgressIndicator()));
                    }
                    if (state is UserProfileLoadingFailed) {
                      return Text(state.message);
                    }
                    if (state is UserProfileLoaded) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Positioned(
                                                child: Container(
                                              width: 86,
                                              height: 86,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color(0xff7A57D1),
                                                      Color(0xff4FC1E9),
                                                      Color(0xff009E76)
                                                    ]),
                                              ),
                                            )),
                                            Positioned(
                                              width: 80,
                                              height: 80,
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
                                        Container(
                                          width: width - 142,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        state.userProfile.name,
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          "@ ${state.userProfile.username}"),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .calendar_month,
                                                            size: 15,
                                                            color: Colors.green,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "${state.userProfile.streak}",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .green),
                                                          ),
                                                          Text(' Day Streak',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .green))
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      )
                                                    ],
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            PageRouteBuilder(
                                                                pageBuilder: (context,
                                                                        anim1,
                                                                        anim2) =>
                                                                    const SettingsPage(),
                                                                transitionsBuilder:
                                                                    (context,
                                                                        anim1,
                                                                        anim2,
                                                                        child) {
                                                                  return SlideTransition(
                                                                    position: Tween(
                                                                            begin: const Offset(1,
                                                                                0),
                                                                            end: Offset
                                                                                .zero)
                                                                        .animate(
                                                                            anim1),
                                                                    child:
                                                                        child,
                                                                  );
                                                                }));
                                                      },
                                                      icon: const Icon(
                                                        Icons.settings,
                                                        color: Colors.grey,
                                                      ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(state.userProfile.bio == null
                                        ? "Bio not added!"
                                        : state.userProfile.bio!),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0)),
                                        onPressed: () {},
                                        child: Container(
                                          width: width - 46,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Color(0x994FC1E9),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.edit,
                                                  color: Colors.grey.shade800),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Edit Profile",
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade800),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(
                                      "Tree Stories",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade600),
                                    ),
                                  ),
                                  Container(
                                    width: width,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: state.userProfile.trees
                                            .map((e) => _getStoryCard(e))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ],
                          )
                        ],
                      );
                    }
                    return const SizedBox();
                  })),
            ),
            SizedBox(
              height: height,
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero),
                  onPressed: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Color(0xff5BE7C4),
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Post",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ));
  }
}
