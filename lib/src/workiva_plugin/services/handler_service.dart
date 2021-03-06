import 'package:extensions_playground/src/workiva_plugin/extension_points/handler_extension_point.dart';
import 'package:extensions_playground/src/workiva_plugin/services/command_service.dart';
import 'package:extensions_playground/src/workiva_plugin/services/context_service.dart';
import 'package:inject/inject.dart';

HandlerService handlerService;

abstract class HandlerService {
  void executeCommand(String commandId);
}

class HandlerServiceImpl implements HandlerService {
  final CommandService _commandService;
  final ContextService _contextService;
  final HandlerExtensionPoint _handlers;

  @provide
  HandlerServiceImpl(
      this._commandService, this._contextService, this._handlers);

  @override
  void executeCommand(String commandId) {
    if (!_commandService.isRegistered(commandId)) return;

    var handler = _handlers.extensionPoint.extensions.firstWhere(
        (h) =>
            h.commandId == commandId &&
            (h.contextId == null ||
                h.contextId == _contextService.activeContextId),
        orElse: () => null);
    if (handler == null) {
      return;
    }

    handler.execute();
  }
}
