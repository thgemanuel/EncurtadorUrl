class Usuario {
  String? _userid;
  String? _name;
  String? _profilePicture;
  String? _token;

  Usuario();

  String? _getUserID() {
    return this._userid;
  }

  String? _getName() {
    return this._name;
  }

  String? _getProfilePicture() {
    return this._profilePicture;
  }

  String? _getToken() {
    return this._token;
  }

  void _setUserID(userid) {
    this._userid = userid;
  }

  void _setName(name) {
    this._name = name;
  }

  void _setProfilePicture(_profilePicture) {
    this._profilePicture = _profilePicture;
  }

  void _setToken(token) {
    this._token = token;
  }

  Usuario.fromJson(Map<String, dynamic> json) {
    _setUserID(json['username']);
    _setName(json['name']);
    _setProfilePicture(json['profile_picture']);
    _setToken(json['token']);
  }

  Map<String, dynamic> toJson() => {
        'user_id': _getUserID(),
        'name': _getName(),
        'profile_picture': _getProfilePicture(),
        'token': _getToken(),
      };
}
