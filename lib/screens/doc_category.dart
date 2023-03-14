import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctors_app/data/doc_cat_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/presentations.dart';
import '../widgets/widgets.dart';

class doc_cat extends StatefulWidget {
  static const id = './doc_cat';
  @override
  State<doc_cat> createState() => _doc_catState();
}

class _doc_catState extends State<doc_cat> {
  final _imageUrlFocusNode = FocusNode();
  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    // TODO: implement initState
    super.initState();
  }

  updateImageUrl() {
    setState(() {});
  }

  bool isSaving = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController cat_name = TextEditingController();
  TextEditingController cat_des = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(),
      body: Container(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: MediaQuery.of(context).size.height * 0.24,
              color: ColorManager.primery,
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  _scaffoldKey.currentState!.openDrawer(),
                              child: Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.235,
                            ),
                            Text(
                              'DoctorZone',
                              style: getRegulerStyle(
                                  color: Colors.white, fontsize: 24),
                            )
                          ],
                        )),
                    Container(
                      padding: EdgeInsets.only(left: 30),
                      height: MediaQuery.of(context).size.height * 0.1,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add Category',
                        style:
                            getRegulerStyle(color: Colors.white, fontsize: 24),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      height: MediaQuery.of(context).size.height * 0.719,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 10,
                                  color: Colors.black12),
                            ]),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 25),
                            child: Column(
                              children: [
                                Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          onSaved: (value) {},
                                          controller: cat_name,
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.category),
                                              hintText: 'Category',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          appSize.s16))),
                                        ),
                                        SizedBox(
                                          height: appSize.s20,
                                        ),
                                        TextFormField(
                                          controller: cat_des,
                                          decoration: InputDecoration(
                                              prefixIcon:
                                                  Icon(Icons.description),
                                              hintText: 'Description',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          appSize.s16))),
                                        ),
                                        SizedBox(
                                          height: appSize.s20,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.url,
                                          // textInputAction: TextInputAction.done,
                                          controller: imageUrlController,
                                          // focusNode: _imageUrlFocusNode,
                                          decoration: InputDecoration(
                                              prefixIcon:
                                                  Icon(Icons.description),
                                              hintText: 'Category ImageUrl',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          appSize.s16))),
                                        ),
                                        SizedBox(
                                          height: appSize.s20,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.21,
                                          child: imageUrlController.text.isEmpty
                                              ? Center(
                                                  child: Text(
                                                    'Category Image',
                                                    style: getRegulerStyle(
                                                        color:
                                                            Colors.grey[600]!,
                                                        fontsize: 16),
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.network(
                                                    imageUrlController.text,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.035,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: isSaving
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ElevatedButton.icon(
                                          style: getApplicationTheme()
                                              .elevatedButtonTheme
                                              .style,
                                          onPressed: () async {
                                            setState(() {
                                              isSaving = true;
                                            });
                                            await Provider.of<doc_cat_data>(
                                                    context,
                                                    listen: false)
                                                .add_cat(doc_cat_model(
                                                    cat: cat_name.text,
                                                    des: cat_des.text,
                                                    cat_image:
                                                        imageUrlController
                                                            .text));
                                            cat_name.clear();
                                            cat_des.clear();
                                            imageUrlController.clear();

                                            FocusScope.of(context).unfocus();
                                            setState(() {
                                              isSaving = false;
                                            });
                                          },
                                          icon: Icon(Icons.save),
                                          label: Text('Add Category',
                                              style: getBoldStyle(
                                                  color: Colors.white,
                                                  fontsize: appSize.s18))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
