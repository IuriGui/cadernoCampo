import 'package:geolocator/geolocator.dart';

class LocalizacaoService {
  static Future<Position> determinarPosicao() async {
    bool servicoAtivado;
    LocationPermission permissao;

    servicoAtivado = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivado) {
      return Future.error('O serviço de localização está desativado no dispositivo.');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.deniedForever) {
      return Future.error('As permissões de localização foram negadas permanentemente. Altere nas configurações.');
    }
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return Future.error('A permissão de localização foi negada pelo usuário.');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}