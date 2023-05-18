import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'widgets.dart';

class WidgetLocation extends StatelessWidget {
  final TicketDetailModel ticket;
  const WidgetLocation({
    @required this.ticket,
  });
  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> _controller = Completer();

    return ticket.lat != null && ticket.long != null
        ? Column(
            children: <Widget>[
              const WidgetSectionTitle(title: 'your_location'),
              BaseWidget.makeContentWrapper(
                  child: SizedBox(
                child: GoogleMap(
                  mapType: MapType.terrain,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(ticket.lat, ticket.long),
                    zoom: 15.0,
                  ),
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  scrollGesturesEnabled: true,
                  markers: Set<Marker>.of([
                    Marker(
                      markerId: MarkerId("0"),
                      position: LatLng(ticket.lat, ticket.long),
                    )
                  ]),
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  ].toSet(),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                height: 160,
              ))
            ],
          )
        : const SizedBox.shrink();
  }
}
