import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigurationService {


  /// getIpRaspberryPi() - obtain the IP address of raspberry pi from the environment file 
  String? getIpRaspberryPi(){

    return dotenv.env['IP_RASP'];

  }

  /// getBasicUrlHttp() - obtain the IP address of raspberry pi from the environment file 
  String? getBasicUrlHttp(){

    return dotenv.env['URL'];

  }


  /// getPortMicroservice() - obtain the IP address of raspberry pi from the environment file 
  String? getPortMicroservice(){

    return dotenv.env['PORT'];
    
  }

}