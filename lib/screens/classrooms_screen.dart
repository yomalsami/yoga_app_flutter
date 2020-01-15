import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';
import 'package:my_yoga_fl/screens/classroom_screen.dart';
import 'package:my_yoga_fl/screens/new_classroom_screen.dart';
import 'package:my_yoga_fl/stores/classrooms_store.dart';
import 'package:my_yoga_fl/widgets/button.dart';
import 'package:my_yoga_fl/widgets/search_field.dart';
import 'package:provider/provider.dart';

class ClassroomsScreen extends StatelessWidget {
  static const routeName = '/classes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.grey,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Классы",
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: _ClassroomsScreen(),
    );
  }
}

class _ClassroomsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        SearchField(),
        SizedBox(height: 15),
        _PredefinedClassesList(),
        SizedBox(height: 15),
        _ActiveClassesList(),
      ],
    );
  }
}

class _PredefinedClassesList extends StatelessWidget {
  Widget _getListItem(String title, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 150,
      width: 120,
      padding: EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: GoogleFonts.pTSansCaption(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16, // TODO: Words wrapping by letter
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Consumer<ClassroomsStore>(
        builder: (_, store, __) {
          return Observer(
            builder: (_) {
              if (store.predefinedClassrooms.isEmpty) {
                return Container(); // TODO: Empty list
              }

              return ListView.builder(
                itemCount: store.predefinedClassrooms.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (context, index) {
                  final classroom = store.predefinedClassrooms[index];

                  return Row(
                    children: <Widget>[
                      GestureDetector(
                        child: _getListItem(classroom.title, Colors.amber[200]),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ClassroomScreen(classroom: classroom);
                            },
                          ));
                        },
                      ),
                      SizedBox(width: 20),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ActiveClassesList extends StatelessWidget {
  Widget _classroomListItem(ClassroomModel classroom, BuildContext context) {
    return Container(
//      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200], width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[200],
            ),
          ),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                classroom.title,
                style: Theme.of(context).textTheme.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "0 асан",
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Consumer<ClassroomsStore>(
          builder: (_, store, __) {
            return Observer(
              builder: (_) => ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: store.usersClassrooms.length,
                itemBuilder: (_, index) {
                  final classroom = store.usersClassrooms[index]; // FIXME: Possible out of a range

                  return GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          // TODO: Add confirmDismiss with popup
                          store.deleteClassroom(classroom);
                        },
                        background: Container(
                          padding: EdgeInsets.only(right: 20),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            color: Colors.red[200],
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        child: _classroomListItem(classroom, context),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ClassroomScreen(classroom: classroom);
                        },
                      ));
                    },
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          child: Button(
            title: "Создать свой класс",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NewClassroomScreen();
              }));
            },
          ),
        ),
      ],
    );
  }
}
