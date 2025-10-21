import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';

enum MediaSource { asset, network, file, unsupported }

enum MediaType { image, svg, video, unsupported }

class DefaultImageWidget extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? radius;
  final bool? isCircle;

  const DefaultImageWidget(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.radius,
    this.isCircle,
  });

  bool get isNetwork => path.startsWith('http');
  bool get isAsset => path.startsWith('assets/');
  bool get isFile => !isNetwork && !isAsset;

  MediaSource get mediaSource => isAsset
      ? MediaSource.asset
      : isNetwork
          ? MediaSource.network
          : isFile
              ? MediaSource.file
              : MediaSource.unsupported;

  MediaType get mediaType {
    final ext = path.toLowerCase();
    if (ext.contains('.png') ||
        ext.contains('.jpg') ||
        ext.contains('.avif') ||
        ext.contains('.jpeg') ||
        ext.contains('.gif') ||
        ext.contains('.heic') ||
        ext.contains('.heif') ||
        ext.contains('.webp')) {
      return MediaType.image;
    } else if (ext.contains('.svg')) {
      return MediaType.svg;
    } else if (ext.contains('.mp4') || ext.contains('.mov')) {
      return MediaType.video;
    } else {
      if (isNetwork) {
        return MediaType.image; // Assume image for unknown network paths
      }
      return MediaType.unsupported;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    switch (mediaType) {
      case MediaType.image:
        child = _buildImage();
        break;
      case MediaType.svg:
        child = _buildSvg();
        break;
      case MediaType.video:
        child = _buildVideo(context);
        break;
      default:
        child = const Icon(Icons.broken_image, size: 48);
    }

    if (isCircle == true) {
      return CircleAvatar(
        // child: SizedBox(
        //   width: width,
        //   height: height,
        child: child,
        // ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );
  }

  Widget _buildImage() {
    switch (mediaSource) {
      case MediaSource.asset:
        return Image.asset(path, fit: fit, width: width, height: height);
      case MediaSource.network:
        return CachedNetworkImage(
          imageUrl: path,
          fit: fit,
          width: width,
          height: height,
          placeholder: (ctx, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (ctx, url, error) =>
              const Icon(Icons.image_not_supported),
        );
      case MediaSource.file:
        return Image.file(File(path), fit: fit, width: width, height: height);
      default:
        return const Icon(Icons.image, size: 48);
    }
  }

  Widget _buildSvg() {
    if (mediaSource == MediaSource.asset) {
      return SvgPicture.asset(
        path,
        fit: fit ?? BoxFit.contain,
        width: width,
        height: height,
      );
    } else if (mediaSource == MediaSource.network) {
      return SvgPicture.network(
        path,
        fit: fit ?? BoxFit.contain,
        width: width,
        height: height,
        placeholderBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
      );
    }
    return const Icon(Icons.image_not_supported);
  }

  Widget _buildVideo(BuildContext context) {
    return _VideoPlayerWrapper(
      url: path,
      source: mediaSource,
    );
  }
}

class _VideoPlayerWrapper extends StatefulWidget {
  final String url;
  final MediaSource source;

  const _VideoPlayerWrapper({
    required this.url,
    required this.source,
  });

  @override
  State<_VideoPlayerWrapper> createState() => _VideoPlayerWrapperState();
}

class _VideoPlayerWrapperState extends State<_VideoPlayerWrapper> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() async {
    if (widget.source == MediaSource.asset) {
      _controller = VideoPlayerController.asset(widget.url);
    } else if (widget.source == MediaSource.network) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    } else {
      _controller = VideoPlayerController.file(File(widget.url));
    }

    await _controller!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _controller!,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      showControls: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    setState(() {});
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController != null && _controller!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: Chewie(controller: _chewieController!),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
