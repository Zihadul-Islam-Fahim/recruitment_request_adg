class Urls{
 // static const String _bseUrl = "http://onewk.site";
  static const String _bseUrl = "http://dg-recruiter.appsowk.org";
  static String login = "$_bseUrl/api/auth/company/login";
  static String register = "$_bseUrl/api/auth/company/register";



  static String user = "$_bseUrl/user";


  static String jobPost = "$_bseUrl/api/company/jobs";
  static String jobGet = "$_bseUrl/api/company/jobs";
  static String jobDetails(String jobId) => "$_bseUrl/api/company/jobs/$jobId";

}