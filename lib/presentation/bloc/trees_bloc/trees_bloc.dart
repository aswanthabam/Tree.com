import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tree_com/data/models/tree_model.dart';
import 'package:tree_com/data/repositories/tree_respository.dart';

part 'trees_event.dart';

part 'trees_state.dart';

class TreesBloc extends Bloc<TreesEvent, TreesState> {
  TreeRepository _repository;

  TreesBloc({required TreeRepository repository})
      : _repository = repository,
        super(TreesInitial()) {
    on<AddTreeEvent>((event, emit) async {
      emit(TreesAddLoading());
      await _repository
          .addTree(event.title, event.description, event.image, event.latitude,
              event.longitude)
          .then((response) {
        response.fold(
          (error) => emit(TreesAddFailure(error)),
          (message) => emit(TreesAddSuccess(message)),
        );
      });
    });

    on<GetNearbyTreesEvent>((event, emit) async {
      emit(TreesGetNearbyLoading());
      await _repository
          .getNearbyTrees(event.latitude, event.longitude)
          .then((response) {
        response.fold(
          (trees) => emit(TreesGetNearbySuccess(trees)),
          (error) => emit(TreesGetNearbyFailure(error)),
        );
      });
    });
  }
}
