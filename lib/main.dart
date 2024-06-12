import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

main(){
  runApp(const MyWidget());
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late Future<List<MyItem>> movies;
  late Future<List<MyItem>> filmes;

  @override
  initState(){
  filmes = loadData();
   super.initState();
  }

  Future<List<MyItem>> loadData()async{
    final String response= await rootBundle.loadString("lib/data.json");
    final List<dynamic> data = json.decode(response); 
    var myData =data.map((e) {
      print(e.toString());
      return MyItem.fromJson(e);} );
     
    return data.map((element) => MyItem.fromJson(element)).toList();
  }

  @override
  Widget build(BuildContext context) {
    
    return  MaterialApp(
      home: Scaffold(
        body: Center(
          child: Center(
        child:     FutureBuilder(
              future: filmes,
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const Center(child:CircularProgressIndicator());
                }else if(snapshot.hasError){
                  return Center(child: Text("Erro"),);
                }else{
                  var data = snapshot.data!;
                  return VerticalListView(
                    itemCount: data.length,
                    itemBuilder: (context,index){
                      return VerticalListViewCard(media: data[index]);
                    });
                }
              },
            
          )
          ),
        ),
      ),
    );
  }
}

class MyItem{
    String? posterPath;
  String? title;
  String? releaseDate;
  double? voteAverage;
  String? overview;
    MyItem(
    {
      this.posterPath,
      this.title,
      this.releaseDate,
      this.voteAverage,
      this.overview
    }
  );

    factory MyItem.fromJson(Map<String, dynamic> json) {
    return MyItem(
      title: json['title'],
      posterPath: json['poster_path'],
      releaseDate:getDate( json['release_date']),
      voteAverage:  json["vote_average"],
      overview: json["overview"]
    );
  }

}

String getDate(String? date) {
  if (date == null || date.isEmpty) {
    return '';
  }

  final vals = date.split('-');
  String year = vals[0];
  int monthNb = int.parse(vals[1]);
  String day = vals[2];

  String month = '';

  switch (monthNb) {
    case 1:
      month = 'Jan';
      break;
    case 2:
      month = 'Feb';
      break;
    case 3:
      month = 'Mar';
      break;
    case 4:
      month = 'Apr';
      break;
    case 5:
      month = 'May';
      break;
    case 6:
      month = 'Jun';
      break;
    case 7:
      month = 'Jul';
      break;
    case 8:
      month = 'Aug';
      break;
    case 9:
      month = 'Sep';
      break;
    case 10:
      month = 'Oct';
      break;
    case 11:
      month = 'Nov';
      break;
    case 12:
      month = 'Dec';
      break;
    default:
      break;
  }

  return '$month $day, $year';
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



class VerticalListViewCard extends StatelessWidget {
  const VerticalListViewCard({
    super.key,
    required this.media,
  });

  final MyItem media;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        
      },
      child: Container(
        height: 175,
        decoration: BoxDecoration(
          color: Color(0xff272b30),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageWithShimmer(
                  imageUrl: media.posterPath!,
                  width: 110,
                  height: double.infinity,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      media.title!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall,
                    ),
                  ),
                  Row(
                    children: [
                      if (media.releaseDate!.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Text(
                            media.releaseDate!.split(', ')[1],
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge,
                          ),
                        ),
                      ],
                      const Icon(
                        Icons.star_rate_rounded,
                        color: Color(0xffffbe21),
                        size: 18,
                      ),
                      Text(
                        media.voteAverage.toString(),
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Text(
                      media.overview!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class ImageWithShimmer extends StatelessWidget {
  const ImageWithShimmer({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  final String imageUrl;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    // return CachedNetworkImage(
    //   imageUrl: imageUrl,
    //   height: height,
    //   width: width,
    //   fit: BoxFit.cover,
    //   placeholder: (_, __) => Shimmer.fromColors(
    //     baseColor: Colors.grey[850]!,
    //     highlightColor: Colors.grey[800]!,
    //     child: Container(
    //       height: height,
    //       color: AppColors.secondaryText,
    //     ),
    //   ),
    //   errorWidget: (_, __, ___) => const Icon(
    //     Icons.error,
    //     color: AppColors.error,
    //   ),
    // );

     return  Image.asset(
        "assets/img/"+imageUrl, 
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
  }
}