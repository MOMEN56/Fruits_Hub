import 'package:equatable/equatable.dart';
import 'package:fruit_hub/generated/l10n.dart';

class ShippingAddressEntity extends Equatable {
  const ShippingAddressEntity({
    this.name,
    this.phone,
    this.address,
    this.city,
    this.email,
    this.floor,
  });

  final String? name;
  final String? phone;
  final String? address;
  final String? city;
  final String? email;
  final String? floor;

  ShippingAddressEntity copyWith({
    String? name,
    String? phone,
    String? address,
    String? city,
    String? email,
    String? floor,
  }) {
    return ShippingAddressEntity(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      email: email ?? this.email,
      floor: floor ?? this.floor,
    );
  }

  String get displayAddress {
    final parts =
        [address, city, floor]
            .where((part) => part != null && part.trim().isNotEmpty)
            .map((part) => part!.trim())
            .toList();

    if (parts.isEmpty) {
      return S.current.addressUnavailable;
    }

    return parts.join(' - ');
  }

  @override
  String toString() => displayAddress;

  @override
  List<Object?> get props => [name, phone, address, city, email, floor];
}
