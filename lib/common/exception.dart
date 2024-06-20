class AppException{
  final String message;
  final int responseStatusCode;

  AppException( {this.message="خطای نا مشخص",this.responseStatusCode=0});

}