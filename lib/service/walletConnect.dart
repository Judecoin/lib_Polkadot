import 'dart:async';
import 'dart:convert';

import 'package:polkawallet_sdk/service/index.dart';

class ServiceWalletConnect {
  ServiceWalletConnect(this.serviceRoot);

  final SubstrateService serviceRoot;

  void initClient(
    String uri,
    String address,
    int chainId, {
    required Function(Map) onPairing,
    required Function(Map) onPaired,
    required Function(Map) onCallRequest,
    required Function(String) onDisconnect,
    Map? cachedSession,
  }) {
    if (cachedSession != null) {
      serviceRoot.webView!.evalJavascript(
          'walletConnect.reConnectSession(${jsonEncode(cachedSession)})');
    } else {
      serviceRoot.webView!.evalJavascript(
          'walletConnect.initConnect("$uri", "$address", $chainId)');
    }
    serviceRoot.webView!.addMsgHandler("wallet_connect_message", (data) {
      final event = data['event'];
      switch (event) {
        case 'session_request':
        case 'session_proposal':
          onPairing(data);
          break;
        case 'connect':
          onPaired(data['session']);
          break;
        case 'call_request':
          onCallRequest(data);
          break;
        case 'disconnect':
          onDisconnect(uri);
          break;
      }
    });
  }

  Future<void> disconnect() async {
    await serviceRoot.webView!.evalJavascript('walletConnect.disconnect()');
    serviceRoot.webView!.removeMsgHandler("wallet_connect_message");
  }

  Future<void> confirmPairing(bool approve) async {
    await serviceRoot.webView!
        .evalJavascript('walletConnect.confirmConnect($approve)');
  }

  Future<void> confirmPairingV2(bool approve, String address) async {
    await serviceRoot.webView!
        .evalJavascript('walletConnect.confirmConnectV2($approve, "$address")');
  }

  Future<Map> confirmPayload(
      int id, bool approve, String password, Map gasOptions) async {
    final Map? res = await serviceRoot.webView!.evalJavascript(
        'walletConnect.confirmCallRequest($id, $approve, "$password", ${jsonEncode(gasOptions)})');
    return res ?? {};
  }

  Future<Map> confirmPayloadV2(
      int id, bool approve, String password, Map gasOptions) async {
    final Map? res = await serviceRoot.webView!.evalJavascript(
        'walletConnect.confirmCallRequestV2($id, $approve, "$password", ${jsonEncode(gasOptions)})');
    return res ?? {};
  }

  Future<void> changeAccount(String address) async {
    await serviceRoot.webView!
        .evalJavascript('walletConnect.updateSession({address: "$address"})');
  }

  Future<void> changeAccountV2(String address) async {
    await serviceRoot.webView!
        .evalJavascript('walletConnect.updateSessionV2({address: "$address"})');
  }

  Future<void> changeNetwork(int chainId, String address) async {
    await serviceRoot.webView!.evalJavascript(
        'walletConnect.updateSession({address: "$address", chainId: $chainId})');
  }

  Future<void> changeNetworkV2(int chainId, String address) async {
    await serviceRoot.webView!.evalJavascript(
        'walletConnect.updateSessionV2({address: "$address", chainId: $chainId})');
  }
}
