import 'package:equatable/equatable.dart';

class UploadingChatImage extends Equatable {
  final String imagePath;
  final bool isLocal;

  const UploadingChatImage({
    required this.imagePath,
    this.isLocal = true,
  });

  @override
  List<Object> get props => [imagePath, isLocal];
}
