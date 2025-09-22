class User{
  String username;
  String email;
  String firstname;
  String lastname;
  String phone;
  String? password;
  String? id;
  String? role;

  User({
    required this.email,
    this.role,
    this.id = '', this.password, required this.phone, required this.lastname, required this.firstname, required this.username,
 });

  factory User.fromMap(Map<String,dynamic> json){
    return User(
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        lastname: json['lastname'] ?? '',
        firstname: json['firstname'] ?? '',
        username: json['username'] ?? '',
        id: json['id'] ?? '',
        role: json['role'] ?? '');
  }

  toJson(){
    return {
      "email" : email,
      "username" : username,
      "phone" : phone,
      "firstname" : firstname,
      "lastname" : lastname,
      "password" : password ?? ''
    };
  }


}