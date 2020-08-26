import 'package:bookapp/theme/mytext.dart';
import 'package:flutter/material.dart';

class BirthdayWidget extends StatefulWidget {
  var userProfile;
  var selectedDate;
  Function _submitPresentDate;

  BirthdayWidget(this.userProfile, this.selectedDate, this._submitPresentDate);

  @override
  _BirthdayWidgetState createState() => _BirthdayWidgetState();
}

class _BirthdayWidgetState extends State<BirthdayWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        widget._submitPresentDate();
      },
      child: Container(
        margin: EdgeInsets.all(8),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.userProfile.myProfile.birthday == null
                    ? Text(
                        (widget.selectedDate == null)
                            ? 'Select you birth date'
                            : "${widget.selectedDate.toLocal()}".split(' ')[0],
                        style: MyText.text,
                      )
                    : Text(
                        "${widget.userProfile.myProfile.birthday}"
                            .split(' ')[0],
                        style: MyText.text,
                      ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
            ),

            //My custom button
          ],
        ),
      ),
    );
  }
}
