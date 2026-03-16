class UserEntity {
  final String name;
  final String email;
  final String uId;
  final String photoUrl;

  UserEntity({
    required this.name,
    required this.email,
    required this.uId,
    this.photoUrl = '',
  });
}
