import 'package:flutter/material.dart';
import 'package:fyp_quiz/services/collection-service.dart';

class ViewQuestion extends StatelessWidget {
  final CollectionService service = CollectionService('keystroke_questions');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.dehaze),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return ViewQuestion();
              }));
            },
          ),
          title: Text("Questions"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Container(
                  width: double.infinity,
                  child: Text(
                    "category.toUpperCase(),",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                  )),
            ),
            Container(
              height: 300,
              child: StreamBuilder(
                stream: service.getCollection(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: const Text('Loading...'));
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width * 0.6,
                          margin: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen[100],
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Text(snapshot.data.documents[index]['question']),
                          // Text(snapshot.data.documents[index]['name']) ,
                        );
                      }

                      // crop(snapshot.data.documents[index], context)
                      );
                },
              ),
            ),
          ],
        ));
  }
}
