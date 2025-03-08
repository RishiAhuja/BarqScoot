import 'package:escooter/features/payment/data/repository/promo_repository_impl.dart';
import 'package:escooter/features/payment/data/service/promo_service.dart';
import 'package:escooter/features/payment/domain/repository/promo_repository.dart';
import 'package:escooter/features/profile/presentation/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/promo_code.dart';
import '../../domain/usecases/validate_promo_usecase.dart';

final promoCodeProvider =
    StateNotifierProvider<PromoCodeNotifier, AsyncValue<PromoCode?>>((ref) {
  return PromoCodeNotifier(ref);
});

class PromoCodeNotifier extends StateNotifier<AsyncValue<PromoCode?>> {
  final Ref ref;

  PromoCodeNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> validatePromoCode(String code) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(validatePromoCodeProvider);
      final result = await useCase(params: code);

      result.fold(
        (failure) =>
            state = AsyncValue.error(failure ?? "error", StackTrace.current),
        (promoCode) => state = AsyncValue.data(promoCode),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void clearPromoCode() {
    state = const AsyncValue.data(null);
  }
}

// Add provider for ValidatePromoCode use case
final validatePromoCodeProvider = Provider<ValidatePromoCode>((ref) {
  final repository = ref.watch(promoRepositoryProvider);
  return ValidatePromoCode(repository);
});

// Add provider for PromoRepository
final promoRepositoryProvider = Provider<PromoRepository>((ref) {
  final promoService = ref.watch(promoServiceProvider);
  return PromoRepositoryImpl(promoService);
});

// Add provider for PromoService
final promoServiceProvider = Provider<PromoService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return PromoService(storage);
});
