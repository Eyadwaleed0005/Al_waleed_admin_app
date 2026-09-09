import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alwaleed_admain/core/connection/cubit/network_status_cubit.dart';
import 'package:alwaleed_admain/core/connection/network/internet_connection_network_info.dart';
import 'package:alwaleed_admain/core/connection/network/network_info.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firebase_firestore_service.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admain/core/firebase/storage/firebase_storage_service.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

void registerCoreDependencies(GetIt getIt) {
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  getIt.registerLazySingleton<FirebaseFunctions>(
    () => FirebaseFunctions.instanceFor(region: 'us-central1'),
  );

  getIt.registerLazySingleton<NetworkInfo>(
    () => InternetConnectionNetworkInfo(),
  );

  getIt.registerLazySingleton<FirestoreService>(
    () => FirebaseFirestoreService(
      networkInfo: getIt<NetworkInfo>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<StorageService>(
    () => FirebaseStorageService(
      networkInfo: getIt<NetworkInfo>(),
      firebaseStorage: getIt<FirebaseStorage>(),
    ),
  );

  getIt.registerLazySingleton<NetworkStatusCubit>(
    () => NetworkStatusCubit(networkInfo: getIt<NetworkInfo>()),
  );
}
