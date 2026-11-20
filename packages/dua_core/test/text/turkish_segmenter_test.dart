import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

void main() {
  test('cümle sonlarından ve boş satırdan böler, işaret cümlede kalır', () {
    expect(splitTurkish('Allah\'ım! Beni bağışla. Bana merhamet et?\n\nSen Rahmansın'),
        ["Allah'ım!", 'Beni bağışla.', 'Bana merhamet et?', 'Sen Rahmansın']);
  });

  test('üç nokta ve ardışık işaretler tek kesim sayılır; tek satır sonu boşluk olur', () {
    expect(splitTurkish('Ya Rabbi... Bizi\nbağışla!?  Amin.'), ['Ya Rabbi...', 'Bizi bağışla!?', 'Amin.']);
  });
}
