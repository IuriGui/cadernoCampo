import 'package:flutter/material.dart';
import '../../data/dao/area_cultivo_dao.dart';
import '../../data/dao/local_dao.dart';
import '../../data/models/area_cultivo.dart';

class LocalProvider extends ChangeNotifier{
  final AreaCultivoDAO _areaDAO = AreaCultivoDAO();
  final LocalDAO _localDAO = LocalDAO();

  List<AreaCultivo> _areas = [];
  bool _isLoading = false;

  List<AreaCultivo> get areas => _areas;
  bool get isLoading => _isLoading;

  Future<void> loadAreas(int localId) async {
    _isLoading = true;
    notifyListeners();

    _areas = await _areaDAO.getAreasByLocal(localId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addArea(AreaCultivo area, int localId) async {
    await _areaDAO.insertAreaCultivo(area);
    await loadAreas(localId);
  }

  Future<void> deleteLocal(int localId) async {
    await _localDAO.softDeleteLocal(localId);
    notifyListeners();

  }







}
