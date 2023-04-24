
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ChangeTotalPriceSuccess extends ProfileState{
   final num total ;
  ChangeTotalPriceSuccess({required this.total});
}
class ChangeTotalPriceLoading extends ProfileState{}
class ChangeTotalPriceError extends ProfileState{}