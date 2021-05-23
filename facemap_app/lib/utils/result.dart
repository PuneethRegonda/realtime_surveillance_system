class Result {
  String message;
  var data;
  bool isSuccess;

  Result() {
    this.message = "";
    this.isSuccess = false;
    // this.data = null;
  }

  @override
  String toString() {
    return "Result { message: $message,data: $data, isSuccess: $isSuccess}";
  }
}
