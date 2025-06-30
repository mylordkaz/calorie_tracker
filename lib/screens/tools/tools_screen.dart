import 'package:flutter/material.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

	@override
	  Widget build(BuildContext context) {
	    return Scaffold(
				appBar: AppBar(title: Text('Tools')),
				body: Center(child: Text('BMI Calculator & Tools\nComing Soon!')),
			);
	  }
}
