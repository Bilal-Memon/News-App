import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var imagePath;
  // var imageBase;
  var userName = '';
  var email = '';
  var phoneNumber = 'database';
  var address = 'database';
  var gender = 'database';
  var isSelected = [false, false];
  var genderItems = ['Male', 'Female'];
  var gname = '';
  var dateOfBirth;
  var user = FirebaseAuth.instance.currentUser;
  final CollectionReference profileList =
      FirebaseFirestore.instance.collection('User Detail');

  pickImage() async {
    // final _picker = ImagePicker();
    // final image = await _picker.pickImage(source: ImageSource.gallery);
    // var imageBase = path.basename(image!.path);
    // File file = File(image.path);
    // try {
    //   var ref = firebase_storage.FirebaseStorage.instance.ref(imageBase);
    //   await ref.putFile(file);
    //   var downloadURL = await ref.getDownloadURL();
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    File file = File(image!.path);
    setState(() {
      imagePath = file;
    });
    try {
      var imageBase = path.basename(image.path);
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref(imageBase);
      await ref.putFile(file);
      var downloadURL = await ref.getDownloadURL();
      user!.updatePhotoURL(downloadURL);
      // print(downloadURL);
      // if (image1 == '') {
      //   setState(() {
      //     image1 = downloadURL;
      //   });
      // } else if (image2 == '') {
      //   setState(() {
      //     image2 = downloadURL;
      //   })

    } catch (error) {
      print(error);
    }
  }

  updateProfile(title, name) => {
        title == 'User Name'
            ? {
                setState(() {
                  userName = name;
                }),
                user!.updateDisplayName(name)
              }
            : title == 'Email'
                ? {
                    setState(() {
                      email = name;
                    }),
                    user!.updateEmail(name)
                  }
                : title == 'Gender'
                    ? profileList.doc(user!.uid).update({'gender': name})
                    //                profileList.get().then((querySnapshot) {
                    //  querySnapshot.docs
                    //     .map((json) => setState((){
                    //       // phoneNumber=json['phone'];
                    //       gender=json['gender'];
                    //       // dateOfBirth=json['dateOfBirth'];
                    //       // address=json['address'];
                    //     }))
                    //     .toList();
                    // setState(() {
                    //     isSelected = [false, false];
                    //     genderItems = ['Male', 'Female'];
                    //     gender = name;
                    //   })
                    : title == 'Address'
                        ? setState(() {
                            address = name;
                          })
                        : null,
        print(name),
        Navigator.of(context).pop()
      };
  pickDate() async {
    FocusScope.of(context).unfocus();
    final initialDate = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year + 30),
    );
    final formatter = DateFormat('dd - MMM - yyyy');
    final String formatted = formatter.format(date!);
    setState(() {
      dateOfBirth = formatted;
    });
  }

  Widget genderProperty(name, context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.31,
      child: Text(
        name,
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget listtile(context, title, subtitle) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: title == 'Address'
            ? Container(
                height: height * 0.05,
                child: SingleChildScrollView(
                  child: Text(
                    subtitle,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey),
                  ),
                ),
              )
            : Text(
                subtitle,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey),
              ),
        trailing: GestureDetector(
            onTap: () {
              title == 'Gender'
                  ? showDialog(
                      builder: (context) =>
                          StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                              Container(
                                  height: height * 0.07,
                                  child: ToggleButtons(
                                    isSelected: isSelected,
                                    selectedColor: Colors.blue,
                                    color: Colors.black,
                                    selectedBorderColor: Colors.blue,
                                    renderBorder: true,
                                    borderColor: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    children: [
                                      genderProperty('Male', context),
                                      genderProperty('Female', context),
                                    ],
                                    onPressed: (int newIndex) {
                                      setState(() {
                                        for (int index = 0;
                                            index < isSelected.length;
                                            index++) {
                                          if (index == newIndex) {
                                            isSelected[index] = true;
                                            gname = genderItems[index];
                                          } else {
                                            isSelected[index] = false;
                                          }
                                        }
                                      });
                                    },
                                  )),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () => {
                                updateProfile(title, gname),
                              },
                              child: Text(
                                'Change',
                              ),
                            )
                          ],
                        );
                      }),
                      context: context,
                      barrierDismissible: true,
                    )
                  : title == 'Date of Birth'
                      ? pickDate()
                      : title == 'Address'
                          ? showDialog(
                              context: context,
                              builder: (context) {
                                var name = '';
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: TextFormField(
                                          onChanged: (e) => {name = e},
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 2,
                                          maxLength: 500,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                          decoration: new InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            counterText: '',
                                            // contentPadding: EdgeInsets.all(10),
                                            isDense: true,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.black,
                                                    )),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: const BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          updateProfile(title, name),
                                      child: Text(
                                        'Change',
                                      ),
                                    )
                                  ],
                                );
                              })
                          : showDialog(
                              context: context,
                              builder: (context) {
                                var name = '';
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        child: TextFormField(
                                          // keyboardType: type,
                                          // inputFormatters: formate,
                                          onChanged: (e) => {name = e},
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            // isDense: true,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.black,
                                                    )),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: const BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          updateProfile(title, name),
                                      child: Text(
                                        'Change',
                                      ),
                                    )
                                  ],
                                );
                              });
            },
            child: Icon(Icons.edit, color: Colors.grey)));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var phone = profileList.get().then((querySnapshot) {
      querySnapshot.docs.map((json) => phoneNumber = json['phone']).toList();
    });
    var dateOfBirthF = profileList.get().then((querySnapshot) {
      querySnapshot.docs
          .map((json) => dateOfBirth = '${json['dateOfBirth']}')
          .toList();
    });
    var genderF = profileList.get().then((querySnapshot) {
      querySnapshot.docs.map((json) => gender= json['gender']).toList();
    });
    // var addressF = profileList.get().then((querySnapshot) {
    //   querySnapshot.docs.map((json) => address=json['address']).toList();
    // });
    // profileList.get().then((querySnapshot) {
    //   querySnapshot.docs
    //       .map((json) => setState(() {
    //             phoneNumber = json['phone'];
    //             gender = json['gender'];
    //             dateOfBirth = json['dateOfBirth'];
    //             address = json['address'];
    //           }))
    //       .toList();
    // });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[300],
            leading: BackButton(
                color: Colors.white, onPressed: () => Navigator.pop(context)),
            title: Text('Profile',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
              // reverse: true,
              child: Column(mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                SizedBox(
                  height: height * 0.02,
                ),
                imagePath != null
                    ? MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                            onTap: pickImage,
                            child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 60,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 58,
                                  backgroundImage: FileImage(
                                    imagePath,
                                  ),
                                ))))
                    : user!.photoURL != null
                        ? MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                                onTap: pickImage,
                                child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 60,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 58,
                                      backgroundImage: NetworkImage(
                                        '${user!.photoURL}',
                                      ),
                                    ))))
                        : MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: pickImage,
                              child: Container(
                                  child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 60,
                                child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 58,
                                    // backgroundImage:
                                    // Image.asset('assets/images/user..png'),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_a_photo_outlined,
                                            size: 40, color: Colors.black),
                                        Text(
                                          'Add Image',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 16),
                                        ),
                                      ],
                                    )
                                    // Icon(Icons.add_a_photo_outlined,
                                    //     size: 40, color: Colors.black)
                                    ),
                              )),
                            ),
                          ),
                listtile(context, 'User Name',
                    userName != '' ? '${userName}' : '${user!.displayName}'),
                listtile(context, 'Email',
                    email != '' ? '${email}' : '${user!.email}'),
                listtile(context, 'Phone',
                    phoneNumber != '' ? '${phoneNumber}' : '${phone}'),
                listtile(
                    context, 'Gender', gender != '' ? '$gender' : '$genderF'),
                listtile(
                    context,
                    'Date of Birth',
                    dateOfBirth != null
                        ? '$dateOfBirth'
                        : dateOfBirthF), //dd - MMM - yyyy
                listtile(context, 'Address', 'addressF'),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                      onPressed:
                          //  _isButtonDisabled ? null :
                          () {
                        print(userName);
                        print(email);
                        print(phoneNumber);
                        print(address);
                      },
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue)),
                    )),
              ]))
          // )
          ),
    );
  }
}

// extension StringCasingExtension on String {
//   String toCapitalized() => this.length > 0 ?'${this[0].toUpperCase()}${this.substring(1)}':'';
//   String get toTitleCase => this.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.toCapitalized()).join(" ");
// }
