import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SearchResultShimmer extends StatelessWidget {
  const SearchResultShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white70,
      highlightColor: Colors.white,
      child: ListTile(
        leading: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.black38,
          ),
        ),
        title: Container(
          height: 14,
          decoration: const BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
        ),
        subtitle: Container(
          height: 14,
          decoration: const BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
        ),
      ),
    );
  }
}
