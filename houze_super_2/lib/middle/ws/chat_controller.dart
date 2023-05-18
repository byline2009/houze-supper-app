import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/screen/community/chat/models/index.dart';
import 'package:houze_super/presentation/screen/community/chat/widgets/run_constant.dart';
import 'package:houze_super/providers/log_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:houze_super/utils/index.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'index.dart';

class ChatController {
  // Events
  static const String EVENT_CONNECTED = 'connected';
  static const String EVENT_SIGN_IN = 'signin';
  static const String EVENT_MESSAGE_SEND = 'message.send';
  static const String EVENT_JOIN = 'join';
  static const String EVENT_MESSAGE_LAST = 'message.last';
  static const String EVENT_RECCONECT_SUCCESS = 'reconnect';
  static const String EVENT_JOIN_ROOM_REF_ID = 'join.ref_id';
  static const String EVENT_LEAVE_ROOM = 'leave';

  //Lỗi disconnect
  static const String DISCONNECTED_BY_SERVER = 'io server disconnect';
  static const String DISCONNECTED_BY_PING_TIMEOUT = 'ping timeout';
  static const String DISCONNECTED_BY_TRANSPORT_CLOSE = 'transport close';
  static const String DISCONNECTED_BY_CLIENT = 'io client disconnect';
  static const String DISCONNECTED_BY_TRANSPORT_ERROR = 'transport error';

  static const String websocket = 'websocket';

  // Status
  static const int STATUS_SUCCESS = 200;
  static const int STATUS_FAILURE = 401;

  static IO.Socket? socket;
  static EventBus eventBus = EventBus();
  static LogProvider get logger => const LogProvider('💌 ChatController');

  //Singleton
  ChatController._privateConstructor();

  static final ChatController _instance = ChatController._privateConstructor();

  factory ChatController() {
    return _instance;
  }

  bool get isSocketOpen => socket != null && socket!.connected;

  void logMessage(String title) {
    logger.log(
        ''' $title  connected:${socket?.connected}  socket.io.readyState: ${socket?.io.readyState}''');
  }

