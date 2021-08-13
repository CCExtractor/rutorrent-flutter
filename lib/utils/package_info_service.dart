import 'package:package_info/package_info.dart';

///A Service to fetch [PackageInfo]
class PackageInfoService {
  Future<PackageInfo> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  } 
}
