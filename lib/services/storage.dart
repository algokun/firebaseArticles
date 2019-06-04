import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart' as random;

class StorageToolKit {
  
  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  Future uploadTask(imageFile, bool userImage) async {
    StorageUploadTask uploadUserImage;
    StorageUploadTask uploadPostImage;

    String uid = await getUserId();

    StorageReference userStorageRef = FirebaseStorage.instance
        .ref()
        .child("profileImages")
        .child(uid + '.png');

    StorageReference postImagesRef =
        FirebaseStorage.instance.ref().child("articleImages").child(_randomString(10)+ '.png');

    if(userImage){
      uploadUserImage = userStorageRef.putFile(imageFile);
    }
    else{
      uploadPostImage = postImagesRef.putFile(imageFile);
    }
    
    var downloadUrl = userImage ? 
    await (await uploadUserImage.onComplete).ref.getDownloadURL() :
    await (await uploadPostImage.onComplete).ref.getDownloadURL() ;
    String url = downloadUrl.toString();

    return url;
  }

  String _randomString(int length) {
    return random.randomNumeric(length);
  }
}
