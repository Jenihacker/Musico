import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlaylistCatShimmer extends StatelessWidget {
  const PlaylistCatShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 98, 95, 100),
      highlightColor: const Color.fromARGB(255, 152, 81, 223),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            width: 150,
            child: Text(
              "",
              style: TextStyle(
                backgroundColor: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }
}
