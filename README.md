# Dualarım

Duaları Arapça aslı, Türkçe/İngilizce okunuşu ve anlamıyla gösteren; sesi çalarken okunan satırı vurgulayan uygulama.

- `packages/dua_core/` — ortak çekirdek: veritabanı (drift/SQLite), JSON içe aktarma, satır bölme, onay kuralları, çeviri alışverişi, ses eşleştirme, yayınlama.
- `apps/editor/` — Windows içerik editörü (Flutter).
- `apps/mobile/` — iOS + Android uygulaması (ayrı planla gelecek).
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
