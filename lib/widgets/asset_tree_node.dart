import 'package:flutter/material.dart';

import '../models/asset.dart';
import '../providers/asset_tree_provider.dart';

class AssetTreeNode extends StatelessWidget {
  final Asset asset;
  final int level;
  final AssetTreeProvider provider;

  const AssetTreeNode({
    super.key,
    required this.asset,
    required this.level,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    if (!provider.shouldShowAssetWithParents(asset)) {
      return const SizedBox.shrink();
    }

    final childAssets = provider.getChildAssets(asset.id);
    final hasChildren = childAssets.isNotEmpty;
    final isExpanded = provider.isNodeExpanded(asset.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Asset header
        InkWell(
          onTap: hasChildren ? () => provider.toggleNode(asset.id) : null,
          child: Padding(
            padding: EdgeInsets.only(
              left: level * 16.0,
              right: 16.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Row(
              children: [
                if (hasChildren)
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                  )
                else
                  const SizedBox(width: 20),
                const SizedBox(width: 4),
                Icon(
                  Icons.devices,
                  size: 20,
                  color: asset.statusColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    asset.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Child assets
        if (isExpanded && hasChildren)
          Padding(
            padding: EdgeInsets.only(left: (level + 1) * 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: childAssets
                  .map(
                    (childAsset) => AssetTreeNode(
                      key: ValueKey('child_asset_${childAsset.id}'),
                      asset: childAsset,
                      level: level + 1,
                      provider: provider,
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
