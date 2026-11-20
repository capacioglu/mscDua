# ElevenLabs Seslendirme ve Çok Dilli Ses — Uygulama Planı

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Editörden ElevenLabs ile Arapça/Türkçe/İngilizce dua sesi üretmek (otomatik satır zamanlamalı), sesi isteğe bağlı yapmak, yalnızca Türkçe dua desteklemek ve telefonda dinleme dili seçimi.

**Architecture:** Saf mantık (`tts_text.dart` metin/ofset/hash/hizalama→cue, `ElevenLabsClient`, `TtsGenerator`) `dua_core`'da, `dart test` ile (HTTP `package:http/testing` MockClient ile). Editör: ayarlar sekmesi, üretim düğmeleri, liste çoklu seçim + sağ tık. Mobil: dinleme dili tercihi, `buildQueue` kayıt seçimi.

**Tech Stack:** Dart/Flutter 3.47, drift (şema v2), `package:http`, ffmpeg (uzun metin birleştirme), ElevenLabs REST v1.

**Spec:** `docs/superpowers/specs/2026-11-20-elevenlabs-design.md`

## Global Constraints

- API anahtarı yalnızca `%APPDATA%\Dualarim\settings.json`'da; içerik DB'sine, yayına, git'e, hata metnine girmez (hata metninde yalnız son 4 hane).
- Elle eklenmiş (`source='manual'`) kayıt kendiliğinden silinmez; ElevenLabs kaydı aynı dua+dilde yeniden üretilince yerine geçer (onayla).
- Başarısız üretim hiçbir dosya/kayıt/cue bırakmaz (geçici dosya + tek transaction).
- Arapça satır metni değiştirilmez.
- Diller: `ar` | `tr` | `en`. Model varsayılan `eleven_multilingual_v2`, çıktı `mp3_44100_128`. Parça sınırı 4.500 karakter.
- Yayın: satırı olan her dua yayınlanır; kayıt yalnızca tam zamanlı + dosyası varsa.
- Mobil kayıt seçimi: seçilen dil (birincil) → duanın `textLanguage`'ı → `ar` → metin.

## Review Focus

1. **Hizalama metinle uyuşmazsa** (ElevenLabs karakterleri normalleştirir). Beklenen: satır başları normalleştirilmiş aramayla bulunur; bulunamazsa hata, kayıt yazılmaz. → Task 3 testi.
2. **Uzun metin (>4.500)**. Beklenen: satır sınırından parçalanır, cue'lar parça ofsetleriyle kayar, tek dosya. → Task 5 testi.
3. **Geçersiz anahtar / kota bitti (401/402-429)**. Beklenen: anlaşılır Türkçe hata, anahtar maskeli, yarım kayıt yok. → Task 4 ve 5 testleri.
4. **Eski (v1) content.db açılınca**. Beklenen: sütunlar eklenir, kayıtlar `ar/manual/birincil`, veri kaybı yok. → Task 1 testi.
5. **Yalnızca Türkçe dua Arapça dinleme dilinde**. Beklenen: Türkçe kaydı çalar. → Task 7 testi.

---

### Task 0: Eksik satır anlamları (içerik)

- [ ] `tool/translation_io.dart export` ile çevirisi eksik satırları çıkar (editör kapalı, DB yedekli); duaları gruplara böl; paralel alt ajanlarla 2026-11-14'teki kurallarla satır anlamı (TR+EN) üret; kapsamı doğrula (her segment bir kez, boş yok); birkaç dua oku; `apply`. Beklenen: `meaning_tr` boş satır kalmaz.

### Task 1: Şema v2

**Files:** Modify `packages/dua_core/lib/src/db/tables.dart`, `database.dart`; Test `test/db/schema_v2_test.dart`

**Interfaces — Produces:** Tracks: `language` (text, default `'ar'`), `source` (text, default `'manual'`), `voiceId?`, `voiceName?`, `isPrimary` (bool, default true), `textHash?`. Duas: `textLanguage` (text, default `'ar'`). `schemaVersion = 2`, `onUpgrade(from<2)`: `addColumn` hepsi.

- [ ] Test: v1 şemalı dosya DB (raw sqlite3 ile tracks/duas v1 sütunları + 1 kayıt, `user_version=1`) → `ContentDatabase.open` → kayıt `language=='ar'`, `source=='manual'`, `isPrimary`, dua `textLanguage=='ar'`. Yeni DB'de de varsayılanlar. → FAIL → uygula → PASS → commit.

### Task 2: Yayın kuralı ve dil bazlı durum

