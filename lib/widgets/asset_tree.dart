import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/asset_tree_provider.dart';
import 'asset_tree_node.dart';
import 'location_tree_node.dart';

/// Widget que exibe a árvore de ativos.
///
/// Este widget implementa a visualização da árvore de ativos, com as seguintes características:
///
/// 1. Integração com o AssetTreeProvider
/// 2. Suporte a expansão/colapso de nós
/// 3. Indentação visual da hierarquia
/// 4. Linhas de conexão entre nós
///
/// A estrutura é otimizada para:
/// - Renderização eficiente de grandes árvores
/// - Manutenção do estado de expansão
/// - Navegação intuitiva
/// - Feedback visual claro
class AssetTree extends StatelessWidget {
  final String? locationId;

  const AssetTree({
    super.key,
    this.locationId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AssetTreeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${provider.error}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (locationId != null) {
          final location = provider.getLocation(locationId!);
          if (location == null) {
            return const Center(child: Text('Location not found'));
          }
          return SingleChildScrollView(
            child: LocationTreeNode(
              location: location,
              level: 0,
              provider: provider,
            ),
          );
        }

        // Virtualized list for root locations and unlinked assets
        return CustomScrollView(
          slivers: [
            // Root locations
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final locations = provider.getRootLocations();
                  if (index >= locations.length) return null;
                  return LocationTreeNode(
                    location: locations[index],
                    level: 0,
                    provider: provider,
                  );
                },
                childCount: provider.getRootLocations().length,
              ),
            ),
            // Unlinked assets
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final assets = provider.getUnlinkedAssets();
                  if (index >= assets.length) return null;
                  return AssetTreeNode(
                    asset: assets[index],
                    level: 0,
                    provider: provider,
                  );
                },
                childCount: provider.getUnlinkedAssets().length,
              ),
            ),
          ],
        );
      },
    );
  }
}
