import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlaylistCatShimmer extends StatelessWidget {
  const PlaylistCatShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white70,
      highlightColor: Colors.white,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                color: Colors.black38,
              ),
            ),
          ),
          const SizedBox(
            width: 150,
            child: Text(
              "",
              style: TextStyle(
                backgroundColor: Colors.black38,
              ),
            ),
          )
        ],
      ),
    );
  }
}