**Files:** Modify `lib/src/rules/approval.dart` (`checkPublishable`), `lib/src/publish/publisher.dart`, `lib/src/repo/summary.dart`; Tests ilgili dosyalar.

**Interfaces — Produces:** `checkPublishable` nedenleri yalnız `'Satır yok'`; `fullyTimedTracks` değişmez. `DuaSummary.timingByLang: Map<String, TimingProgress>` (ar/tr/en) ve `staleTts: bool` (ElevenLabs kaydının `textHash` ≠ şimdiki metnin hash'i). Publisher: sesi olmayan dua yayınlanır; kayıt seçimi mevcut (tam zamanlı + dosya var).

- [ ] Testler: sesi olmayan dua yayınlanır ve kaydı yoktur; zamanlanmamış kayıt atlanır ama dua yayınlanır; `timingByLang` TR kaydı tam zamanlıysa `{'ar': noAudio, 'tr': ready, 'en': noAudio}`; metin değişince `staleTts == true`. Eski publisher/approval testleri yeni kurala göre güncellenir (ses zorunluluğu kalktı). → FAIL → uygula → PASS → commit.

### Task 3: TTS metni, hash, hizalama → cue

**Files:** Create `lib/src/tts/tts_text.dart`; Test `test/tts/tts_text_test.dart`

**Interfaces — Produces:**
- `class TtsText { String text; List<int> lineStarts; List<int> segmentIds; }`
- `TtsText? buildTtsText(List<Segment> segs, String lang)` — `ar`→`textAr`, `tr`→`meaningTr`, `en`→`meaningEn`; satırlar `\n` ile; herhangi biri boşsa `null`.
- `String ttsHash(TtsText t)` — SHA-1 hex (`package:crypto`).
- `List<TtsText> chunkTts(TtsText t, {int maxChars = 4500})` — satır sınırından.
- `class Alignment { List<String> chars; List<double> startsSec; }`
- `List<int> lineCueMs(TtsText t, Alignment a)` — her satırın ilk boşluk-olmayan karakterinin başlangıcı (ms); karakterler birebir değilse NFC + boşluk normalleştirmesiyle ofset arar; bulunamazsa `FormatException('Hizalama metinle eşleşmedi')`.

- [ ] Testler: 3 satır AR → text `'a\nb\nc'`, lineStarts `[0,2,4]`; boş meaningTr → `null`; hash kararlı ve metin değişince farklı; birebir hizalamada cue'lar `[0, t(b), t(c)]` ms; hizalamada fazladan boşluk/eksik `\n` olsa da doğru; tamamen alakasız hizalama → FormatException; 10.000 karakterlik 20 satır → parçalar ≤4500, satır bütün. → FAIL → uygula → PASS → commit.

### Task 4: ElevenLabs istemcisi

**Files:** Create `lib/src/tts/elevenlabs_client.dart`; Test `test/tts/elevenlabs_client_test.dart`. Dep: `http`, `crypto` (dua_core).

**Interfaces — Produces:** `class ElevenLabsClient(String apiKey, {http.Client? client, String base = 'https://api.elevenlabs.io'})`: `Future<Quota> quota()` (`character_count`, `character_limit`); `Future<List<Voice>> voices()`; `Future<List<SharedVoice>> searchLibrary(String q)`; `Future<void> addSharedVoice(SharedVoice v)`; `Future<List<int>> speak(String voiceId, String text, {String modelId})`; `Future<(List<int> mp3, Alignment)> speakWithTimestamps(String voiceId, String text, {String modelId})`. Hata: `ElevenLabsException(message)` Türkçe — 401 "API anahtarı geçersiz (…abcd)", 402/429 kota/limit, diğerleri durum kodu + gövde özeti. Başlık `xi-api-key`.

- [ ] Testler (MockClient): doğru URL/başlık/gövde; `with-timestamps` yanıtından base64 çözülür ve hizalama döner; 401 → mesaj anahtarın yalnız son 4 hanesini içerir; voices/shared-voices JSON çözümü; 429 bir kez beklenip tekrar denenir. → FAIL → uygula → PASS → commit.

### Task 5: Üretici (dosya + kayıt + cue)

**Files:** Create `lib/src/tts/tts_generator.dart`; Test `test/tts/tts_generator_test.dart`

**Interfaces — Consumes:** Task 1–4. **Produces:** `class TtsGenerator(ContentDatabase db, Directory contentDir, ElevenLabsClient client, {FfmpegService? ffmpeg})`: `Future<TtsResult> generate(String duaId, String lang, {required String voiceId, required String voiceName, String modelId = 'eleven_multilingual_v2'})` → dosya `content/audio/tts/<duaId>_<lang>.mp3` (geçici dosya → rename), Track (`language`, `source='elevenlabs'`, `voiceId`, `voiceName`, `label='ElevenLabs – <voiceName>'`, `textHash`, `isPrimary=true`, aynı dua+dildeki diğerleri `isPrimary=false`), cue'lar; aynı dua+dildeki eski ElevenLabs kaydı ve dosyası silinir; manual kalır. `int estimateChars(String duaId, String lang)`; `bool canGenerate(String duaId, String lang)` (Türkçe duada `ar` hayır; metin eksikse hayır). `Future<void> setPrimary(int trackId)`.

- [ ] Testler (sahte istemci): üretim sonrası kayıt+4 cue+dosya; ikinci üretim eski ElevenLabs kaydını değiştirir, manual kalır ve birincilliği düşer; istemci hata atarsa dosya/kayıt yok; >4500 metinde 2 istek, ffmpeg birleştirme (ffmpeg yoksa test atlanır), ikinci parçanın cue'ları ilk parçanın süresi kadar kayar; `setPrimary`. → FAIL → uygula → PASS → commit.

### Task 6: Editör arayüzü

**Files:** Modify `apps/editor/lib/services/settings.dart` (`elevenLabs` bloğu), `main.dart` (ayarlar → sekmeli diyalog), `lib/screens/dua_list_screen.dart` (çoklu seçim, sağ tık, dil durum sütunu, toplu üretim diyaloğu), `lib/screens/dua_edit_screen.dart` (Ses üret düğmeleri, kayıt listesinde "Telefonda bu çalsın", eskime uyarısı, Türkçe dua görünümü), `lib/app/actions.dart` (`generateTtsAction`); Create `lib/widgets/elevenlabs_settings.dart`; Tests `test/elevenlabs_settings_test.dart`, `test/tts_actions_test.dart`.

Davranış (spec §6.2–6.4): Ayarlar sekmesi: anahtar (gizli), "Bağlantıyı dene" (kota gösterir), dil başına ses açılır listesi (hesap sesleri) + "Kitaplıkta ara" (sonuç → "Hesabıma ekle") + elle voice ID; deneme metni + "Seslendir" (editörde çalar). Yeni dua diyaloğunda "Yalnızca Türkçe"; Türkçe duada yapıştırma Türkçe cümlelerden böler (`meaningTr`, `textAr=''`). Toplu üretim: özet (dua, karakter, kalan kota) → onay → ilerleme + iptal → rapor.

- [ ] Widget testleri (sahte istemci enjekte): anahtar girilip "Bağlantıyı dene" → kota metni; listede 2 dua seçili + sağ tık "Türkçe sesi üret" → özet diyaloğu karakter sayısını gösterir → onay → 2 kayıt oluşur; Türkçe dua oluşturulunca Arapça alanı yok ve "Arapça sesi üret" pasif. → FAIL → uygula → PASS → commit; `flutter build windows --release`.

### Task 7: Mobil

**Files:** Modify `packages/dua_core/lib/src/play/play_queue.dart` (kayıt seçimi), `lib/src/user/user_database.dart` (`listenLanguage`), `apps/mobile/lib/app_scope.dart`, `widgets/reading_prefs_sheet.dart`, `widgets/reading_view.dart` (Türkçe dua), `audio/player_service.dart` (başlıkta dil), `pubspec.yaml` (`assets/content/audio/tts/`); Tests core `play_queue_test`, mobile `dua_screen_test`.

**Interfaces:** `buildQueue(requests, views, {gapMs, String lang = 'ar'})` — seçim sırası Global Constraints'teki gibi; `PlayerService.start/playFrom` `lang` alır (AppServices.listenLanguage'dan).

- [ ] Testler: TR seçiliyken TR kaydı olan dua TR kaydını, olmayan AR kaydını çalar; Türkçe dua AR dilinde TR kaydını çalar; birincil olmayan kayıt seçilmez; dinleme dili tercih sayfasında değişir ve kalıcı; Türkçe dua ekranda Türkçe ana metinle görünür. → FAIL → uygula → PASS → commit; APK + Windows derle.

### Task 8: Doğrulama

- [ ] `dart test` (core), `flutter test` (editor, mobile), `flutter analyze` hepsi temiz; gerçek anahtarla kullanıcı denemesi (editörde bir duanın AR/TR sesi) — kullanıcıya bırakılır; README'ye ElevenLabs bölümü; commit.
