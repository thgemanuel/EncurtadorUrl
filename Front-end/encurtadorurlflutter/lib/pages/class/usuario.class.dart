class Usuario {
  final String company_id;
  //final List<dynamic> favorite_list;
  final String first_name;
  final String last_name;
  final String message;
  final String permissions;
  final String profile_picture;
  final String token;
  final String username;

  const Usuario({
    required this.company_id,
    //required this.favorite_list,
    required this.first_name,
    required this.last_name,
    required this.message,
    required this.permissions,
    required this.profile_picture,
    required this.token,
    required this.username,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      company_id: json['company_id'].toString(),
      //favorite_list: json['favorite_list'] as List<dynamic>,
      first_name: json['first_name'].toString(),
      last_name: json['last_name'].toString(),
      message: json['message'].toString(),
      permissions: json['permissions'].toString(),
      profile_picture: json['profile_picture'].toString(),
      token: json['token'].toString(),
      username: json['username'].toString(),
    );
  }
}
