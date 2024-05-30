import 'package:flutter/material.dart';

main(){
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  

  @override
  Widget build(BuildContext context) {
    List<MyItem> movies=[];
    return  MaterialApp(
      home: Scaffold(
        body: VerticalListView( 
          itemCount: movies.length + 1,
          itemBuilder: (context, index) {
            if (index < movies.length) {
              return Container();
            } else {
              return  const LoadingIndicator();
            }
          },
        ),
      ),
    );
  }
}

class MyItem{
  late String title;

}


class VerticalListView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  

  const VerticalListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    
  });

  @override
  State<VerticalListView> createState() => _VerticalListViewState();
}

class _VerticalListViewState extends State<VerticalListView> {
  final _scrollController = ScrollController();





  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
    );
  }


}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xffef233c),
      ),
    );
  }
}

