class User {
    final String username;
    final String user;

    User({
        required this.username,
        required this.user,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        user: json["user"],
    );

    // Map<String, dynamic> toJson() => {
    //     "username": username,
    //     "user": user,
    // };
}