  void connectToServer() {
    try {
      logMessage('init()');
      if (socket == null || socket?.id == null) {
        socket = IO.io(
          ChatPath.channelChat,
          IO.OptionBuilder()
              .setTransports([websocket])
              .enableAutoConnect()
              .enableReconnection()
              .build(),
        );
      }

      if (socket?.connected == true) return;
      socket!.onConnect((data) {
        logMessage("*** Emit *** EVENT_SIGN_IN data: $data");
        socket!.emit(EVENT_SIGN_IN, {
          "authorization": OauthAPI.token,
          "app_id": AppConstant.appID,
        });
      });

      socket!.on(
        EVENT_CONNECTED,
        (data) async {
          if (data != null && data['statusCode'] == STATUS_SUCCESS) {
            String? token =
                ConnectedSignInModel.fromJson(data).data!.token ?? '';
            if (token.isNotEmpty) {
              Storage.saveChatToken(token);
              eventBus.fire(
                EventReConnected(
                  isConnected: true,
                ),
              );
              logMessage(
                  '*** On *** EVENT_CONNECTED statusCode: ${data['statusCode']} Token: $token, socketId: ${socket!.id} conneted: ${socket!.connected}');
            }
          }
          if (data['statusCode'] == STATUS_FAILURE) {
            try {
              //call API để refresh lại token
              final profileAPI = ProfileAPI();
              await profileAPI.getProfile();
              //emit singin lại
              socket!.emit(
                'signin',
                {
                  "authorization": OauthAPI.token,
                  "app_id": AppConstant.appID,
                },
              );
            } on FormatException catch (e) {
              logMessage(
                  '*** On *** EVENT_CONNECTED ERROR: ${e.message.toString()} ');
            } catch (e) {
              logMessage('*** On *** EVENT_CONNECTED ERROR: ${e.toString()} ');
              throw e;
            }
          }
        },
      );

/*
*Nhận tin nhắn cuối cùng về để update tại danh sách tin nhắn
*/
      socket!.on(EVENT_MESSAGE_LAST, (logMessage) {
        //EventLoadNewLastMessage
        if (logMessage != null && logMessage["statusCode"] == STATUS_SUCCESS) {
          final newLastlogMessage = LastMessageModel.fromJson(
            logMessage['data'],
          );
          eventBus.fire(
            EventLoadNewLastMessage(
              newLastlogMessage,
            ),
          );
        }
      });

/*
*Nhận sự kiện join room thành công
*/

      socket!.on(EVENT_JOIN, (data) {
        logMessage('*** On *** EVENT_JOIN room data: $data');
        if (data != null &&
            data['statusCode'] == ChatController.STATUS_SUCCESS) {
          final baseDataModel = BaseDataModel.fromJson(data);
          final joinRoom = JoinRoomModel.fromJson(baseDataModel.data);
          eventBus.fire(EventJoinRoom(joinRoom));
        }
      });
/*
*Nhận tin nhắn về trong room
*/
      socket!.on(EVENT_MESSAGE_SEND, (data) {
        logMessage('*** On *** EVENT_MESSAGE_SEND data: $data');

        if (data != null && data['statusCode'] == STATUS_SUCCESS) {
          final baseData = BaseDataModel.fromJson(data);
          final result = MessageReceivedModel.fromJson(baseData.data);
          eventBus.fire(EventReceivedMessage(messageModel: result));
        }
      });

      socket!.on('errors', (logMessage) {
        logMessage(' *** On *** errors : reason: $logMessage');
      });

      socket!.on('action', (logMessage) {
        logMessage('*** On *** action : reason: $logMessage');
      });

/*
 * "reconnect":
 * - kết nối lại thành công.
 * - attemptNumber: số lần kết nối lại
 */
      socket!.on(EVENT_RECCONECT_SUCCESS, (attemptNumber) {
        logMessage(
          'EVENT_RECCONECT_SUCCESS $attemptNumber lần',
        );
      });
/*
 * "reconnecting"
 * - đang có một kết nối lại.
 * - attemptNumber: số lần kết nối lại.
*/
      socket!.on('reconnecting', (attemptNumber) {
        // logMessage(
        //     '*** On *** reconnecting đang có một kết nối lại với: $attemptNumber lần ');
      });

/*
* "reconnect_error"
 * Event này là bị lỗi khi kết nối lại.
 * error là object đón lỗi. 
 */
      socket!.on('reconnect_error', (error) {
        // logMessage(
        //     '*** On *** reconnect_error Lỗi khi kết nối lại.\n Error: ${error.toString()} ');
      });
/*
 *"reconnect_failed"
 * - Event này không thể reconnect được nữa.
 */
      socket!.on(
        'reconnect_failed',
        (error) {
          logMessage(
              '*** On *** reconnect_failed: Không thể reconnect được nữa. Error: ${error.toString()} ');
        },
      );
/*
 *"connect_error"
 * - Event này là kết nối đã bị lỗi.
 */
      socket!.on(
        'connect_error',
        (error) {
          // logMessage(
          //     '*** On *** connect_error: kết nối đã bị lỗi. Error: ${error.toString()} ');
        },
      );
/**
 * 'connect_timeout'
 * - lỗi kết nối quá lâu. 
 * - Sau khi client bị lỗi này thì server sẽ nhảy vào event "disconnect"
 * và
 * - "disconnecting" với reason là "ping timeout"
 */
      socket!.on(
        'connect_timeout',
        (timeout) {
          logMessage(
            'connect_timeout',
          );
          logMessage('*** On *** connect_timeout: timeout: $timeout ');
        },
      );
/*
 * Event này là client xảy ra lỗi.
 */
      socket!.on(
        'error',
        (error) {
          logMessage('*** On *** Error: ${error.toString()} ');
        },
      );

      socket!.onDisconnect((reason) {
        logMessage(
          'onDisconnect: $reason',
        );

        switch (reason.toString().toLowerCase()) {
          case DISCONNECTED_BY_SERVER:
          case DISCONNECTED_BY_CLIENT:
            // the disconnection was initiated by the server or client,
            //  the client will not try to reconnect and you need to manually call socket.connect().
            socket!.connect();
            break;

          case DISCONNECTED_BY_PING_TIMEOUT:
          case DISCONNECTED_BY_TRANSPORT_CLOSE:
          case DISCONNECTED_BY_TRANSPORT_ERROR:
            if (socket!.disconnected || socket!.id == null) {
              eventBus.fire(
                EventSocketDisconnected(
                  reason: reason.toString().toLowerCase(),
                ),
              );
            }
            break;

          default:
            break;
        }
      });

      socket!.onError((logMessage) {
        logMessage(' onError: $logMessage ');
      });

      socket!.onReconnecting((logMessage) {
        // logMessage(' onReconnecting: $logMessage ');
      });

      socket!.onReconnect((data) {
        logMessage(
          'EVENT_RECCONECT_SUCCESS $data lần',
        );
      });
    } catch (e) {
      logMessage(e.toString());
    }
  }

/*
*Gửi tin nhắn đi
*/
  void sendSingleChatMessage({
    required String message,
    required String roomID,
  }) {
    if (isSocketOpen && roomID.isNotEmpty) {
      String token = Storage.getChatToken();
      logMessage('*** Emit *** EVENT_MESSAGE_SEND: $message ');
      socket!.emit(
        EVENT_MESSAGE_SEND,
        {
          "authorization": token,
          "data": {
            "id": roomID,
            "type": RunConstant.kChatTypeText,
            "message_text": message,
          }
        },
      );
    }
  }

