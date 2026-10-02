import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:getdash/core/auth/model/mock_user.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;

  User? get currentFirebaseUser => _auth.currentUser;
  bool get isAuthenticated => _auth.currentUser != null;

  /// Inicializa colecciones y usuarios de prueba en Firestore y Firebase Auth
  Future<Map<String, dynamic>> seedDatabase() async {
    int usersCreated = 0;
    int coopsCreated = 0;
    int casesCreated = 0;
    int emergenciesCreated = 0;

    try {
      // 1. Semillero de Cooperativas
      final List<Map<String, dynamic>> initialCooperatives = [
        {
          'id': 'COOP-01',
          'nombre': 'Cooperativa Los Lagos',
          'tipo': 'Taxis Ejecutivos',
          'canton': 'Otavalo',
          'provincia': 'Imbabura',
          'unidadesActivas': 48,
          'convenioLegal': 'Activo • Asistencia Penal y Tránsito 24/7',
          'contacto': '+593 6 292 0100',
        },
        {
          'id': 'COOP-02',
          'nombre': 'Cooperativa San Cristóbal',
          'tipo': 'Transporte Interprovincial',
          'canton': 'Ibarra',
          'provincia': 'Imbabura',
          'unidadesActivas': 32,
          'convenioLegal': 'Activo • Cobertura Nacional',
          'contacto': '+593 6 295 1200',
        },
        {
          'id': 'COOP-03',
          'nombre': 'Cooperativa Flota Imbabura',
          'tipo': 'Transporte Pesado y Carga',
          'canton': 'Ibarra',
          'provincia': 'Imbabura',
          'unidadesActivas': 25,
          'convenioLegal': 'Activo • Asistencia en Ruta',
          'contacto': '+593 6 260 5500',
        },
      ];

      for (var coop in initialCooperatives) {
        await _firestore.collection('cooperativas').doc(coop['id']).set(coop, SetOptions(merge: true));
        coopsCreated++;
      }

      // 2. Semillero de Usuarios Oficiales (Users)
      final List<Map<String, dynamic>> initialUsers = [
        {
          'id': 'USER-IT-01',
          'name': 'Ing. Dario (Admin TI)',
          'email': 'admin@legaltech.ec',
          'password': 'admin123',
          'role': 'itAdmin',
          'canton': 'Quito',
          'phone': '+593 99 000 1122',
          'isAvailable': true,
          'subscriptionStatus': 'active',
          'subscriptionPlan': 'enterprise_it',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'USER-LAW-DIR',
          'name': 'Dr. Emir Vásquez',
          'email': 'emir@legaltech.ec',
          'password': 'emir123',
          'role': 'adminLawyer',
          'canton': 'Ibarra',
          'phone': '+593 98 776 5544',
          'isAvailable': true,
          'subscriptionStatus': 'active',
          'subscriptionPlan': 'legal_director',
          'matriculaForo': '10-2015-442-CJ',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'LAWYER-001',
          'name': 'Dra. Andrea Morales',
          'email': 'abogado@legaltech.ec',
          'password': 'abogado123',
          'role': 'associateLawyer',
          'canton': 'Ibarra',
          'phone': '+593 99 445 1200',
          'isAvailable': true,
          'subscriptionStatus': 'active',
          'subscriptionPlan': 'lawyer_turn',
          'matriculaForo': '10-2019-118-CJ',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'DRIVER-042',
          'name': 'Carlos Mendoza',
          'email': 'conductor@legaltech.ec',
          'password': 'conductor123',
          'role': 'clientDriver',
          'cooperativeId': 'COOP-01',
          'cooperativeName': 'Cooperativa Los Lagos',
          'canton': 'Otavalo',
          'phone': '+593 99 482 1045',
          'cedula': '1002345678',
          'placa': 'IBA-1234',
          'unidadTaxi': 'Unidad #42',
          'licencia': 'Tipo C Profesional',
          'isAvailable': true,
          'subscriptionStatus': 'active',
          'subscriptionPlan': 'conductor_pro',
          'subscriptionExpiresAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'LAWYER-TEMP-002',
          'name': 'Dr. Carlos Revelo',
          'email': 'carlos.revelo@legaltech.ec',
          'password': 'LegalTech2026!',
          'role': 'associateLawyer',
          'canton': 'Ibarra',
          'phone': '+593 99 778 9900',
          'cedula': '1003456789',
          'matriculaForo': '10-2022-315-CJ',
          'debeCambiarClave': true,
          'isAvailable': true,
          'subscriptionStatus': 'active',
          'subscriptionPlan': 'lawyer_turn',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var user in initialUsers) {
        await _firestore.collection('users').doc(user['id']).set(user, SetOptions(merge: true));
        usersCreated++;

        // Modelo híbrido: reflejo en colecciones especializadas
        if (user['role'] == 'clientDriver') {
          await _firestore.collection('conductores').doc(user['id']).set(user, SetOptions(merge: true));
        } else if (user['role'] == 'associateLawyer' || user['role'] == 'adminLawyer') {
          await _firestore.collection('abogados').doc(user['id']).set(user, SetOptions(merge: true));
        }

        // Registrar credenciales en Firebase Auth para login directo
        try {
          await _auth.createUserWithEmailAndPassword(
            email: user['email'],
            password: user['password'] ?? user['temporaryPassword'] ?? 'Password123!',
          );
        } catch (_) {
          // Ya existe en Auth o regla restringida
        }
      }

      // 3. Semillero de Casos Legales
      final List<Map<String, dynamic>> initialCases = [
        {
          'id': 'CASO-2026-001',
          'numeroCaso': 'LEG-2026-089',
          'titulo': 'Alcance por alcance en Redondel de González Suárez',
          'conductorId': 'DRIVER-042',
          'conductorNombre': 'Carlos Mendoza (Unidad #42)',
          'abogadoId': 'LAWYER-001',
          'abogadoNombre': 'Dra. Andrea Morales',
          'tipoAccidente': 'Choque lateral con daños materiales leves',
          'estado': 'Acta Transaccional Firmada',
          'resolucion': 'Art. 380 COIP: Acuerdo amistoso notariado, pago directo de \$45 sin retención del taxi.',
          'cooperativaId': 'COOP-01',
          'fecha': FieldValue.serverTimestamp(),
        },
        {
          'id': 'CASO-2026-002',
          'numeroCaso': 'LEG-2026-090',
          'titulo': 'Rozamiento en Panamericana Norte Km 12',
          'conductorId': 'DRIVER-042',
          'conductorNombre': 'Carlos Mendoza (Unidad #42)',
          'abogadoId': 'LAWYER-001',
          'abogadoNombre': 'Dra. Andrea Morales',
          'tipoAccidente': 'Rozamiento con vehículo particular',
          'estado': 'En Proceso Pericial',
          'resolucion': 'Esperando peritaje de la Agencia Civil de Tránsito de Otavalo.',
          'cooperativaId': 'COOP-01',
          'fecha': FieldValue.serverTimestamp(),
        },
      ];

      for (var caso in initialCases) {
        await _firestore.collection('casos_legales').doc(caso['id']).set(caso, SetOptions(merge: true));
        casesCreated++;
      }

      // 4. Semillero de Alertas SOS
      final List<Map<String, dynamic>> initialEmergencies = [
        {
          'id': 'SOS-DEMO-01',
          'conductorId': 'DRIVER-042',
          'conductorNombre': 'Carlos Mendoza',
          'unidadTaxi': 'Unidad #42 • Coo. Los Lagos',
          'telefono': '+593 99 482 1045',
          'latitud': 0.2305,
          'longitud': -78.2568,
          'direccionAproximada': 'Av. Bolívar y Rocafuerte, Otavalo',
          'estado': 'atendido',
          'tipoAlerta': 'Accidente de Tránsito con daños',
          'abogadoAsignadoId': 'LAWYER-001',
          'abogadoAsignadoNombre': 'Dra. Andrea Morales',
          'fecha': FieldValue.serverTimestamp(),
        },
      ];

      for (var emergency in initialEmergencies) {
        await _firestore.collection('emergencias_sos').doc(emergency['id']).set(emergency, SetOptions(merge: true));
        emergenciesCreated++;
      }

      return {
        'success': true,
        'usersCreated': usersCreated,
        'coopsCreated': coopsCreated,
        'casesCreated': casesCreated,
        'emergenciesCreated': emergenciesCreated,
      };
    } catch (e) {
      debugPrint('Error en seedDatabase: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Inicia sesión con Firebase Auth
  Future<UserCredential?> signIn({required String email, required String password}) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Busca un usuario o conductor por su número de cédula en Firestore
  Future<Map<String, dynamic>?> getUserByCedula(String cedula) async {
    final cleanCedula = cedula.trim();
    if (cleanCedula.isEmpty) return null;

    try {
      final snap = await _firestore
          .collection('users')
          .where('cedula', isEqualTo: cleanCedula)
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) {
        return snap.docs.first.data();
      }

      final condSnap = await _firestore
          .collection('conductores')
          .where('cedula', isEqualTo: cleanCedula)
          .limit(1)
          .get();
      if (condSnap.docs.isNotEmpty) {
        return condSnap.docs.first.data();
      }
    } catch (e) {
      debugPrint('Error buscando usuario por cédula: $e');
    }
    return null;
  }

  /// Busca un usuario, abogado o conductor por su correo electrónico en Firestore
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty) return null;

    try {
      final snap = await _firestore
          .collection('users')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) {
        return snap.docs.first.data();
      }

      final abogSnap = await _firestore
          .collection('abogados')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();
      if (abogSnap.docs.isNotEmpty) {
        return abogSnap.docs.first.data();
      }

      final condSnap = await _firestore
          .collection('conductores')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();
      if (condSnap.docs.isNotEmpty) {
        return condSnap.docs.first.data();
      }
    } catch (e) {
      debugPrint('Error buscando usuario por email: $e');
    }
    return null;
  }

  /// Crea un nuevo usuario y su perfil en Firestore (Modelo Híbrido: users + conductores/abogados)
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? phone,
    String? cooperativeId,
    String? cooperativeName,
    String? canton,
    String? cedula,
    String? matriculaForo,
    String? placa,
    String? unidadTaxi,
    String? licencia,
    String? foto,
    bool debeCambiarClave = false,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (cred.user != null) {
      final uid = cred.user!.uid;

      // 1. Colección centralizada users para autenticación rápida
      await _firestore.collection('users').doc(uid).set({
        'id': uid,
        'name': name,
        'email': email,
        'role': role.name,
        'phone': phone ?? '',
        'cooperativeId': cooperativeId,
        'cooperativeName': cooperativeName,
        'canton': canton ?? (role == UserRole.clientDriver ? 'Otavalo' : 'Ibarra'),
        'cedula': cedula,
        'matriculaForo': matriculaForo,
        'placa': placa,
        'unidadTaxi': unidadTaxi,
        'licencia': licencia,
        'foto': foto,
        'debeCambiarClave': debeCambiarClave,
        'isAvailable': true,
        'subscriptionStatus': 'active',
        'subscriptionPlan': role == UserRole.clientDriver ? 'conductor_pro' : 'lawyer_turn',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 2. Reflejo directo en colecciones dedicadas
      if (role == UserRole.clientDriver) {
        await _firestore.collection('conductores').doc(uid).set({
          'id': uid,
          'name': name,
          'email': email,
          'phone': phone ?? '',
          'cooperativeId': cooperativeId,
          'cooperativeName': cooperativeName,
          'canton': canton ?? 'Otavalo',
          'cedula': cedula,
          'placa': placa,
          'unidadTaxi': unidadTaxi,
          'licencia': licencia,
          'foto': foto,
          'subscriptionStatus': 'active',
          'subscriptionPlan': 'conductor_pro',
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else if (role == UserRole.associateLawyer || role == UserRole.adminLawyer) {
        await _firestore.collection('abogados').doc(uid).set({
          'id': uid,
          'name': name,
          'email': email,
          'phone': phone ?? '',
          'canton': canton ?? 'Ibarra',
          'cedula': cedula,
          'matriculaForo': matriculaForo,
          'debeCambiarClave': debeCambiarClave,
          'isAvailable': true,
          'subscriptionStatus': 'active',
          'subscriptionPlan': 'lawyer_turn',
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    }
    return cred;
  }

  /// Actualiza la contraseña del usuario en Firebase Auth y la bandera en Firestore (users y abogados)
  Future<void> updatePassword(String newPassword, {String? cedula, String? email}) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.updatePassword(newPassword);
      } catch (e) {
        debugPrint('Firebase Auth updatePassword error: $e');
      }
      await _firestore.collection('users').doc(user.uid).set({
        'debeCambiarClave': false,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await _firestore.collection('abogados').doc(user.uid).set({
        'debeCambiarClave': false,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    if (cedula != null && cedula.isNotEmpty) {
      try {
        final uDocs = await _firestore.collection('users').where('cedula', isEqualTo: cedula).get();
        for (var doc in uDocs.docs) {
          await doc.reference.set({
            'debeCambiarClave': false,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
        final aDocs = await _firestore.collection('abogados').where('cedula', isEqualTo: cedula).get();
        for (var doc in aDocs.docs) {
          await doc.reference.set({
            'debeCambiarClave': false,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      } catch (e) {
        debugPrint('Error actualizando debeCambiarClave en Firestore por cédula: $e');
      }
    }

    if (email != null && email.isNotEmpty) {
      try {
        final cleanEmail = email.trim().toLowerCase();
        final uDocs = await _firestore.collection('users').where('email', isEqualTo: cleanEmail).get();
        for (var doc in uDocs.docs) {
          await doc.reference.set({
            'debeCambiarClave': false,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
        final aDocs = await _firestore.collection('abogados').where('email', isEqualTo: cleanEmail).get();
        for (var doc in aDocs.docs) {
          await doc.reference.set({
            'debeCambiarClave': false,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      } catch (e) {
        debugPrint('Error actualizando debeCambiarClave en Firestore por email: $e');
      }
    }
  }

  /// Cierra sesión en Firebase Auth
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error en Firebase signOut: $e');
    }
  }

  /// Streams especializados
  Stream<QuerySnapshot<Map<String, dynamic>>> streamLawyers() {
    return _firestore.collection('abogados').orderBy('createdAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamDrivers() {
    return _firestore.collection('conductores').orderBy('createdAt', descending: true).snapshots();
  }

  /// Obtiene los datos del usuario desde Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  /// Stream en tiempo real de emergencias SOS
  Stream<QuerySnapshot<Map<String, dynamic>>> streamEmergencies() {
    return _firestore.collection('emergencias_sos').orderBy('fecha', descending: true).snapshots();
  }

  /// Registrar una nueva emergencia SOS
  Future<DocumentReference<Map<String, dynamic>>> createSosEmergency(Map<String, dynamic> data) async {
    data['fecha'] = FieldValue.serverTimestamp();
    return await _firestore.collection('emergencias_sos').add(data);
  }

  /// Stream en tiempo real de casos legales
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCases() {
    return _firestore.collection('casos_legales').orderBy('fecha', descending: true).snapshots();
  }

  /// Actualiza la suscripción de un conductor en Firestore
  Future<void> updateDriverSubscription({
    required String driverId,
    required Map<String, dynamic> subscriptionData,
  }) async {
    try {
      await _firestore.collection('conductores').doc(driverId).set({
        'suscripcion': subscriptionData,
        'subscriptionStatus': subscriptionData['activa'] == true ? 'active' : 'suspended',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error actualizando suscripción en Firestore: $e');
    }
  }
}
