# Dualarım — Mobil Uygulama (iOS + Android) Uygulama Planı

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Editörün yayınladığı içeriği (65 dua, 2 grup, ses + zamanlama) gösteren ve sesli okuyan; tek dua / grup / kendi listem modları, okuma seçenekleri, dualar arası boşluk ve tekrar sayısı olan Flutter iOS + Android uygulaması.

**Architecture:** `apps/mobile` Flutter uygulaması. Saf mantık (`ContentQueries`, `UserDatabase`, `PlayQueue`, Arapça arama normalleştirme) `packages/dua_core`'a eklenir ve `dart test` ile sınanır. İçerik `apps/mobile/assets/content/` (editör çıktısı) uygulama destek klasörüne kopyalanıp salt okunur açılır; kullanıcı verisi ayrı bir drift veritabanındadır. Ses: `just_audio` + `just_audio_background` (arka plan, kilit ekranı); kuyruk `ConcatenatingAudioSource` içinde [klip, sessizlik, klip…] dizisi olarak kurulur.

**Tech Stack:** Flutter 3.47 / Dart 3.13, drift (dua_core), just_audio, just_audio_background, path_provider, flutter_launcher_icons, Amiri yazı tipi.

**Spec:** `docs/superpowers/specs/2026-11-14-dualarim-design.md` (§6.5.3, §6.7)

## Global Constraints

- JSON metinleri doğru kabul edilir; mobilde onay kavramı yoktur (spec §6.5.3).
- Arapça metin hiçbir aşamada değiştirilmez; arama için yalnızca bellekte harekesiz kopya üretilir.
- Satır anlamı yoksa duanın bütün anlamı (`srcMeaningTr/En`) satırların altında tek paragraf gösterilir.
- `standaloneVisible = false` kayıtlar (varyantlar) kategori/arama listelerinde tek başına çıkmaz; grupta ve "Diğer okunuşlar"da çıkar.
- Kullanıcı verisi içerikten ayrıdır; içerik sürümü değişince silinmez. Listeler duaya kimlikle bağlanır; olmayan kimlik atlanır.
- Dualar arası boşluk varsayılan 1000 ms; tekrar varsayılan 1 (grup üyeliğinde `repeatCount`).
- Arayüz Türkçe. Uygulama adı "Dualarım", paket `com.dualarim.app`, ikon `design/icon/icon_1024.png`.
- iOS derlemesi kullanıcının Mac'inde yapılır; burada Android (`flutter build apk`) ve testler doğrulanır.

## Review Focus

1. **Sessizlik/tekrar ile kuyruk indeksinin satır vurgusuna eşlenmesi.** Beklenen: sessizlik sırasında vurgu yok ve ekran sonraki duaya geçmez; tekrarın 2. turunda vurgu baştan başlar ve "2/3" gösterilir. → Task 4 testi.
2. **Kaydı olmayan / kısmen zamanlı dua listede.** Beklenen: yayınlanmış içerikte hepsi zamanlı; yine de kaydı yoksa sessiz atlanmaz, liste bir uyarıyla devam eder, metin okunabilir kalır. → Task 4 testi.
3. **İçerik sürümü değişince kopyalama.** Beklenen: manifest sürümü farklıysa veritabanı ve sesler yenilenir; kullanıcı listeleri korunur; aynıysa tekrar kopyalanmaz. → Task 3 testi.
4. **Arapça arama.** Beklenen: harekesiz yazılan "ربنا" harekeli metni bulur; Türkçe "rabbena" ile "Rabbenâ" eşleşir (şapka/büyük harf duyarsız). → Task 2 testi.
5. **Okuma seçeneklerinin hepsi kapalı.** Beklenen: en az biri açık kalır (son açık seçenek kapatılamaz). → Task 6 testi.

---

### Task 1: Mobil iskelet, ikon, yazı tipi

