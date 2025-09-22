class ColisType{
  String name;
  String baseRate;
  ColisType({required this.name,required this.baseRate});


  factory ColisType.fromJson(Map<String, dynamic> json){
    return ColisType(name: json['name'] ?? '', baseRate: json['base_rate'] ?? '');
  }
}