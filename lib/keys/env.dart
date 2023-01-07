import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'ADDRESS_KEY', obfuscate: true)
  static final addressKey = _Env.addressKey;
}
