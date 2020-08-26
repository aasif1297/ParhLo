import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserImageWidget extends StatefulWidget{
  var size;
  var _uploadedFileURL;

  Function chooseFile;

  UserImageWidget(this.size,this._uploadedFileURL,this.chooseFile);

  @override
  _UserImageWidgetState createState() => _UserImageWidgetState();
}

class _UserImageWidgetState extends State<UserImageWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.all(10),
        height: 140,
        child: Stack(
          children: <Widget>[
//              _image != null
//                  ? ClipRRect(
//                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
//                      child: Image.file(
//                        _image,
//                        width: 121.0,
//                        height: 121.0,
//                        fit: BoxFit.cover,
//                      ),
//                    )
//                  :
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xff330033)),
                  ),
                  width: 121.0,
                  height: 121.0,
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
                    width: 121.0,
                    height: 121.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                imageUrl: widget._uploadedFileURL.toString(),
                width: 121.0,
                height: 121.0,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: widget.size.height * 0.11,
              left: widget.size.width * 0.20,
              child: InkWell(
                onTap: widget.chooseFile,
                child: CircleAvatar(
                  backgroundColor: Colors.brown,
                  child: Icon(FontAwesomeIcons.camera),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}