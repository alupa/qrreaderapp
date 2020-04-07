import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = MapController();

  String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () => map.move(scan.getLatLng(), 15),
          )
        ],
      ),
      body: Center(
        child: _crearFlutterMap(scan)
      ),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        // 'accessToken': Constants.API_KEY_MAPBOX,
        'accessToken' : DotEnv().env['API_KEY_MAPBOX'],
        'id': 'mapbox.$tipoMapa' // streets, dark, light, outdoors, satellite
      }
    );
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on, 
              size: 50.0,
              color: Theme.of(context).primaryColor,
              ),
          )
        ),
      ]
    );
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        // streets, dark, light, outdoors, satellite
        switch(tipoMapa){
          case 'streets' : tipoMapa = 'dark'; break;
          case 'dark'    : tipoMapa = 'light'; break;
          case 'light'   : tipoMapa = 'outdoors'; break;
          case 'outdoors': tipoMapa = 'satellite'; break;
          default        : tipoMapa = 'streets';
        }

        setState((){});
      },
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}