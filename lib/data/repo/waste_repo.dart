import 'package:manize/common/http_client.dart';
import 'package:manize/data/source/waste_data_source.dart';
import 'package:manize/data/waste.dart';
 final wasteRepository=WasteRepository(WasteDataSource(httpClient));
abstract class IWasteRepository {
  Future<List<WasteEntity>> getAllWaste();
}

class WasteRepository implements IWasteRepository {
  final IWasteDataSource wasteDataSource;

  WasteRepository(this.wasteDataSource);

  @override
  Future<List<WasteEntity>> getAllWaste() {
    return wasteDataSource.getAllWaste();
  }
}
