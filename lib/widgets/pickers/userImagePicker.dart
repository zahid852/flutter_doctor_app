import 'dart:io';

import 'package:doctors_app/presentation/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../presentation/styles_manager.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.pickImageFunction);
  final void Function(File) pickImageFunction;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImageByUser;
  void _showPicker() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 20, 0, 10),
                      child: Text(
                        'Select mode',
                        style: getMediumStyle(
                            color: ColorManager.primery, fontsize: 18),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                      child: ListTile(
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: ColorManager.primery,
                        ),
                        leading: Icon(
                          Icons.camera,
                          color: ColorManager.primery,
                        ),
                        title: Text(
                          'Gallery',
                          style: getRegulerStyle(
                              color: ColorManager.primery, fontsize: 16),
                        ),
                        onTap: () {
                          _ImageFromGallery();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                      child: ListTile(
                        trailing: Icon(Icons.arrow_forward,
                            color: ColorManager.primery),
                        leading: Icon(
                          Icons.camera_alt_rounded,
                          color: ColorManager.primery,
                        ),
                        title: Text('Camera',
                            style: getRegulerStyle(
                                color: ColorManager.primery, fontsize: 16)),
                        onTap: () {
                          _ImageFromCamera();
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                )),
          );
        });
  }

  _ImageFromGallery() async {
    var image = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 70, maxWidth: 150);
    setState(() {
      pickedImageByUser = File(image!.path);
    });
    widget.pickImageFunction(pickedImageByUser!);
  }

  _ImageFromCamera() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 70, maxWidth: 150);
    setState(() {
      pickedImageByUser = File(image!.path);
    });
    widget.pickImageFunction(pickedImageByUser!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          backgroundImage:
              pickedImageByUser != null ? FileImage(pickedImageByUser!) : null,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.002,
        ),
        TextButton.icon(
            onPressed: _showPicker,
            icon: Icon(
              Icons.image,
              color: Colors.white,
            ),
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.white12),
            ),
            label: Text(
              'Add Image',
              style: getRegulerStyle(color: Colors.white, fontsize: 16),
            ))
      ],
    );
  }
}
