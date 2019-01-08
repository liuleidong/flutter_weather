import 'package:flutter_weather/commom_import.dart';

class PhotoWatchPage extends StatefulWidget {
  final int index;
  final int length;
  final List<MziData> photos;
  final Stream<List<MziData>> photoStream;

  PhotoWatchPage(
      {@required this.index,
      @required this.length,
      @required this.photos,
      @required this.photoStream}) {
    debugPrint("photos====>${photos.length}");
  }

  @override
  State createState() => PhotoWatchState(
      index: index, length: length, photos: photos, photoStream: photoStream);
}

class PhotoWatchState extends PageState<PhotoWatchPage> {
  final Stream<List<MziData>> photoStream;
  final List<MziData> photos;
  final int length;
  final PageController _pageController;
  final _viewModel = PhotoWatchViewModel();

  bool canScroll = true;

  PhotoWatchState(
      {@required int index,
      @required this.length,
      @required this.photos,
      @required this.photoStream})
      : _pageController = PageController(initialPage: index);

  @override
  void initState() {
    super.initState();

    _viewModel.init(photoStream);
  }

  @override
  void dispose() {
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: _viewModel.data.stream,
        builder: (context, snapshot) {
          final List<MziData> list = snapshot.data ?? photos;

          if (list.length < length) {
            list.addAll(List.generate(length - list.length, (_) => null));
          }

          return PhotoViewGallery(
            pageController: _pageController,
            loadingChild: Center(
              child: Image.asset("images/loading.gif"),
            ),
            pageOptions: list.map(
              (data) {
                return PhotoViewGalleryPageOptions(
                  heroTag: data?.url,
                  imageProvider: data != null
                      ? CachedNetworkImageProvider(
//                          data.url,
                          "http://pic.sc.chinaz.com/files/pic/pic9/201610/apic23847.jpg",
                          headers: Map<String, String>()
                            ..["Referer"] = data.refer,
                        )
                      : AssetImage("images/loading.gif"),
                  minScale: data != null ? 0.5 : 1.0,
                  maxScale: data != null ? 5.0 : 1.0,
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}