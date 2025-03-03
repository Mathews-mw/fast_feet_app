import 'package:fast_feet_app/models/user_coordinates.dart';
import 'package:geolocator/geolocator.dart';

class CoordinatesService {
  Future<UserCoordinates> getCurrentPosition() async {
    try {
      Position position = await _currentPosition();

      return UserCoordinates(
        lat: position.latitude,
        long: position.longitude,
        error: '',
      );
    } catch (e) {
      print('Location error: $e');
      return UserCoordinates(
        lat: 0.0,
        long: 0.0,
        error: e.toString(),
      );
    }
  }

  Future<Position> _currentPosition() async {
    LocationPermission permission;

    bool isActive = await Geolocator.isLocationServiceEnabled();

    if (!isActive) {
      return Future.error(
          'Geolocalização desativada. Por favor, habilite a localização do seu dispositivo para que a aplicação funcione corretamente.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Você precisa autorizar o acesso à localização. Acesse as configurações do seu dispositivo para da o devido acesso de localização para o app.');
    }

    return Geolocator.getCurrentPosition();
  }
}
