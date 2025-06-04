import 'package:flutter/material.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({Key? key}) : super(key: key);

  @override
  _AnimationScreenState createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with SingleTickerProviderStateMixin {
  @override
  bool _toggled = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Size> _sizeAnimation;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<int> _items = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.2).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller);
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14,
    ).animate(_controller);
    _sizeAnimation = Tween<Size>(
      begin: Size(100, 100),
      end: Size(150, 150),
    ).animate(_controller);
  }

  void _toggleAnimations() {
    setState(() => _toggled = !_toggled);
    _toggled ? _controller.forward() : _controller.reverse();
  }

  void _addItem() {
    _items.insert(0, _items.length);
    _listKey.currentState?.insertItem(0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Transition Widgets")),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleAnimations,
        child: Icon(Icons.play_arrow),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              AnimatedAlign(
                duration: Duration(milliseconds: 500),
                alignment:
                    _toggled ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(width: 50, height: 50, color: Colors.blue),
              ),
              SizedBox(height: 16),
              AlignTransition(
                alignment: Tween<AlignmentGeometry>(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).animate(_controller),
                child: Container(width: 40, height: 40, color: Colors.green),
              ),
              SizedBox(height: 16),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: _toggled ? 200 : 100,
                height: _toggled ? 100 : 200,
                color: _toggled ? Colors.orange : Colors.purple,
              ),
              SizedBox(height: 16),
              AnimatedCrossFade(
                duration: Duration(milliseconds: 500),
                firstChild: FlutterLogo(size: 60),
                secondChild: Icon(Icons.flutter_dash, size: 60),
                crossFadeState:
                    _toggled
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
              ),
              SizedBox(height: 16),
              AnimatedList(
                key: _listKey,
                shrinkWrap: true,
                initialItemCount: _items.length,
                itemBuilder: (context, index, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: ListTile(title: Text("Item ${_items[index]}")),
                  );
                },
              ),
              ElevatedButton(onPressed: _addItem, child: Text("Add Item")),
              SizedBox(height: 16),
              AnimatedOpacity(
                opacity: _toggled ? 0.2 : 1.0,
                duration: Duration(milliseconds: 500),
                child: Container(height: 50, width: 100, color: Colors.teal),
              ),
              SizedBox(height: 16),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(height: 50, width: 100, color: Colors.red),
              ),
              SizedBox(height: 16),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(height: 50, width: 100, color: Colors.brown),
              ),
              SizedBox(height: 16),
              SizeTransition(
                sizeFactor: _scaleAnimation,
                axis: Axis.vertical,
                child: Container(height: 50, width: 100, color: Colors.grey),
              ),
              SizedBox(height: 16),
              RotationTransition(
                turns: _rotationAnimation,
                child: Icon(Icons.refresh, size: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
