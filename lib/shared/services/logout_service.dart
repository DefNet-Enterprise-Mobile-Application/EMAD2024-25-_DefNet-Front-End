import 'package:defnet_front_end/shared/services/configuration_service.dart';
import 'package:defnet_front_end/shared/services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

class LogoutService {

  final ConfigurationService _configurationService = ConfigurationService();


  Future<bool> logout(SecureStorageService secure_storage_service) async {
  

    String? url = _configurationService.getBasicUrlHttp();
    String? ip = _configurationService.getIpRaspberryPi();
    String? port = _configurationService.getPortMicroservice();
    
    String baseUrl = "$url$ip:$port/logout";
    
    String? token = await secure_storage_service.getToken();

    print("Token : $token");
    
    final uriUrlParsed = Uri.parse(baseUrl); 


    try {
      final response = await http.post(
        uriUrlParsed,
        headers: {
          'Authorization':
              'Bearer $token', // Aggiungi il token nell'header Authorization
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Logout riuscito
        print("Logged out successfully");
        // Gestisci la navigazione o lo stato del logout
        bool response = await secure_storage_service.delete();

        if(response){
        
          return true;
        
        }else{

          return false;
        
        }
      } else {
        print('Logout failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }



}