  /*
*Gửi hình ảnh đi
*/
  void sendImageChat({
    required String imageUrl,
    required String roomID,
  }) {
    if (isSocketOpen && roomID.isNotEmpty) {
      String token = Storage.getChatToken();
      logMessage('*** Emit *** EVENT_MESSAGE_SEND: image: $imageUrl ');
      socket!.emit(
        EVENT_MESSAGE_SEND,
        {
          "authorization": token,
          "data": {
            "id": roomID,
            "type": RunConstant.kChatTypeImage,
            "message_text": imageUrl,
          }
        },
      );
    }
  }

  /*
*Gửi tin nhắn kèm hình ảnh đi
*/
  void sendImageTextChat({
    required String image,
    required String text,
    required String roomID,
  }) {
    if (isSocketOpen) {
      String token = Storage.getChatToken();
      MessageTextModel model = MessageTextModel(
        imageUrl: image,
        message: text,
      );
      final data = json.encode(model.toJson());
      logMessage(
          '*** Emit *** EVENT_MESSAGE_SEND: roomID: $roomID \t message: $text \t image: $image ');
      socket!.emit(
        EVENT_MESSAGE_SEND,
        {
          "authorization": token,
          "data": {
            "id": roomID,
            "type": RunConstant.kChatTypeImage,
            "message_text": data.toString(),
          }
        },
      );
    }
  }

/*
*Gửi tin nhắn đi
*/
  void userRequestJoinRoomFromTeam({
    required String refID,
    required String title,
  }) {
    if (isSocketOpen) {
      logMessage(
          '*** Emit *** EVENT_JOIN_ROOM_REF_ID: groupID: $refID title: $title');
      String token = Storage.getChatToken();
      socket!.emit(EVENT_JOIN_ROOM_REF_ID, {
        "data": {
          "type": 'GROUP',
          "ref_id": refID,
          "title": title,
          "app_id": AppConstant.appID,
        },
        "authorization": token,
      });
    }
  }

  /*
*gửi hành động join group chat
*/
  void emitEventJoinRoom({
    required String roomID,
    required String title,
  }) {
    if (isSocketOpen) {
      String token = Storage.getChatToken();
      logMessage(
          '*** Emit *** Join team: roomID: $roomID \t title: $title socket.connect: ${socket!.connected}');
      socket!.emit(EVENT_JOIN, {
        "data": {
          "type": 'GROUP',
          "id": roomID,
          "title": title,
        },
        "authorization": token,
      });
    }
  }

/*
* Gửi hành động user rời phòng chat
*/
  void userLeaveChatRoom({
    required String roomID,
    required String roomName,
  }) {
    // token,
    if (isSocketOpen) {
      String token = Storage.getChatToken();

      logMessage(
        'userLeaveChatRoom id: $roomID name: $roomName',
      );
      socket!.emit(
        EVENT_LEAVE_ROOM,
        {
          "data": {
            "id": roomID,
          },
          "authorization": token,
        },
      );
    }
  }

  /*
   * Event: Đã đọc tin nhắn mới
   */
  void readChat({
    required MessageModel item,
    required String roomID,
  }) {
    eventBus.fire(
      EventReadChat(
        item: item,
        roomID: roomID,
      ),
    );
  }

/*
*Kết thúc 
*/
  Future<void> dispose() async {
    await Storage.removeChatToken();
    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
      logMessage(" closeConnection()");
    }
  }
}
