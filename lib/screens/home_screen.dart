import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctors_app/data/datas.dart';
import 'package:doctors_app/screens/screens.dart';
import 'package:doctors_app/widgets/drawer.dart';
import 'package:doctors_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/presentations.dart';

class home_screen extends StatefulWidget {
  static const id = './home_screen';
  home_screen({required Key key}) : super(key: key);
  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  bool isLoading = false;
  TextEditingController search_cat = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future? data;
  @override
  void initState() {
    data = Provider.of<doc_cat_data>(context, listen: false).get_data('');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(),
      body: Column(
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
                    width: double.infinity,

                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.055,
                        vertical: MediaQuery.of(context).size.height * 0.0225),
                    height: MediaQuery.of(context).size.height * 0.1,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextField(
                              controller: search_cat,
                              decoration: InputDecoration(
                                  hintText: 'Search here',
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          width: MediaQuery.of(context).size.width * 0.13,
                          child: IconButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await Provider.of<doc_cat_data>(context,
                                        listen: false)
                                    .get_data(search_cat.text);
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              icon: Icon(Icons.search)),
                        )
                      ],
                    ),

                    // Text(
                    //   'Add Doctor',
                    //   style: getRegulerStyle(color: Colors.white, fontsize: 24),
                    // ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : FutureBuilder(
                    future: data,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Consumer<doc_cat_data>(
                        builder: (context, cat_data, _) => GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            itemCount: cat_data.cat_items.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3 / 2.4,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 15,
                            ),
                            itemBuilder: (context, ind) {
                              return GestureDetector(
                                onTap: () {
                                  List<doctor_model> data =
                                      Provider.of<doc_cat_data>(context,
                                              listen: false)
                                          .specific_cat_data(
                                              cat_data.cat_items[ind].cat);

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => profile(
                                            doc: data,
                                            cat: cat_data.cat_items[ind].cat,
                                            extra_details: cat_data.user_items,
                                          )));
                                },
                                child: ClipRect(
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    )),
                                    child: GridTile(
                                        child: Column(children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.11,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              cat_data.cat_items[ind].cat_image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          cat_data.cat_items[ind].cat,
                                          style: getRegulerStyle(
                                              color: Colors.black,
                                              fontsize: 14),
                                        ),
                                      ))
                                    ])),
                                  ),
                                ),
                              );
                            }),
                      );
                    }),
          )
        ],
      ),
    );
  }
}
