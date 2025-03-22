import 'package:flutter/material.dart';

import '../models/asset.dart';
import '../models/location.dart';
import '../services/api_service.dart';

/// Provider responsável por gerenciar a árvore de ativos.
///
/// Este provider implementa a lógica de construção e filtragem da árvore de ativos,
/// com as seguintes características:
///
/// 1. Construção da árvore hierárquica
/// 2. Filtros de busca e status
/// 3. Gerenciamento de estado de expansão
/// 4. Otimização de performance
///
/// A estrutura é otimizada para:
/// - Construção eficiente da árvore
/// - Filtragem sem perda de contexto
/// - Atualização seletiva de nós
/// - Experiência de usuário fluida
class AssetTreeProvider extends ChangeNotifier {
  final String companyId;
  List<Location> _locations = [];
  List<Asset> _assets = [];
  bool _isLoading = false;
  String? _error;

  // Filtros
  String _searchQuery = '';
  bool _showEnergySensors = false;
  bool _showCriticalStatus = false;

  // Estado de expansão dos nós
  final Map<String, ValueNotifier<bool>> _expansionNotifiers = {};

  AssetTreeProvider({required this.companyId}) {
    loadData();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get energyFilter => _showEnergySensors;
  bool get criticalFilter => _showCriticalStatus;

  /// Carrega os dados de localizações e ativos da API.
  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final locationsJson = await ApiService.fetchLocations(companyId);
      final assetsJson = await ApiService.fetchAssets(companyId);
      _locations =
          locationsJson.map((json) => Location.fromJson(json)).toList();
      _assets = assetsJson.map((json) => Asset.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar dados: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca os ativos da empresa.
  Future<List<Asset>> fetchAssets(String companyId) async {
    try {
      final assetsJson = await ApiService.fetchAssets(companyId);
      return assetsJson.map((json) => Asset.fromJson(json)).toList();
    } catch (e) {
      _error = 'Erro ao carregar ativos: $e';
      notifyListeners();
      return [];
    }
  }

  /// Define a query de busca.
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  /// Define o filtro de sensores de energia.
  void setEnergyFilter(bool value) {
    _showEnergySensors = value;
    notifyListeners();
  }

  /// Define o filtro de status crítico.
  void setCriticalFilter(bool value) {
    _showCriticalStatus = value;
    notifyListeners();
  }

  /// Alterna o estado de expansão de um nó.
  void toggleNodeExpansion(String nodeId) {
    final notifier = _expansionNotifiers[nodeId] ?? ValueNotifier<bool>(false);
    notifier.value = !notifier.value;
    _expansionNotifiers[nodeId] = notifier;
    notifyListeners();
  }

  /// Verifica se um nó está expandido.
  bool isNodeExpanded(String nodeId) {
    return _expansionNotifiers[nodeId]?.value ?? false;
  }

  /// Verifica se um ativo deve ser exibido com base nos filtros.
  bool _shouldShowAsset(Asset asset) {
    if (_searchQuery.isNotEmpty) {
      final name = asset.name.toLowerCase();
      if (!name.contains(_searchQuery)) {
        return false;
      }
    }

    if (_showEnergySensors && asset.sensorType != 'energy') {
      return false;
    }

    if (_showCriticalStatus && asset.status != 'alert') {
      return false;
    }

    return true;
  }

  /// Verifica se um ativo tem filhos que devem ser exibidos.
  bool _hasVisibleChildren(Asset asset) {
    return _assets.any(
      (child) =>
          child.parentId == asset.id && shouldShowAssetWithParents(child),
    );
  }

  /// Verifica se um ativo deve ser exibido (incluindo seus pais).
  bool shouldShowAssetWithParents(Asset asset) {
    if (_searchQuery.isEmpty && !_showEnergySensors && !_showCriticalStatus) {
      return true;
    }

    if (_shouldShowAsset(asset)) {
      return true;
    }

    if (_hasVisibleChildren(asset)) {
      return true;
    }

    return false;
  }

  /// Retorna a cor do status do ativo.
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'alert':
        return Colors.red;
      case 'operating':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Location? getLocation(String id) {
    try {
      return _locations.firstWhere((loc) => loc.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Location> getRootLocations() {
    return _locations.where((loc) => loc.parentId == null).toList();
  }

  List<Location> getSubLocations(String parentId) {
    return _locations.where((loc) => loc.parentId == parentId).toList();
  }

  List<Asset> getUnlinkedAssets() {
    return _assets
        .where((asset) => asset.locationId == null && asset.parentId == null)
        .toList();
  }

  List<Asset> getLocationAssets(String locationId) {
    return _assets.where((asset) => asset.locationId == locationId).toList();
  }

  List<Asset> getChildAssets(String parentId) {
    return _assets.where((asset) => asset.parentId == parentId).toList();
  }

  @override
  void dispose() {
    for (final notifier in _expansionNotifiers.values) {
      notifier.dispose();
    }
    super.dispose();
  }
}
