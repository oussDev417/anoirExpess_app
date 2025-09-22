
import 'user.dart';

class Note{
  String note;
  User user;
  String createdAt;
  
  Note({required this.note,required this.user,required this.createdAt});
  
  factory Note.fromMap(Map<String,dynamic> json){
    return Note(note: json['note'], user: User.fromMap(json['user']),createdAt: json['createdAt']);
  }
}