import 'package:flutter/material.dart';
import 'package:extra_credit/helper.dart';

import 'dogs.dart';

class AddDogs extends StatefulWidget {
  AddDogs({Key? key, this.dog}) : super(key: key);
  //here i add a variable
  //it is not a required, but use this when update
  final Dog? dog;

  @override
  State<AddDogs> createState() => _AddDogsState();
}

class _AddDogsState extends State<AddDogs> {
  //for TextField
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();

  @override
  void initState() {
    //when contact has data, mean is to update
    //instead of create new contact
    if (widget.dog != null) {
      _nameController.text = widget.dog!.name;
      _breedController.text = widget.dog!.breed;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Dogs to List'),
        backgroundColor: Color.fromARGB(255, 255, 138, 66),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(false),
          //to prevent back button pressed without add/update
        ),
      ),
      body: Center(
        //create two text field to key in name and contact
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTextField(_nameController, 'Name'),
              SizedBox(
                height: 30,
              ),
              _buildTextField(_breedController, 'Breed'),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 212, 105, 73), // background
                  onPrimary: Colors.white, // foreground
                ),
                //this button is pressed to add contact
                onPressed: () async {
                  //if contact has data, then update existing list
                  //according to id
                  //else create a new contact
                  if (widget.dog != null) {
                    await DBHelper.updateDogLists(Dog(
                      id: widget.dog!.id, //have to add id here
                      name: _nameController.text,
                      breed: _breedController.text,
                    ));

                    Navigator.of(context).pop(true);
                  } else {
                    await DBHelper.createDogLists(Dog(
                      name: _nameController.text,
                      breed: _breedController.text,
                    ));

                    Navigator.of(context).pop(true);
                  }
                },
                child: Text('Add to Dog List'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //build a text field method
  TextField _buildTextField(TextEditingController _controller, String hint) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: hint,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }
}
