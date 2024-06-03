import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_com/core/layouts/bottom_bar_layout.dart';
import 'package:tree_com/data/models/tree_model.dart';
import 'package:tree_com/presentation/bloc/posts_bloc/posts_bloc.dart';
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
  late PostsBloc postsBloc;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();
    postsBloc = context.read<PostsBloc>();
    userBloc.add(GetUserProfile(null));
    userBloc.stream.listen((event) {
      if (event is UserProfileLoaded) {
        postsBloc.add(GetPostsEvent(null));
      }
    });
  }

  Widget _getAddStoryCard() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'capture');
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
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 40,
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
                "Add Story",
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
                    child: Image (
                      image: NetworkImage(tree.imageUrl),
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
                                                      end:
                                                          Alignment.bottomRight,
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
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
                                                          state
                                                              .userProfile.name,
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
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              "${state.userProfile.streak}",
                                                              style: const TextStyle(
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
                                                                              begin: const Offset(1, 0),
                                                                              end: Offset.zero)
                                                                          .animate(anim1),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                    color:
                                                        Colors.grey.shade800),
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
                                          children: state.userProfile.trees.isEmpty ? [
                                            _getAddStoryCard()
                                          ] : state.userProfile.trees
                                              .map((e) => _getStoryCard(e))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    const Divider(),
                                    BlocBuilder<PostsBloc, PostsState>(
                                        builder: (context, state) {
                                      if (state is PostsLoading) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                      if (state is PostsLoadError) {
                                        return Text(state.message);
                                      }

                                      if (state is PostsLoaded) {
                                        final posts = state.posts.posts;
                                        if (posts.isEmpty) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, 'add_post');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.post_add,
                                                    size: 50,
                                                    color: Colors.grey.shade500,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "No posts yet!",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.grey.shade600),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Start sharing your thoughts and experiences with the community!",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.grey.shade600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                        return Container(
                                          width: width,
                                          child: GridView.count(
                                            padding: EdgeInsets.all(0),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            crossAxisCount: 3,
                                            children: posts
                                                .map((e) => Container(
                                                      margin: EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Stack(
                                                          children: [
                                                            if (e.imageUrl !=
                                                                null)
                                                              Positioned.fill(
                                                                  child: Image
                                                                      .network(
                                                                e.imageUrl!,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )),
                                                            if (e.content !=
                                                                null)
                                                              Positioned(
                                                                  bottom: 0,
                                                                  left: 0,
                                                                  right: 0,
                                                                  child:
                                                                      Container(
                                                                        height: e.imageUrl != null ? null : width / 3 - 10,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            5,
                                                                        vertical:
                                                                            5),
                                                                    decoration: BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                            begin:
                                                                                Alignment.topCenter,
                                                                            end: Alignment.bottomCenter,
                                                                            colors: [
                                                                              e.imageUrl != null
                                                                                  ? Colors.transparent
                                                                                  : Colors.black.withOpacity(0.5),
                                                                          Colors
                                                                              .black
                                                                              .withOpacity(0.5)
                                                                        ])),
                                                                    child: Text(
                                                                      e.content!.substring(0, min(e.imageUrl != null ? 30 : 100, e.content!.length)),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  )),
                                                          ],
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    }),
                                  ])
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
                  onPressed: () {
                    Navigator.pushNamed(context, 'add_post');
                  },
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
