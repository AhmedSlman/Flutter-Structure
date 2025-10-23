import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';

class TrendingLoadingItem extends StatelessWidget {
  const TrendingLoadingItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 350,
        autoPlay: true,
        viewportFraction: 0.7,
        aspectRatio: 16 / 9,
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
      ),
      items: List.generate(
          5,
          (index) => Card(
                  child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
                enabled: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 250.0,
                      height: 200.0,
                      color: Colors.green,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 2.0),
                    // ),
                    Container(
                      width: 240,
                      height: 20,
                      color: Colors.green,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                    ),
                    Container(
                      width: 70.0,
                      height: 20,
                      color: Colors.green,
                    )
                  ],
                ),
              ))),
    );
  }
}

class ProductsLoadnigItem extends StatelessWidget {
  const ProductsLoadnigItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
      enabled: true,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: 4,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 140.0,
                height: 130.0,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                width: 120,
                height: 8.0,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                width: 25.0,
                height: 8.0,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImagesLoadnigItem extends StatelessWidget {
  const ImagesLoadnigItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
      enabled: true,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            mainAxisExtent: 100),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          width: 70.0,
          height: 100.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class VerticalProductLoadingItem extends StatelessWidget {
  const VerticalProductLoadingItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 205,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) => SizedBox(
                  height: 155,
                  width: 200,
                  //  width: 150,
                  //     height: 180,
                  child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
                    enabled: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 180,
                          height: 150,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: 150,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: 25.0,
                          height: 8.0,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ))),
              itemCount: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingImage extends StatelessWidget {
  LoadingImage({super.key, this.h, this.w});
  double? h, w;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
      enabled: true,
      child: Container(
        width: w ?? double.infinity,
        // height: h ?? double.infinity,
        color: Colors.white,
      ),
    );
  }
}
