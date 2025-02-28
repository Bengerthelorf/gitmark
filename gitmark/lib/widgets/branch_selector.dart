import 'package:flutter/material.dart';

class BranchSelector extends StatelessWidget {
  final List<String> branches;
  final String currentBranch;
  final Function(String) onBranchSelected;

  const BranchSelector({
    super.key,
    required this.branches,
    required this.currentBranch,
    required this.onBranchSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: '切换分支',
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.alt_route),
          const SizedBox(width: 4),
          Text(
            currentBranch,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
      itemBuilder: (context) {
        return branches.map((branch) {
          return PopupMenuItem<String>(
            value: branch,
            child: Row(
              children: [
                if (branch == currentBranch)
                  const Icon(Icons.check, size: 16, color: Colors.green)
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 8),
                Text(branch),
              ],
            ),
          );
        }).toList();
      },
      onSelected: onBranchSelected,
    );
  }
}