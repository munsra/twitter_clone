class AppwriteConstants {
  /* Cloud Database  
  static const String DATABASE_ID = "646c72cee0a926b9dc56";
  static const String PROJECT_ID = "646c6fe19f5933472238";
  // Endpoint
  static const String APPWRITE_URL = "https://cloud.appwrite.io/v1";
  static const String usersCollection = "64837f2c09dbf4026032";
  static const String tweetsCollection = "64cfb7e1dfb7b719e459";
  // Storage
  static const String imagesBucket = "64d63ae4182738a4e478";
  static String imageUrl(String imageId) =>
      '$APPWRITE_URL/storage/buckets/$imagesBucket/files/$imageId/view?project=$PROJECT_ID&mode=admin';
 */
  /* Localhost   */
  static const String DATABASE_ID = "64cfb54e338cb1c7c906";
  static const String PROJECT_ID = "64cfb1f670d6b45a490b";
  // Endpoint
  static const String APPWRITE_URL = "http://192.168.1.227:80/v1";
  static const String usersCollection = "64cfb64f795e17e296cc";
  static const String tweetsCollection = "64cfb76161299ee5048a";
  // Storage
  static const String imagesBucket = "64d63aa6e0fc22c6d0c5";
  static String imageUrl(String imageId) =>
      '$APPWRITE_URL/storage/buckets/$imagesBucket/files/$imageId/view?project=$PROJECT_ID&mode=admin';
}
