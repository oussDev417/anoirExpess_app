class Course{
  String departure;
  String destination;
  String description;
  String colisType;
  String engineType;
  int price;
  String? status;
  String? recipientPhone;
  String? authorId;
  String type;
  String? id;
  int? courseCode;
  int? passengersNumber;
  String? deliverId;
  String? startEstimation;
  String? createdAt;
  bool? isFragile;

  Course({required this.colisType, required this.type,
    this.status = 'WAITING',this.authorId, required this.description, required this.price,
    this.isFragile = false,
    required this.departure, required this.destination,required this.engineType, this.recipientPhone,
    this.id='',this.createdAt='',this.courseCode,this.deliverId,this.startEstimation,this.passengersNumber
  });

  Map<String,dynamic> toJson(){
    return {
    "departure" : departure,
    "destination" : destination,
    "description" : description,
    "colisType" : colisType,
    "engineType" : engineType,
    "price" : price.toString(),
    if(recipientPhone != null)  "recipientPhone" : recipientPhone!.startsWith('+229') ? recipientPhone : "+229" + recipientPhone!,
    "authorId" : authorId ?? '',
    "type" : type ,
    "isFragile" : isFragile,
    if(passengersNumber  != null) "passengersNumber" : passengersNumber,
    // "courseCode" : courseCode ?? 0 ,
    };
  }

  factory Course.fromJson(Map<String,dynamic> json){
    return Course(
        colisType: json['colisType'] ?? '',
        authorId: json['userId'] ?? '',
        description: json['description'] ?? '',
        price: json['price'] ?? 0,
        departure: json['departure'] ?? '',
        destination: json['destination'] ?? '',
        passengersNumber: json['passengersNumber'] ?? 0,
        engineType: json['engineType'] ?? '',
        type: json['type'] ?? 'DELIVERY',
        status: json['status'] ?? 'WAITING',
        id: json['id'] ?? '',
        isFragile: json['isFragile'] ?? false,
        createdAt: json['createdAt'] ?? DateTime.now().toString(),
        courseCode: json['courseCode'] ,
        deliverId: json['deliverId'],
        startEstimation: json['startEstimation'] ?? null,
        recipientPhone: json['recipientPhone']);
  }
}