/// Serviço responsável pela comunicação com a API.
///
/// Este serviço implementa as chamadas à API para buscar dados de ativos,
/// com as seguintes características:
///
/// 1. Estrutura de dados consistente com a API real
/// 2. Tratamento de erros
/// 3. Tipagem forte dos dados
///
/// A estrutura é otimizada para:
/// - Desenvolvimento rápido sem dependência da API real
/// - Fácil migração para a API real
/// - Manutenção da consistência dos dados
class ApiService {
  /// Busca as empresas disponíveis.
  static Future<List<Map<String, dynamic>>> fetchCompanies() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      {
        "id": "company1",
        "name": "Tractian Demo",
        "description": "Empresa demonstração"
      },
      {
        "id": "company2",
        "name": "Industria ABC",
        "description": "Indústria de manufatura"
      },
      {
        "id": "company3",
        "name": "Fábrica XYZ",
        "description": "Fábrica de componentes"
      }
    ];
  }

  /// Busca as localizações de uma empresa.
  static Future<List<Map<String, dynamic>>> fetchLocations(
    String companyId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    switch (companyId) {
      case 'company1':
        return [
          {"id": "loc1", "name": "Unidade São Paulo", "parentId": null},
          {"id": "loc2", "name": "Galpão Principal", "parentId": "loc1"},
          {"id": "loc3", "name": "Área de Produção", "parentId": "loc2"},
          {"id": "loc4", "name": "Manutenção", "parentId": "loc2"},
          {"id": "loc5", "name": "Unidade Rio", "parentId": null},
          {"id": "loc6", "name": "Almoxarifado", "parentId": "loc5"}
        ];
      case 'company2':
        return [
          {"id": "loc7", "name": "Fábrica 1", "parentId": null},
          {"id": "loc8", "name": "Linha de Montagem", "parentId": "loc7"},
          {"id": "loc9", "name": "Controle de Qualidade", "parentId": "loc7"},
          {"id": "loc10", "name": "Fábrica 2", "parentId": null},
          {"id": "loc11", "name": "Expedição", "parentId": "loc10"}
        ];
      default:
        return [
          {"id": "loc12", "name": "Unidade Principal", "parentId": null},
          {"id": "loc13", "name": "Produção", "parentId": "loc12"},
          {"id": "loc14", "name": "Estoque", "parentId": "loc12"}
        ];
    }
  }

  /// Busca os ativos de uma empresa.
  static Future<List<Map<String, dynamic>>> fetchAssets(
    String companyId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    switch (companyId) {
      case 'company1':
        return [
          {
            "id": "asset1",
            "name": "Motor Principal",
            "parentId": null,
            "locationId": "loc3",
            "sensorType": "energy",
            "status": "operating"
          },
          {
            "id": "asset2",
            "name": "Bomba Hidráulica",
            "parentId": "asset1",
            "locationId": "loc3",
            "sensorType": "vibration",
            "status": "alert"
          },
          {
            "id": "asset3",
            "name": "Compressor",
            "parentId": null,
            "locationId": "loc4",
            "sensorType": "energy",
            "status": "operating"
          },
          {
            "id": "asset4",
            "name": "Esteira",
            "parentId": null,
            "locationId": "loc3",
            "sensorType": "vibration",
            "status": "operating"
          }
        ];
      case 'company2':
        return [
          {
            "id": "asset5",
            "name": "Robô Soldador",
            "parentId": null,
            "locationId": "loc8",
            "sensorType": "energy",
            "status": "operating"
          },
          {
            "id": "asset6",
            "name": "Braço Robótico",
            "parentId": "asset5",
            "locationId": "loc8",
            "sensorType": "vibration",
            "status": "alert"
          },
          {
            "id": "asset7",
            "name": "Scanner QR",
            "parentId": null,
            "locationId": "loc9",
            "sensorType": null,
            "status": "operating"
          }
        ];
      default:
        return [
          {
            "id": "asset8",
            "name": "Máquina CNC",
            "parentId": null,
            "locationId": "loc13",
            "sensorType": "energy",
            "status": "operating"
          },
          {
            "id": "asset9",
            "name": "Empilhadeira",
            "parentId": null,
            "locationId": "loc14",
            "sensorType": null,
            "status": "alert"
          }
        ];
    }
  }
}
