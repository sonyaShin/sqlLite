import 'package:flutter/material.dart';
import 'package:extra_credit/add_dogs.dart';
import 'package:extra_credit/dogs.dart';
import 'package:extra_credit/helper.dart';

class Demo extends StatefulWidget {
  Demo({Key? key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog List'),
        backgroundColor: Color.fromARGB(255, 255, 138, 66),
      ),
      //add Future Builder to get contacts
      body: FutureBuilder<List<Dog>>(
        future: DBHelper.readDogLists(), //read contacts list here
        builder: (BuildContext context, AsyncSnapshot<List<Dog>> snapshot) {
          //if snapshot has no data yet
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Loading...'),
                ],
              ),
            );
          }
          //if snapshot return empty [], show text
          //else show contact list
          return snapshot.data!.isEmpty
              ? Center(
                  child: Text('No Dogs on the List!'),
                )
              : ListView(
                  children: snapshot.data!.map((dogs) {
                    return Center(
                      child: ListTile(
                        title: Text(dogs.name),
                        subtitle: Text(dogs.breed),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await DBHelper.deleteDogLists(dogs.id!);
                            setState(() {
                              //rebuild widget after delete
                            });
                          },
                        ),
                        onTap: () async {
                          //tap on ListTile, for update
                          final refresh = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (_) => AddDogs(
                                        dog: Dog(
                                          id: dogs.id,
                                          name: dogs.name,
                                          breed: dogs.breed,
                                        ),
                                      )));

                          if (refresh) {
                            setState(() {
                              //if return true, rebuild whole widget
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final refresh = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => AddDogs()));

            if (refresh) {
              setState(() {
                //if return true, rebuild whole widget
              });
            }
          },
          backgroundColor: Color.fromARGB(228, 242, 139, 102),
          focusColor: Colors.blue,
          foregroundColor: Color.fromARGB(255, 255, 231, 157),
          hoverColor: Colors.green,
          splashColor: Colors.tealAccent),
    );
  }
}
