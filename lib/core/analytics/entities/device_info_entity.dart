import 'package:equatable/equatable.dart';

class DeviceInfoEntity extends Equatable {
  const DeviceInfoEntity({
    this.os = '',
    this.osVersion = '',
    this.model = '',
  });

  final String os;
  final String osVersion;
  final String model;

  @override
  List<Object?> get props => <String>[os, osVersion, model];
}
