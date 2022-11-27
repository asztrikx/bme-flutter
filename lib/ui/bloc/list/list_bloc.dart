import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:flutter_homework/ui/bloc/tokenManager/TokenManager.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  var dio = GetIt.I<Dio>();
  var tokenMngr = GetIt.I<TokenManager>();

  ListBloc() : super(ListInitial()) {
    on<ListLoadEvent>((event, emit) async {
      if (state is ListLoading) return;
      emit(ListLoading());

      try {
        var result = await dio.get("/users");
        var list = <UserItem>[];
        for (int i = 0; i < result.data.length; i++) {
          list.add(UserItem.fromJson(result.data[i]));
        }
        emit(ListLoaded(list));
      } on DioError catch(e) {
        var text = e.response?.data["message"];
        if (text == "") text = "Hiba történt!";
        emit(ListError(text));
      }
    });
  }
}
