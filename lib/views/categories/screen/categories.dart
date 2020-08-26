import 'package:bookapp/model/categories.dart';
import 'package:bookapp/provider/categories_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/book/screen/my_loader.dart';
import 'package:bookapp/views/categories/screen/categories_detail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = "/categories_Screen";

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool selectView = false;
  bool _isloading = false;

  List<Categories> _categoryList = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
//    Provider.of<CategoryProvider>(context).getCategoryList();
//    _categoryList = Provider.of<CategoryProvider>(context).categoriesList;
  }

  Widget gridCategories(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Expanded(
      child: GridView.builder(
        itemCount: _categoryList.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
        padding: const EdgeInsets.all(4.0),
        itemBuilder: (ctx, index) => InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => CategoriesDetailsScreen(
                      categoryName: _categoryList[index].name,
                    )));
          },
          child: Container(
            margin: EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      _categoryList[index].imgUrl,
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                    )),
                Positioned(
                  left: size.width * 0.03,
                  top: size.height * 0.09,
                  child: Container(
                    width: 100,
                    child: Text(
                      _categoryList[index].name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listCategories(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Expanded(
        child: ListView.builder(
      itemCount: _categoryList.length,
      itemBuilder: (ctx, index) => InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => CategoriesDetailsScreen(
                    categoryName: _categoryList[index].name,
                  )));
        },
        child: Container(
            margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: ListTile(
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
              leading: Container(
                width: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      _categoryList[index].imgUrl,
                      fit: BoxFit.cover,
                    )),
              ),
              title: Text(
                _categoryList[index].name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
//              subtitle: Text(
//                "${categoriesList[index].itemAvailble.toString()} books",
//                style: TextStyle(
//                    color: Colors.black,
//                    fontWeight: FontWeight.w500,
//                    fontSize: 14),
//              ),
            )),
      ),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState

    _isloading = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _categoryList = Provider.of<CategoryProvider>(context).categoriesList;
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: <Widget>[
            InkWell(
                onTap: () {
                  setState(() {
                    selectView = !selectView;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                      selectView
                          ? FontAwesomeIcons.thList
                          : FontAwesomeIcons.list,
                      color: Colors.black),
                ))
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: FutureBuilder(
          future: Provider.of<CategoryProvider>(context)
              .getCategoryList()
              .then((_) {
            setState(() {
              _isloading = false;
            });
          }),
          builder: (ctx, snapshot) => _isloading
              ? Center(
                  child: MyLoader(),
                )
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Categories", style: MyText.bigHeading),
                      ),
                      selectView
                          ? listCategories(context)
                          : gridCategories(context)
                    ],
                  ),
                ),
        ));
  }
}
