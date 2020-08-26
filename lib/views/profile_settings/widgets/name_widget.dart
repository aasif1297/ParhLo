import 'package:bookapp/theme/mytext.dart';
import 'package:flutter/material.dart';

class NameWidget extends StatefulWidget {
  String name;
  TextEditingController nameController;

  NameWidget(this.name, this.nameController);

  @override
  _NameWidgetState createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  bool nameVisi = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.name,
                    style: MyText.text,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      nameVisi = !nameVisi;
                    });
                  },
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: nameVisi,
          child: Container(
            margin: EdgeInsets.all(8),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300]),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextFormField(
                      controller: widget.nameController,
                      autofocus: true,
                      style: MyText.text,
                      decoration: InputDecoration(
                        hintStyle: MyText.text,
                        border: InputBorder.none,
                        hintText: widget.name,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                      // textInputAction: TextInputAction.next,  because when we use multiline input it will not make impact
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        nameVisi = !nameVisi;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
