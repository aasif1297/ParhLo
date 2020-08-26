import 'package:bookapp/views/book/screen/book_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookTile extends StatelessWidget {
  final String title, categorie, imgAssetPath, author, url;

  BookTile(
      {this.title,
      this.categorie,
      this.imgAssetPath,
      this.author,
      @required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => BookDetailsScreen(
                  name: title,
                  url: url,
                )));
      },
      child: Container(
        width: 138,
        padding: EdgeInsets.only(left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff330033)),
                  ),
                  width: 110,
                  height: 160,
                  padding: EdgeInsets.all(70.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Material(
                  child: Image.asset(
                    'assets/images/img_not_available.jpeg',
                    width: 110,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                imageUrl: imgAssetPath,
                width: 110,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 5),
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 3),
              child: Text(
                "By : " + author,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GestureDectactor {}
