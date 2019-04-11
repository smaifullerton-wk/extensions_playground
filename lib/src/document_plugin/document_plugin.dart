import 'package:extensions_playground/selection_plugin.dart';
import 'package:extensions_playground/src/document_plugin/document_container.dart';
import 'package:extensions_playground/src/document_plugin/document_module.dart';
import 'package:extensions_playground/workiva_plugin.dart';
import 'package:plugin/plugin.dart';

class DocumentPlugin extends Plugin {
  Document _container;

  @override
  String get uniqueIdentifier => 'document';

  Future<Null> init() async {
    _container = await Document.create(new PlatformServicesModule(),
        new SelectionCommandsModule(), new DocumentModule());
  }

  @override
  void registerExtensions(RegisterExtension register) {
    // contexts
    register(_container.getContextExtensionPointId(),
        new ContextTemplate(ContextConstants.document, ContextConstants.root));

    // handlers
    register(
        _container.getHandlersExtensionPointId(), _container.getBoldHandler());
    register(_container.getHandlersExtensionPointId(),
        _container.getItalicHandler());

    register(
        'selections.selection_provider', _container.getSelectionProvider());

    // editors
    register(_container.getContentEditorFactoryExtensionPointId(),
        _container.getDocumentEditorFactory());
  }

  @override
  void registerExtensionPoints(RegisterExtensionPoint register) {}
}
