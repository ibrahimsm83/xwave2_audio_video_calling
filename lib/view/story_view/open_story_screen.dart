import 'package:chat_app_with_myysql/util/assets_manager.dart';
import 'package:chat_app_with_myysql/view/story_view/model.dart';
import 'package:flutter/material.dart';
import 'package:story/story_page_view.dart';



class UserModel {
  UserModel(this.stories, this.userName, this.imageUrl);
  final List<StoryModel> stories;
  final String userName;
  final String imageUrl;
}

class StoryModel {
  StoryModel(this.imageUrl,this.type);
  final String imageUrl;
  final String type;
}

class OpenStoryView extends StatefulWidget {

  List<StoryViewModel>? status;
   OpenStoryView({Key? key,this.status}) : super(key: key);

  @override
  State<OpenStoryView> createState() => _OpenStoryViewState();
}

class _OpenStoryViewState extends State<OpenStoryView> {
  late ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;

  // final sampleUsers = [
  //   UserModel(
  //     // [
  //     //   StoryModel(
  //     //     ImageAssets.person1,
  //     //     //  "https://images.unsplash.com/photo-1601758228041-f3b2795255f1?ixid=MXwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxN3x8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
  //     //   ),
  //     //   StoryModel(
  //     //     ImageAssets.person2,
  //     //     // "https://images.unsplash.com/photo-1609418426663-8b5c127691f9?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyNXx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
  //     //   ),
  //     //   StoryModel(
  //     //     ImageAssets.person3,
  //     //     // "https://images.unsplash.com/photo-1609444074870-2860a9a613e3?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1Nnx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
  //     //   ),
  //     //   StoryModel(
  //     //     ImageAssets.person4,
  //     //     // "https://images.unsplash.com/photo-1609504373567-acda19c93dc4?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1MHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
  //     //   ),
  //     // ],
  //     "User1",
  //     ImageAssets.person5,
  //     //"https://images.unsplash.com/photo-1609262772830-0decc49ec18c?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzMDF8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
  //   ),
  //   // UserModel(
  //   //   [
  //   //     StoryModel(
  //   //       ImageAssets.person1,
  //   //       // "https://images.unsplash.com/photo-1609439547168-c973842210e1?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw4Nnx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
  //   //     ),
  //   //   ],
  //   //   "User2",
  //   //   ImageAssets.person6,
  //   //   //"https://images.unsplash.com/photo-1601758125946-6ec2ef64daf8?ixid=MXwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwzMjN8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
  //   // ),
  //   // UserModel(
  //   //   [
  //   //     StoryModel(
  //   //       ImageAssets.person3,
  //   //       //"https://images.unsplash.com/photo-1609421139394-8def18a165df?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxMDl8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
  //   //     ),
  //   //     StoryModel(
  //   //       ImageAssets.person2,
  //   //       //"https://images.unsplash.com/photo-1609377375732-7abb74e435d9?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxODJ8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
  //   //     ),
  //   //     StoryModel(
  //   //       ImageAssets.person1,
  //   //       // "https://images.unsplash.com/photo-1560925978-3169a42619b2?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyMjF8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
  //   //     ),
  //   //   ],
  //   //   "User3",
  //   //   ImageAssets.person7,
  //   //   //"https://images.unsplash.com/photo-1609127102567-8a9a21dc27d8?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzOTh8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
  //   // ),
  // ];

  List<StoryModel> storyList=[];
  List<UserModel> sampleUsers=[];
  void setUserStatus(){
    for(int i=0;i<widget.status!.length;i++){
      if(widget.status![i].media!.isNotEmpty){
        storyList.add(StoryModel(widget.status![i].media!.first.url!,widget.status![i].media!.first.type!));
      }
      else{
        continue;
      }
    }
     sampleUsers=[
      UserModel(
          storyList,
        "User1",
        ImageAssets.person2
      )
    ];
    setState(() {
    });
  }
  @override
  void initState() {
    super.initState();
    setUserStatus();
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
        IndicatorAnimationCommand.resume);
  }

  @override
  void dispose() {
    indicatorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryPageView(
        itemBuilder: (context, pageIndex, storyIndex) {
          final user = sampleUsers[pageIndex];
          final story = user.stories[storyIndex];
          return Stack(
            children: [
              Positioned.fill(
                child: Container(color: Colors.black),
              ),
              Positioned.fill(
                child: Image.network(
                  story.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 44, left: 8),
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(user.imageUrl),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      user.userName,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        gestureItemBuilder: (context, pageIndex, storyIndex) {
          return Stack(children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            // if (pageIndex == 0)
            //   Center(
            //     child: ElevatedButton(
            //       child: Text('show modal bottom sheet'),
            //       onPressed: () async {
            //         indicatorAnimationController.value =
            //             IndicatorAnimationCommand.pause;
            //         await showModalBottomSheet(
            //           context: context,
            //           builder: (context) => SizedBox(
            //             height: MediaQuery.of(context).size.height / 2,
            //             child: Padding(
            //               padding: EdgeInsets.all(24),
            //               child: Text(
            //                 'Look! The indicator is now paused\n\n'
            //                 'It will be coutinued after closing the modal bottom sheet.',
            //                 style: Theme.of(context).textTheme.headline5,
            //                 textAlign: TextAlign.center,
            //               ),
            //             ),
            //           ),
            //         );
            //         indicatorAnimationController.value =
            //             IndicatorAnimationCommand.resume;
            //       },
            //     ),
            //   ),
          ]);
        },
        indicatorAnimationController: indicatorAnimationController,
        initialStoryIndex: (pageIndex) {
          if (pageIndex == 0) {
            return 1;
          }
          return 0;
        },
        pageLength: sampleUsers.length,
        storyLength: (int pageIndex) {
          return sampleUsers[pageIndex].stories.length;
        },
        onPageLimitReached: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}