

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

typedef ViewModelBuilder<T> = Widget Function(BuildContext context, T viewModel, Widget? child);

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  final T Function() viewModelBuilder;
  final ViewModelBuilder<T> builder;
  final Function(T)? onModelReady;
  final bool autoDispose;

  const BaseView({
    Key? key,
    required this.viewModelBuilder,
    required this.builder,
    this.onModelReady,
    this.autoDispose = true,
  }) : super(key: key);

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>> {
  late T viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModelBuilder();
    widget.onModelReady?.call(viewModel);
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: viewModel,
      child: Consumer<T>(
        builder: widget.builder,
      ),
    );
  }
}