**Files:** Create `apps/mobile/` (`flutter create --platforms=android,ios --org com.dualarim --project-name dualarim_mobile mobile`), Modify kök `pubspec.yaml` (workspace'e `apps/mobile`), `apps/mobile/pubspec.yaml` (`resolution: workspace`; deps: `dua_core`, `drift`, `just_audio`, `just_audio_background`, `path_provider`, `path`; dev: `flutter_launcher_icons`; assets: `assets/content/`, `assets/content/audio/`; fonts: Amiri — editördeki dosyalar kopyalanır), `android/app/src/main/AndroidManifest.xml` (INTERNET, WAKE_LOCK, FOREGROUND_SERVICE, FOREGROUND_SERVICE_MEDIA_PLAYBACK; just_audio_background servis ve receiver bildirimleri; `android:label="Dualarım"`), `MainActivity.kt` (`AudioServiceActivity`), `ios/Runner/Info.plist` (`UIBackgroundModes: audio`, `CFBundleDisplayName: Dualarım`).

- [ ] **Step 1:** İskeleti oluştur, workspace'e ekle, `dart pub get`.
- [ ] **Step 2:** `flutter_launcher_icons` yapılandır (`image_path: ../../design/icon/icon_1024.png`, android + ios, `remove_alpha_ios: true`), `dart run flutter_launcher_icons`.
- [ ] **Step 3:** Doğrula: `flutter build apk --debug` → başarılı. Commit `chore(mobile): iskelet, ikon, yazı tipi`.

---

### Task 2: İçerik sorguları ve arama (dua_core)

**Files:** Create `packages/dua_core/lib/src/content/content_queries.dart`, `lib/src/text/search_normalize.dart`; Test `test/content/content_queries_test.dart`

**Interfaces:**
- `String normalizeArabic(String s)` — hareke (U+064B–U+065F, U+0670, U+06D6–U+06ED), tatvil kaldırılır; `أإآ→ا`, `ى→ي`, `ة→ه`.
- `String normalizeLatin(String s)` — küçük harf (Türkçe İ/I), `âîû→aiu`, `ş→s ğ→g ü→u ö→o ç→c ı→i`, kesme işaretleri/tire kaldırılır.
- `class DuaView { Dua dua; List<Segment> segments; List<Track> tracks; Map<int, List<Cue>> cuesByTrack; List<Dua> variants; List<String> categories; }`
- `class GroupEntry { GroupItem item; Dua dua; }`
- `class ContentQueries(ContentDatabase db)`: `Future<List<DuaGroup>> groups()`, `Future<List<GroupEntry>> groupEntries(String groupId)` (position sırası), `Future<List<Category>> categories()` (sortOrder), `Future<List<Dua>> duasInCategory(int categoryId)` (yalnız standaloneVisible, id sırası), `Future<List<Dua>> allStandalone()`, `Future<DuaView> duaView(String id)`, `Future<List<Dua>> search(String q)` (q Arapça harf içeriyorsa segment metninde `normalizeArabic` ile; değilse başlık/okunuş/anlam `normalizeLatin` ile; boş sorgu → boş).

- [ ] **Step 1: Failing tests** (mini fixture'ı içe aktar + DUA-0006'ya bir kayıt ve 4 cue ekle): `groups()` → `['GRP-001','GRP-005']`; `groupEntries('GRP-005')` sırası `DUA-0054`'ün yerine `VAR-0054-01` içerir; `duasInCategory(Mağfiret)` `VAR-0054-01`'i içermez; `duaView('DUA-0006')` 4 satır, 1 kayıt, 4 cue; `duaView('DUA-0054').variants` → `[VAR-0054-01]`; `search('ربنا')` `DUA-0030`'u bulur; `search('rabbena')` ve `search('RABBENÂ')` `DUA-0013`'ü bulur; `search('')` boş.
- [ ] **Step 2:** Çalıştır → FAIL. **Step 3:** Uygula, `dua_core.dart`'tan dışa aç. **Step 4:** PASS. **Step 5:** Commit `feat(core): mobil içerik sorguları ve arama`.

---

### Task 3: Kullanıcı verisi ve içerik kurulumu

**Files:** Create `packages/dua_core/lib/src/user/user_database.dart` (+ `.g.dart`), `apps/mobile/lib/data/content_installer.dart`; Test `packages/dua_core/test/user/user_database_test.dart`, `apps/mobile/test/content_installer_test.dart`

**Interfaces:**
- drift `UserDatabase` tabloları: `Playlists(id auto, name, createdAt, sortOrder)`, `PlaylistItems(id auto, playlistId → cascade, duaId TEXT, position INT, repeatCount INT default 1)`, `Settings(key TEXT PK, value TEXT)`.
- `UserDatabase`: `static open(File)`, `memory()`; `Future<int> createPlaylist(String name)`, `addItems(int playlistId, List<String> duaIds)` (sona ekler), `setRepeat(int itemId, int n)` (1–99), `move(int itemId, int newPos)`, `removeItem(int itemId)`, `renamePlaylist`, `deletePlaylist`, `Future<List<PlaylistItem>> items(int playlistId)`; ayarlar: `Future<ReadingPrefs> readingPrefs()` / `saveReadingPrefs(ReadingPrefs)`, `gapMs()` / `setGapMs(int)` (0–10000), `fontScale()` / `setFontScale(double)`.
- `class ReadingPrefs { bool arabic, pronunciationTr, pronunciationEn, meaningTr, meaningEn; }` varsayılan: arabic, pronunciationTr, meaningTr açık.
- `class ContentInstaller(Directory supportDir, AssetLoader loader)`: `Future<File> ensureInstalled()` — `manifest.json`'daki `content_version` kurulu sürümden farklıysa `content.db` ve `audio/` dosyalarını asset'ten kopyalar, sürümü `installed_version` dosyasına yazar; aynıysa dokunmaz. `AssetLoader` = `Future<ByteData> Function(String key)` + `List<String> audioKeys` (AssetManifest'ten).

- [ ] **Step 1: Failing tests:** liste oluştur, 3 dua ekle, ortadakinin tekrarını 3 yap, sonuncuyu başa taşı → sıra ve tekrar doğru; `setRepeat(0)` → `ArgumentError`; ayarlar varsayılanları ve kalıcılık; installer: ilk çağrı kopyalar, aynı sürümde ikinci çağrı dosyaya dokunmaz (mtime), sürüm 4'e çıkınca yeniden kopyalar ve `UserDatabase` dosyası yerinde kalır.
- [ ] **Step 2:** FAIL. **Step 3:** Uygula. **Step 4:** PASS. **Step 5:** Commit `feat: kullanıcı verisi ve içerik kurulumu`.

---

### Task 4: Çalma kuyruğu (saf mantık)

**Files:** Create `packages/dua_core/lib/src/play/play_queue.dart`; Test `test/play/play_queue_test.dart`

**Interfaces:**
- `class PlayRequest { String duaId; int repeat; }`
- `sealed class QueueEntry` → `ClipEntry { String duaId; Track track; int turn; int turns; List<Cue> cues; List<int> segmentIds; }` | `GapEntry { int ms; }` | `TextOnlyEntry { String duaId; }` (kaydı yok)
- `List<QueueEntry> buildQueue(List<PlayRequest> requests, Map<String, DuaView> views, {required int gapMs})` — her istek için `repeat` kadar `ClipEntry` (turn 1..n); girişler arasına `gapMs > 0` ise `GapEntry`; sona boşluk eklenmez. Kayıt seçimi: duanın kendi kaydı (ilk); yoksa `TextOnlyEntry`. Grup kayıtları (uzun tek kayıt) bu sürümde çalınmaz — yayınlanan içerikte yok (YAGNI; gelirse ayrı görev).
- `class NowPlaying { String? duaId; int? segmentId; int turn; int turns; bool inGap; }`
- `NowPlaying nowPlaying(List<QueueEntry> q, int index, int positionMs)` — `ClipEntry` ise `CueTimeline(segmentIds, cues).activeAt(positionMs)`; `GapEntry` ise önceki klibin `duaId`'si, `segmentId: null`, `inGap: true`.

- [ ] **Step 1: Failing tests:** 2 istek (A×1, B×3), gap 1000 → `[Clip A 1/1, Gap, Clip B 1/3, Gap, Clip B 2/3, Gap, Clip B 3/3]`; gap 0 → boşluk yok; kaydı olmayan C → `TextOnlyEntry`; `nowPlaying` B'nin 2. turunda 1500 ms → doğru satır, `turn 2, turns 3`; gap indeksinde `inGap` ve `segmentId == null`; metinsiz bölüm cue'sunda `segmentId == null`.
- [ ] **Step 2:** FAIL. **Step 3:** Uygula. **Step 4:** PASS. **Step 5:** Commit `feat(core): çalma kuyruğu`.

---

### Task 5: Oynatıcı servisi (just_audio)

**Files:** Create `apps/mobile/lib/audio/player_service.dart`; Test `apps/mobile/test/player_service_test.dart`

**Interfaces:**
- `abstract class AudioBackend { Future<void> setQueue(List<QueueEntry> q, File Function(Track) fileOf, MediaInfo Function(String duaId) info); Future<void> play(); pause(); seekTo(int index, int ms); Stream<(int index, int ms)> get progress; Stream<bool> get playingStream; Future<void> dispose(); }`
- `JustAudioBackend implements AudioBackend` — `ConcatenatingAudioSource([AudioSource.file(..., tag: MediaItem(...)), SilenceAudioSource(duration: gap), ...])`; `TextOnlyEntry` → 2 sn sessizlik (ekranda metin kalır).
- `class PlayerService extends ChangeNotifier(AudioBackend backend)`: `Future<void> start(List<PlayRequest>, {required int gapMs, String? title})`, `play()`, `pause()`, `seekToSegment(String duaId, int segmentId)`, `NowPlaying get now`, `bool get playing`, `List<QueueEntry> get queue`.
- `main.dart`'ta `JustAudioBackground.init(androidNotificationChannelId: 'com.dualarim.app.audio', androidNotificationChannelName: 'Dua çalma')`.

- [ ] **Step 1: Failing test (sahte backend):** `start([A×2], gap 500)` → backend'e 3 girişli kuyruk gider; sahte ilerleme `(2, 1200)` → `now.turn == 2`; `seekToSegment(A, seg2)` → backend `seekTo(0, seg2'nin ilk cue ms)`.
- [ ] **Step 2:** FAIL. **Step 3:** Uygula. **Step 4:** PASS. **Step 5:** Commit `feat(mobile): oynatıcı servisi`.

---

### Task 6: Okuma ekranı (tek dua) ve okuma seçenekleri

**Files:** Create `apps/mobile/lib/app_scope.dart` (ContentQueries, UserDatabase, PlayerService'i taşıyan InheritedWidget), `lib/screens/dua_screen.dart`, `lib/widgets/reading_view.dart`, `lib/widgets/reading_prefs_sheet.dart`, `lib/widgets/mini_player.dart`; Test `apps/mobile/test/dua_screen_test.dart`

Davranış (spec §6.7):
- `ReadingView(views, now, prefs, fontScale, onTapSegment)` — her dua: başlık, satırlar (Arapça / okunuş TR / okunuş EN — prefs'e göre); satırın kendi anlamı varsa satır altında, yoksa satırların altında duanın bütün anlamı (TR/EN, prefs'e göre); aktif satır vurgulanır ve `Scrollable.ensureVisible` ile ortalanır; satıra dokununca `onTapSegment`.
- Dua ekranı: üstte başlık, kaynak (Kur'an/hadis referansı), okuma sayısı/zamanı; alt kısımda hadis/kıssa (katlanır); "Diğer okunuşlar" (varyant varsa); tekrar seçici (1–33, varsayılan 1) ve ▶ düğmesi (`PlayerService.start([this×n])`); önceki/sonraki dua.
- Okuma seçenekleri sayfası: 5 anahtar + yazı boyutu kaydırıcı + boşluk (0–5 sn); son açık anahtar kapatılamaz.
- Mini oynatıcı: tüm ekranların altında; çalan dua, tur "2/3", oynat/duraklat.

- [ ] **Step 1: Failing widget tests (sahte backend, bellek DB):** DUA-0006 açılır, 4 Arapça satır ve okunuşlar görünür, bütün Türkçe anlam satırların altında bir kez; "Türkçe okunuş" kapatılınca okunuş metinleri kaybolur; tüm anahtarlar kapatılmaya çalışılınca son açık olan açık kalır; tekrar 3 + ▶ → backend kuyruğunda 3 klip; sahte ilerleme 2. satırın cue'suna gelince o satır vurgulu (`Key('seg-active')`).
- [ ] **Step 2:** FAIL. **Step 3:** Uygula. **Step 4:** PASS. **Step 5:** Commit `feat(mobile): dua ekranı ve okuma seçenekleri`.

---

### Task 7: Ana ekran, gruplar, kategoriler, arama

**Files:** Create `apps/mobile/lib/screens/home_screen.dart` (alt sekmeler: Gruplar · Kategoriler · Listelerim · Ara), `lib/screens/group_screen.dart`, `lib/screens/category_screen.dart`, `lib/screens/search_screen.dart`, `lib/main.dart`; Test `apps/mobile/test/home_flow_test.dart`

Davranış: Gruplar sekmesi iki grubu kartla gösterir; grup ekranı üyeleri sırasıyla `ReadingView` içinde art arda gösterir ve "Tümünü çal" (`repeatCount`'larla) sunar; dua başlığına dokununca tek dua ekranı. Kategoriler sekmesi 26 kategoriyi, kategori ekranı dualarını listeler. Ara sekmesi `ContentQueries.search`. Her listede uzun basma → "Listeye ekle".

- [ ] **Step 1: Failing widget tests:** Gruplar sekmesinde "40 Rabbenâ Duası"; Kunut grubunda ikinci dua `VAR-0054-01` başlığı; "Tümünü çal" → backend kuyruğunda grup sırası; kategori "Tövbe" → DUA-0030 listede; arama "rabbena" sonuç verir.
- [ ] **Step 2:** FAIL. **Step 3:** Uygula. **Step 4:** PASS. **Step 5:** Commit `feat(mobile): ana ekran, gruplar, kategoriler, arama`.

---

### Task 8: Kendi listem (çalma listeleri)

**Files:** Create `apps/mobile/lib/screens/playlists_screen.dart`, `lib/screens/playlist_screen.dart`, `lib/screens/pick_duas_screen.dart`; Test `apps/mobile/test/playlist_flow_test.dart`

Davranış: "Yeni liste" (ad) → çoklu seçimle dua ekle (arama + kategori filtresi, onay kutuları) → liste ekranı: sürükle-bırak sıralama, her satırda tekrar sayısı (− / +), kaydırarak sil; üstte "Oku" (yalnız metin, `ReadingView` ile art arda) ve "Dinle" (boşluk ayarıyla `PlayerService.start`); boşluk ayarı liste ekranında da değiştirilebilir. İçerikte olmayan kimlik "Bu dua artık yok" satırıyla gösterilir ve çalmada atlanır.

- [ ] **Step 1: Failing widget tests:** liste oluştur, DUA-0013 ve DUA-0030 seç, ikincinin tekrarını 2 yap, "Dinle" → kuyruk `[13, gap, 30 1/2, gap, 30 2/2]`; boşluk 0 yapılınca kuyrukta boşluk yok; uygulama yeniden kurulup (yeni `UserDatabase` aynı dosya) liste duruyor.
- [ ] **Step 2:** FAIL. **Step 3:** Uygula. **Step 4:** PASS. **Step 5:** Commit `feat(mobile): kendi listem`.

---

### Task 9: Cihazda doğrulama ve README

- [ ] **Step 1:** `flutter test` (mobile) ve `dart test` (core) → hepsi PASS; `flutter analyze` → temiz.
- [ ] **Step 2:** `flutter build apk --release` → başarılı; APK boyutu README'ye not edilir.
- [ ] **Step 3:** Android emülatör/cihazda elle: DUA-0006 dinle (vurgu satırı takip eder), Kunut grubunu çal (aralarda 1 sn), ekran kilitliyken çalma sürer, bildirimden duraklat.
- [ ] **Step 4:** README'ye mobil bölümü: çalıştırma, iOS için Mac'te `cd apps/mobile && flutter build ios` ve imzalama notu. Commit `docs: mobil README`.
