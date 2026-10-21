import 'package:flutter_test/flutter_test.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:yes_no_app/infrastructure/models/yes_no_model.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart';

void main() {
  test('YesNoModel converts to Message entity correctly', () {
    final model = YesNoModel(
      answer: 'yes',
      forced: false,
      image: 'https://yesno.wtf/assets/yes/2.gif',
    );

    final message = model.toMessageEntity();

    expect(message.text, 'Si');
    expect(message.fromWho, FromWho.hers);
    expect(message.imageUrl, 'https://yesno.wtf/assets/yes/2.gif');
  });

  test('ChatProvider starts with initial messages', () {
    final chatProvider = ChatProvider();

    expect(chatProvider.messageList.length, 2);
    expect(chatProvider.messageList[0].text, 'Hola amor!');
    expect(chatProvider.messageList[0].fromWho, FromWho.me);
  });
}
