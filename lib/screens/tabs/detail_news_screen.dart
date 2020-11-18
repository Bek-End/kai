import 'package:flutter/material.dart';
import 'package:kai_mobile_app/model/news_model.dart';
import 'package:kai_mobile_app/repository/mobile_repository.dart';
import 'package:kai_mobile_app/style/theme.dart' as Style;
import 'dart:math' as math;

class DetailNewsScreen extends StatefulWidget {
  final NewsModel newsModel;

  DetailNewsScreen(this.newsModel);

  @override
  _DetailNewsScreenState createState() => _DetailNewsScreenState(newsModel);
}

class _DetailNewsScreenState extends State<DetailNewsScreen> {
  NewsModel newsModel;

  _DetailNewsScreenState(NewsModel newsModel) {
    this.newsModel = newsModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Style.Colors.titleColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            floating: false,
            pinned: true,
            toolbarHeight: 60,
            expandedHeight: 240.0,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: _SliverAppBar(newsModel: newsModel,),
          ),
          SliverList(
            delegate:
                // ignore: missing_return
                SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Card(
                    elevation: 2,
                    margin: EdgeInsets.all(16),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Text(newsModel.desc),
                    ));
              },
              childCount: 1
            ),
          )
        ]),
      ),
    );
  }
}

class _SliverAppBar extends StatelessWidget {
  final NewsModel newsModel;
  const _SliverAppBar({Key key, this.newsModel}) : super(key: key);
  
  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0) as double;
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
        print(c.biggest.height);
        return Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: opacity,
                child: Hero(
                transitionOnUserGestures: true,
                tag: newsModel,
                child: Transform.scale(
                  scale: 1.0,
                  child: newsModel.image != null
                      ? Image.network(
                          MobileRepository.mainUrl + newsModel.image,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        )
                      : Container(color: Colors.red),
                ),
              ),
            ),
            
            Opacity(
              opacity: Interval(fadeStart, fadeEnd).transform(t),
                child: Center(
                child: Container(
                width: MediaQuery.of(context).size.width - 84,
                child: Text(
                newsModel.title,
                maxLines: (4-240~/c.biggest.height)>0?(4-240~/c.biggest.height):1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Style.Colors.titleColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  fontFamily: 'OpenSans',
                ),
                  ),
                  ),
              ),
            ),
            Opacity(
              opacity: opacity,
                child: Center(
                child: Container(
                width: MediaQuery.of(context).size.width - 84,
                child: Hero(
                  flightShuttleBuilder: _flightShuttleBuilder,
                  tag: newsModel.date,
                  child: Text(
                    newsModel.title,
                    maxLines: (4-240~/c.biggest.height)>0?(4-240~/c.biggest.height):1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        shadows: [
            Shadow(
                blurRadius: 5.0,
                color: Style.Colors.standardTextColor,
                offset: Offset(1, 1.0),
                ),
            ],
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
                  ),
              ),
            ),

          ],
        );
      },
    );
    
  }
   

}
