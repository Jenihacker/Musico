import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlaylistShimmer extends StatelessWidget {
  const PlaylistShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: const Color.fromARGB(255, 152, 81, 223),
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: const BoxDecoration(color: Colors.grey),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 20,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: Container(
              height: 30,
              width: 350,
              decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(color: Colors.grey),
                    ),
                    title: Container(
                      height: 14,
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                    ),
                    subtitle: Container(
                      height: 14,
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
