class Recipient {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String cpf;
  final String cep;
  final String street;
  final String number;
  final String? complement;
  final String district;
  final String city;
  final String state;
  final double latitude;
  final double longitude;

  Recipient({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.cpf,
    required this.cep,
    required this.street,
    required this.number,
    this.complement,
    required this.district,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  String get formattedCep {
    return '${cep.substring(0, 5)}-${cep.substring(5, 8)}';
  }

  String get formattedAddress {
    return '$street, $number - $district, $city - $state';
  }

  set name(String name) {
    this.name = name;
  }

  set email(String email) {
    this.email = email;
  }

  set phone(String phone) {
    this.phone = phone;
  }

  set cpf(String cpf) {
    this.cpf = cpf;
  }

  set cep(String cep) {
    this.cep = cep;
  }

  set street(String street) {
    this.street = street;
  }

  set number(String number) {
    this.number = number;
  }

  set complement(String? complement) {
    this.complement = complement;
  }

  set district(String district) {
    this.district = district;
  }

  set city(String city) {
    this.city = city;
  }

  set state(String state) {
    this.state = state;
  }

  set latitude(double latitude) {
    this.latitude = latitude;
  }

  set longitude(double longitude) {
    this.longitude = longitude;
  }
}
