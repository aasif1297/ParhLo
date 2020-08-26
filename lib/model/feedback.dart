class FeedBackModel {
  String imgAssetPath;
  String feedback;
  String education;
  String email;

  FeedBackModel({this.imgAssetPath, this.education, this.email, this.feedback});


  Map toMap(FeedBackModel feedBackModel) {
    var data = Map<String, dynamic>();
    data['feedback'] = feedBackModel.feedback;
    data['feedbackImage'] = feedBackModel.imgAssetPath;
    data['senderemail'] = feedBackModel.email;
    data['sendereducation'] = feedBackModel.education;


    return data;
  }
}
