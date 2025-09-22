class ApiResult{
  String message;
  int code;
  bool success;
  dynamic data;
  ApiResult({required this.code,required this.message,required this.success, this.data});
}