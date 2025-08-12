import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingIndicator({required this.isLoading, required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return child;
  }
}
