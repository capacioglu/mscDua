# Dualarım

Duaları Arapça aslı, Türkçe/İngilizce okunuşu ve anlamıyla gösteren; sesi çalarken okunan satırı vurgulayan uygulama.

- `packages/dua_core/` — ortak çekirdek: veritabanı (drift/SQLite), JSON içe aktarma, satır bölme, onay kuralları, çeviri alışverişi, ses eşleştirme, yayınlama.
- `apps/editor/` — Windows içerik editörü (Flutter).
- `apps/mobile/` — dua okuma/dinleme uygulaması: iOS, Android ve Windows.
- `content/` — editörün çalışma klasörü (`content.db`, `audio/`, `translation/`, `import/`).
- Tasarım: `docs/superpowers/specs/2026-11-14-dualarim-design.md`

## Kurulum (Windows)

1. Flutter 3.47+ (`flutter doctor`).
2. Visual Studio 2022 → **"C++ ile masaüstü geliştirme"** iş yükü (Windows uygulamasını derlemek için).
3. Windows **Geliştirici Modu** açık (`start ms-settings:developers`).
4. ffmpeg: `winget install Gyan.FFmpeg` (editör PATH'te veya WinGet klasöründe kendisi bulur; Ayarlar'dan yol da verilebilir).
5. Kökte `dart pub get`.

Testler: `cd packages/dua_core && dart test` · `cd apps/editor && flutter test`
Çalıştırma: `cd apps/editor && flutter run -d windows`

## Çalışma akışı

1. **Klasör aç:** editör ilk açılışta içerik klasörünü sorar → `content`.
2. **JSON içe aktar:** `content/import/dua_archive.json`. Dualar, 26 kategori, gruplar (40 Rabbenâ, Kunut) ve varyantlar gelir. Arapça metin Türkçe okunuştaki cümlelere göre satırlara bölünür.
3. **Çeviriye gönder** → `content/translation/pending.json`. Claude Code'a **"çevirileri yap"** deyin; Claude `done.json` yazar (kurallar: `content/translation/README.md`). **Çevirileri içe aktar.**
4. **Gözden geçir ve onayla:** duayı açın, satıra tıklayın, okunuş/anlamları düzeltip **Onayla**.
5. **Sesler:** **Sesleri eşleştir** ile mp3 klasörünü gösterin; `DUA-0030` → `dua_0030.mp3`, `VAR-0054-01` → `var_0054_01.mp3` adları kendiliğinden eşleşir. Diğer kayıtları (ör. 25 dk'lık Kunut videosu) dua veya grup ekranında **+** ile ekleyin; video ise sesi ayrılır.
6. **Zamanla:** sağ paneli tıklayıp odaklayın, sesi çalın (Boşluk), her satır başladığında **Enter**. Metinsiz bölüm **G**, seçili işareti **←/→** (±100 ms, Shift ±10), **Delete** sil, **Ctrl+Z** geri al. Hız 0.5x–1x.
7. **Yayına hazır** işaretleyin → **Mobil için yayınla** (`apps/mobile/assets/content/`). Yalnızca tüm satırları onaylı ve en az bir kaydı tam zamanlanmış dualar çıkar.

## Mobil uygulama (apps/mobile)

İçerik: `apps/mobile/assets/content/` — editörün **Mobil için yayınla** çıktısı (`content.db`, `audio/`, `manifest.json`). Yeni içerik yayınlandıktan sonra uygulama yeniden derlenir; telefondaki listeler ve ayarlar korunur.

- Testler: `cd apps/mobile && flutter test`
- Android: `flutter build apk --release` → `build/app/outputs/flutter-apk/app-release.apk`
- Windows: `flutter build windows --release` → `build/windows/x64/runner/Release/` (klasörün tamamı gerekir)

### iOS (Mac'te)

1. Gerekenler: Xcode (App Store), Xcode komut satırı araçları (`xcode-select --install`), CocoaPods (`sudo gem install cocoapods` ya da `brew install cocoapods`), Flutter 3.47+.
2. `git clone https://github.com/capacioglu/mscDua.git && cd mscDua`
3. `dart pub get` (kökte; pub workspace).
4. `cd apps/mobile && flutter precache --ios && cd ios && pod install && cd ..`
5. `open ios/Runner.xcworkspace` → Runner hedefi → **Signing & Capabilities** → Team: Apple geliştirici hesabın. Bundle Identifier: `com.dualarim.app` (başkası almışsa benzersiz bir ad ver). **Background Modes → Audio** işaretli olmalı (Info.plist'te `UIBackgroundModes: audio` hazır).
6. iPhone'u kabloyla bağla (Geliştirici Modu açık): `flutter run --release -d <iphone>` — ya da TestFlight için `flutter build ipa` → `build/ios/ipa/` dosyasını Xcode Organizer / Transporter ile yükle.

## ElevenLabs ile seslendirme

1. Editör → Ayarlar → **ElevenLabs** sekmesi: API anahtarını gir, "Bağlantıyı dene" (kalan kota görünür).
2. Her dil (Arapça / Türkçe / İngilizce) için hesaptaki bir sesi seç ya da "Ses kitaplığında ara" (ör. *Hanafi*) → "Hesabıma ekle". Deneme alanından sesi dinleyebilirsin.
3. Dua ekranında "Ses üret" düğmeleri ya da listede Ctrl/Shift ile çoklu seçim → sağ tık → "… sesi üret". Satır işaretleri kendiliğinden yerleşir; ses `content/audio/tts/<dua>_<dil>.mp3` olur.
4. Ses zorunlu değildir; sesi olmayan dua metin olarak yayınlanır. Telefonda "Okuma seçenekleri → Dinleme dili" seçilir; o dilde sesi olmayan dua Arapça sesiyle çalar.

API anahtarı yalnızca `%APPDATA%\Dualarim\settings.json` içinde durur; içerik veritabanına, yayına ya da git'e girmez.
