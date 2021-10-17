import 'package:equatable/equatable.dart';

class AppUserEntity extends Equatable {
  const AppUserEntity({
    required this.displayName,
    required this.email,
    required this.emailVerified,
    required this.success,
  });

  final String displayName;
  final String email;
  final bool emailVerified;
  final bool success;

  @override
  List<Object> get props => <Object>[
    displayName,
    email,
    emailVerified,
    success,
  ];
}
