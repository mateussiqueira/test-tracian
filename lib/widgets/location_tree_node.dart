import 'package:flutter/material.dart';

import '../models/location.dart';
import '../providers/asset_tree_provider.dart';
import 'asset_tree_node.dart';

class LocationTreeNode extends StatelessWidget {
  final Location location;
  final int level;
  final AssetTreeProvider provider;

  const LocationTreeNode({
    super.key,
    required this.location,
    required this.level,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = provider.isNodeExpanded(location.id);
    final subLocations = provider.getSubLocations(location.id);
    final locationAssets = provider.getLocationAssets(location.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location header
        InkWell(
          onTap: () => provider.toggleNode(location.id),
          child: Padding(
            padding: EdgeInsets.only(
              left: level * 16.0,
              right: 16.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                ),
                const SizedBox(width: 4),
                const Icon(Icons.folder, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    location.name,
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
        // Sub-locations and assets
        if (isExpanded &&
            (subLocations.isNotEmpty || locationAssets.isNotEmpty))
          Padding(
            padding: EdgeInsets.only(left: (level + 1) * 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sub-locations
                ...subLocations.map(
                  (subLocation) => LocationTreeNode(
                    key: ValueKey('sub_location_${subLocation.id}'),
                    location: subLocation,
                    level: level + 1,
                    provider: provider,
                  ),
                ),
                // Location assets
                ...locationAssets.map(
                  (asset) => AssetTreeNode(
                    key: ValueKey('location_asset_${asset.id}'),
                    asset: asset,
                    level: level + 1,
                    provider: provider,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
