import 'package:flutter_bloc/flutter_bloc.dart';

class ValueCubit<T> extends Cubit<T>{
  T _value;

  ValueCubit(this._value) : super(_value);

  T get value => _value;

  set value(T newValue) {
    _value = newValue;
    emit(newValue);
  }
}