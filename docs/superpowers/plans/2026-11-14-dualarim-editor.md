# Dualarım — Çekirdek + Windows Editörü Uygulama Planı

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ortak `dua_core` paketi (veritabanı, içe aktarma, çeviri alışverişi, yayınlama) ve bu paketi kullanan, sesi dinleyerek satır zamanlaması yapılan Flutter Windows editörü.

**Architecture:** Dart pub workspace monoreposu. `packages/dua_core` saf Dart + drift (SQLite); tüm iş kuralları burada ve `dart test` ile test edilir. `apps/editor` Flutter Windows uygulaması; yalnızca arayüz, medya (media_kit) ve ffmpeg çağrıları içerir. Mobil uygulama bu planın dışında (ayrı plan).

**Tech Stack:** Flutter 3.47.9 / Dart 3.13.7, drift + sqlite3 (native), media_kit (Windows ses/video, hız ayarı perde korumalı), ffmpeg CLI (video→ses, dalga formu), Amiri yazı tipi (OFL).

**Spec:** `docs/superpowers/specs/2026-11-14-dualarim-design.md`

## Global Constraints

- Arapça metin hiçbir aşamada değiştirilmez/normalize edilmez (hareke, `ىٰ`, `ـ`, ZWNJ dahil); yalnızca baş/son boşluk kırpılır.
- Onaysız satır yayına giremez. Yayınlanabilirlik (spec §6.5.2): yayına hazır + ≥1 satır + tüm satırlar onaylı + en az bir kayıtta tüm satırlar zamanlanmış.
- Onay satır bazında; onay için `pronunciationTr`, `meaningTr`, `meaningEn` dolu olmalı (`pronunciationEn` isteğe bağlı).
- Onayı bozan: Arapça değişimi → `review`; bölme/birleştirme → çeviriler boşalır, `none`. Sıra değişimi ve çeviri düzeltmesi onayı bozmaz.
- Dua id'leri JSON'daki kodlardır ve değişmez. Varyant id'si: `<ana id>~<variant_key>`. Kimliksiz grup id'si: `GRP-TMP-<slug(title_tr)>`.
- Dosya yolları veritabanında `content/` köküne göre **göreli** ve `/` ayraçlı saklanır.
- Arayüz dili Türkçe.
- Çalışma klasörü: `content/` (`content.db`, `audio/`, `translation/`, `import/`).
- Yayın çıktısı: `apps/mobile/assets/content/` (`content.db`, `audio/`, `manifest.json`).

## Review Focus

1. **Arapça metnin bayt bayt korunması** (içe aktarma → DB → bölme/birleştirme → yayın). Beklenen: harekeler ve özel işaretler aynen kalır. → Task 3 ve Task 8 testleri.
2. **JSON'un düzeltmelerden sonra yeniden içe aktarılması.** Beklenen: onaylı/kullanıcı düzeltmeli alanlar ezilmez, fark "JSON'da değişiklik var" olarak raporlanır. → Task 5 testi.
3. **Zamanlanmış satırların bölünmesi/birleştirilmesi.** Beklenen: birleştirmede silinen satırın cue'ları birleşen satıra geçer; bölmede cue ilk parçada kalır, ikinci parça zamansızdır → kayıt "tam zamanlı" değil. → Task 4 testi.
4. **Türkçe karakter/boşluk içeren dosya yolları** (`Kunut Duası 2024.mp4`). Beklenen: ffmpeg ve kopyalama sorunsuz, DB'de göreli yol. → Task 7 testi.
5. **Grubun bir kısmı yayınlanabilir değilse.** Beklenen: grup, yayınlanabilir üyeleriyle sırası korunarak yayınlanır; yayın raporu eksikleri listeler; hiç üyesi yoksa grup yayınlanmaz. → Task 8 testi.

---

## Dosya yapısı

```
pubspec.yaml                          workspace kökü
packages/dua_core/
  lib/dua_core.dart                   dışa açılan API
  lib/src/db/tables.dart              drift tabloları
  lib/src/db/database.dart            ContentDatabase + açma yardımcıları
  lib/src/model/enums.dart            ReviewStatus, FieldSource, DuaProgress, TrackOwner
  lib/src/text/arabic_segmenter.dart  splitArabic
  lib/src/rules/approval.dart         canApprove, computeProgress, checkPublishable
  lib/src/repo/segment_repo.dart      satır düzenleme işlemleri (onay kurallarıyla)
  lib/src/import/archive_importer.dart  dua-arsivi.json içe aktarma
  lib/src/translation/exchange.dart   pending.json / done.json
  lib/src/audio/audio_matcher.dart    mp3 klasörü ↔ expectedAudioFile
  lib/src/audio/peaks.dart            PCM → dalga formu tepe değerleri
  lib/src/sync/cue_timeline.dart      cue mantığı (işaretle, boşluk, kaydır, aktif cue)
  lib/src/publish/publisher.dart      mobil için yayın
  test/...                            her src dosyasına karşılık test
  test/fixtures/dua-arsivi.mini.json  test için küçültülmüş arşiv
apps/editor/
  lib/main.dart
  lib/app/app_state.dart              açık content klasörü, DB, ayarlar
  lib/services/ffmpeg_service.dart
  lib/services/settings.dart
  lib/screens/dua_list_screen.dart
  lib/screens/dua_edit_screen.dart
  lib/screens/group_screen.dart
  lib/widgets/player_bar.dart
  lib/widgets/waveform_view.dart
  lib/widgets/segment_panel.dart
  lib/widgets/review_fields.dart
  lib/widgets/category_chips.dart
  assets/fonts/Amiri-Regular.ttf, Amiri-Bold.ttf, OFL.txt
content/
  translation/README.md               Claude için çeviri kuralları
```

---

### Task 1: Monorepo iskeleti

**Files:**
- Create: `pubspec.yaml` (workspace: `packages/dua_core`, `apps/editor`), `.gitignore`, `packages/dua_core/pubspec.yaml`, `packages/dua_core/lib/dua_core.dart`, `packages/dua_core/test/smoke_test.dart`
- Create: `apps/editor/` (`flutter create --platforms=windows --org com.dualarim editor` ile, `resolution: workspace`)
- Create: `content/.gitkeep`, `content/import/.gitkeep`

**Interfaces:**
- Produces: `package:dua_core/dua_core.dart` export dosyası; editör bunu path/workspace bağımlılığıyla kullanır.

- [ ] **Step 1:** `git init`; mevcut `docs/` klasörünü ilk commit'e ekle.
- [ ] **Step 2:** Workspace kök `pubspec.yaml` (`environment: sdk: ^3.13.0`, `workspace: [packages/dua_core, apps/editor]`), `.gitignore` (Flutter standart + `build/`, `.dart_tool/`; `content/` **ignore edilmez**).
- [ ] **Step 3:** `dua_core` paketi: bağımlılıklar `drift`, `sqlite3`, `path`, `collection`; dev: `drift_dev`, `build_runner`, `test`. `smoke_test.dart`: `expect(1+1, 2)`.
- [ ] **Step 4:** `apps/editor` oluştur; `dua_core`, `media_kit`, `media_kit_libs_windows_audio`, `media_kit_libs_windows_video`, `file_picker`, `path_provider` ekle.
- [ ] **Step 5:** Doğrula: `dart pub get` (kökte) → başarılı; `cd packages/dua_core && dart test` → PASS; `cd apps/editor && flutter build windows --debug` → başarılı.
- [ ] **Step 6:** Commit `chore: monorepo iskeleti (dua_core + editor)`.

---

### Task 2: Veritabanı şeması (drift)

**Files:**
- Create: `packages/dua_core/lib/src/model/enums.dart`, `lib/src/db/tables.dart`, `lib/src/db/database.dart`
- Test: `packages/dua_core/test/db/schema_test.dart`

**Interfaces:**
- Produces:
  - `enum ReviewStatus { none, review, approved }`
  - `enum FieldSource { imported, claude, user }`
  - `enum TrackOwnerKind { dua, group }`
  - `class ContentDatabase extends _$ContentDatabase` — `ContentDatabase(QueryExecutor e)`, `static ContentDatabase open(File file)`, `static ContentDatabase memory()`; `schemaVersion = 1`; foreign keys açık (`PRAGMA foreign_keys = ON`).
  - Tablolar (drift sınıf adı → kolonlar):
    - `Duas`: `id TEXT PK`, `titleTr`, `titleEn?`, `titleAr?`, `variantOf TEXT? → Duas.id`, `variantKey?`, `quranReference?`, `editorialStatus?`, `editorialNote?`, `sourceJson?`, `srcPronunciationTr?`, `srcPronunciationEn?`, `srcMeaningTr?`, `srcMeaningEn?` (JSON'daki dua bazlı metinler), `expectedAudioFile?`, `readyToPublish BOOL default false`, `version INT default 0`, `importDiff TEXT?` (yeniden içe aktarımda saptanan fark, JSON), `sortOrder INT default 0`.
    - `Categories`: `id INT PK auto`, `nameTr UNIQUE`, `nameEn?`, `sortOrder`.
    - `DuaCategories`: (`duaId`, `categoryId`) PK; cascade delete.
    - `Groups`: `id TEXT PK`, `titleTr`, `titleEn?`, `titleAr?`, `description?`, `editorialStatus?`, `infoJson?` (sources/transcript_issues/coverage/editorial_notes), `sortOrder`.
    - `GroupCategories`: (`groupId`, `categoryId`) PK.
    - `GroupItems`: `id INT PK auto`, `groupId`, `duaId`, `position INT?` (null = sırasız), UNIQUE(`groupId`,`duaId`); cascade.
    - `Segments`: `id INT PK auto`, `duaId` (cascade), `position INT`, `textAr`, `pronunciationTr?`, `pronunciationEn?`, `meaningTr?`, `meaningEn?`, `pronunciationTrSource?`, `pronunciationEnSource?`, `meaningTrSource?`, `meaningEnSource?` (FieldSource), `review ReviewStatus default none`.
    - `Tracks`: `id INT PK auto`, `ownerKind TrackOwnerKind`, `duaId?`, `groupId?` (tam olarak biri dolu — CHECK), `relPath`, `label`, `durationMs INT?`.
    - `Cues`: `id INT PK auto`, `trackId` (cascade), `startMs INT`, `segmentId INT?` (null = metinsiz bölüm; segment silinirse SET NULL değil — Task 4 kuralı uygular).
    - `ImportLogs`: `id`, `importedAt`, `fileName`, `reportJson`.

- [ ] **Step 1: Failing test** `schema_test.dart`:
  - `dua iki kategoride ve iki grupta olabilir`: `DUA-0030` ekle; kategoriler `Ramazan`, `40 Rabbenâ`; gruplar `GRP-005` (position 3) ve `GRP-TMP-40-rabbena` (position null). Sorgu: `categoriesOf('DUA-0030')` → `{'Ramazan','40 Rabbenâ'}`, `groupsOf('DUA-0030')` → 2 öğe.
  - `track sahibi tam olarak bir tane olmalı`: hem `duaId` hem `groupId` dolu ekleme → `SqliteException`.
  - `dua silinince segment, kategori bağı, grup öğesi silinir`.
  - `arapça metin bayt bayt saklanır`: `'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَعَلَىٰ'` yaz-oku → `==` ve `utf8.encode` eşit.
- [ ] **Step 2:** `dart test test/db/schema_test.dart` → FAIL (tanımsız).
- [ ] **Step 3:** Tabloları ve `ContentDatabase`'i yaz; `categoriesOf(String duaId) -> Future<Set<String>>`, `groupsOf(String duaId) -> Future<List<GroupItem>>` sorgularını `database.dart`'a ekle; `dart run build_runner build`.
- [ ] **Step 4:** Test → PASS. (Windows'ta `dart test` sqlite3.dll bulamazsa: sqlite3 paketinin native-assets/hook desteği kullanılır; olmazsa `sqlite3.dll` `packages/dua_core/` altına konur ve `.gitignore`'a eklenmez — README'de not.)
- [ ] **Step 5:** Commit `feat(core): içerik veritabanı şeması`.

---

### Task 3: Arapça satır bölücü

**Files:**
- Create: `packages/dua_core/lib/src/text/arabic_segmenter.dart`
- Test: `packages/dua_core/test/text/arabic_segmenter_test.dart`

**Interfaces:**
- Produces: `List<String> splitArabic(String text)`; `String mergeArabic(String a, String b)` (`'$a $b'`).

Kural: önce boş satırdan (`\n\s*\n`) paragraf, sonra her paragrafta `،`, `.`, `؟`, `?`, `؛` karakterinden **sonra** böl (noktalama önceki parçada kalır); her parça `trim`; boşlar atılır; tek `\n` → tek boşluk.

- [ ] **Step 1: Failing tests:**
  - Parça 1 metni (`اللَّهُمَّ اهْدِنَا فِيمَنْ هَدَيْتَ، ...تَعَالَيْتَ.`) → 9 parça; ilki `'اللَّهُمَّ اهْدِنَا فِيمَنْ هَدَيْتَ،'`, sonuncusu `'تَبَارَكْتَ رَبَّنَا وَتَعَالَيْتَ.'`.
  - Parça 16 metni (`...فَمَنْ يَنْصُرُهُمْ؟\n\nاللَّهُمَّ لَا رَبَّ...`) → ilk parça `'اللَّهُمَّ إِنْ لَمْ تَنْصُرْهُمْ فَمَنْ يَنْصُرُهُمْ؟'`, toplam 7.
  - Noktalamasız tek cümle → 1 parça, girişle aynı.
  - Koruma: tüm parçaların boşluksuz birleşimi == girişin boşluksuz hâli (rune rune).
  - `'وَعَلَىٰ ذِكْرِكَ'` içindeki `ىٰ` korunur.
- [ ] **Step 2:** Çalıştır → FAIL.
- [ ] **Step 3:** Uygula.
- [ ] **Step 4:** Çalıştır → PASS.
- [ ] **Step 5:** Commit `feat(core): arapça satır bölücü`.

---

### Task 4: Onay kuralları ve satır düzenleme

**Files:**
- Create: `packages/dua_core/lib/src/rules/approval.dart`, `lib/src/repo/segment_repo.dart`
- Test: `test/rules/approval_test.dart`, `test/repo/segment_repo_test.dart`

**Interfaces:**
- Consumes: Task 2 tabloları, Task 3 `splitArabic`/`mergeArabic`.
- Produces:
  - `bool canApprove(Segment s)`
  - `enum DuaProgress { draft, awaitingTranslation, inReview, approved }` — `draft`: hiç satır yok; `awaitingTranslation`: herhangi bir satır `none`; `inReview`: `none` yok ama `review` var; `approved`: hepsi `approved`.
  - `DuaProgress computeProgress(List<Segment> segments)`
  - `class PublishCheck { bool ok; List<String> reasons; List<int> fullyTimedTrackIds; }`
  - `Future<PublishCheck> checkPublishable(ContentDatabase db, String duaId)` — nedenler Türkçe: `'Yayına hazır işaretli değil'`, `'Satır yok'`, `'Onaylanmamış satır: N'`, `'Tam zamanlanmış ses kaydı yok'`. Tam zamanlı kayıt: duanın her satırına en az bir cue'su olan `ownerKind=dua` kaydı **veya** duanın her satırına cue içeren bir grup kaydı (grubun üyesiyse).
  - `class SegmentRepo(ContentDatabase db)`: `updateArabic(int segId, String text)`, `updateField(int segId, SegmentField f, String? value)` (`enum SegmentField { pronunciationTr, pronunciationEn, meaningTr, meaningEn }`; kaynak=`user`, onay değişmez), `approve(int segId)` (canApprove değilse `StateError`), `approveAll(String duaId) -> int` (onaylanabilenleri onaylar, sayıyı döner), `split(int segId, int charOffset) -> (int, int)`, `merge(int firstSegId) -> int` (sonraki satırla), `move(int segId, int newPosition)`, `replaceAllFromText(String duaId, String text)` (yapıştır+böl; mevcut satırları siler — cue varsa `StateError('Zamanlanmış satırlar var')`).

- [ ] **Step 1: Failing tests:**
  - `canApprove`: `meaningEn` boş → false; `pronunciationEn` boş, diğerleri dolu → true.
  - `computeProgress`: `[]`→draft; `[approved, none]`→awaitingTranslation; `[approved, review]`→inReview; `[approved, approved]`→approved.
  - `updateArabic` onaylı satırı `review` yapar; `updateField` onaylı satırı onaylı bırakır ve kaynağı `user` yapar.
  - `split`: çeviriler null, iki satır `none`; ilk satırın cue'ları ilkinde kalır, ikinci satırın cue'su yok; `checkPublishable` → `'Tam zamanlanmış ses kaydı yok'`.
  - `merge`: birleşen satırın metni `mergeArabic(a,b)`, `none`, ikinci satırın cue'ları birleşen satıra taşınır; position'lar 0..n-1 ardışık.
  - `move`: onay değişmez; position'lar ardışık.
  - `checkPublishable`: yayına hazır + 2 onaylı satır + her satırda cue'su olan dua kaydı → `ok`, `fullyTimedTrackIds` o kaydı içerir; grup kaydında aynı koşul → `ok`.
- [ ] **Step 2:** Çalıştır → FAIL.
- [ ] **Step 3:** Uygula (her işlem tek transaction).
- [ ] **Step 4:** Çalıştır → PASS.
- [ ] **Step 5:** Commit `feat(core): onay kuralları ve satır düzenleme`.

---

### Task 5: `dua-arsivi.json` içe aktarıcı

**Files:**
- Create: `packages/dua_core/lib/src/import/archive_importer.dart`
- Create: `packages/dua_core/test/fixtures/dua-arsivi.mini.json` — kullanıcının arşivinden: `groups` (ikisi), `parent_record`, `parts` 2 (DUA-0054 + varyantı), 3 (DUA-0030), 16 (DUA-0056-11, `\n\n`'li), `prior_archive_records` (DUA-0054, DUA-0030), kök metadata alanları. Değerler arşivden birebir kopyalanır.
- Test: `test/import/archive_importer_test.dart`

**Interfaces:**
- Consumes: Task 2, Task 3.
- Produces:
  - `class ImportReport { int duasCreated, duasUpdated, groupsCreated, segmentsCreated; List<String> warnings; List<String> changedDuaIds; }`
  - `class ArchiveImporter(ContentDatabase db)`: `Future<ImportReport> importJson(Map<String, dynamic> json, {required String fileName})`. `schema_version != 1` → `FormatException`.

Eşleme spec §6.3.2'deki tablodur. Ek kararlar:
- Satırlar yalnızca Arapça ile oluşturulur (`review = none`); dua bazlı okunuş/anlamlar `src*` alanlarına yazılır.
- Gruptaki parça sırası `part_number` (1'den başlar → position = part_number).
- Varyant: aynı grup öğesi ana duaya bağlanır; varyant duası grupta yer almaz, `variantOf` ile bağlıdır, kategorileri ana duadan kopyalanır.
- `parent_record.title_*` → grup `titleAr` ve (boşsa) diğer başlıklar; `categories_tr` → grup ve gruptaki tüm dualar (varyantlar dahil).
- Grup başlığı aynı ada sahip kategori olarak eklenir ve üyelerine atanır.
- Yeniden içe aktarma: dua varsa Arapça metin, satırlar ve kullanıcı alanları değişmez. Eğer JSON'daki `text_ar` mevcut satırların `mergeArabic` birleşiminden (boşluk farkı yok sayılarak) farklıysa veya `src*` alanları değiştiyse: `src*` güncellenir, `importDiff` doldurulur, id `changedDuaIds`'e eklenir. Satırların hiçbiri onaylı değil ve hiç cue yoksa satırlar yeni metinden yeniden oluşturulur (uyarı ile).

- [ ] **Step 1: Failing tests (mini fixture ile):**
  - Gruplar: `GRP-005` ("Ramazan Kunut Duaları", `titleAr = 'دُعَاءُ الْقُنُوتِ فِي رَمَضَانَ'`) ve `GRP-TMP-40-rabbena` ("40 Rabbenâ").
  - `DUA-0056` adında dua **yok**.
  - `DUA-0030`: iki grupta (GRP-005 position 3; 40 Rabbenâ position null); kategorileri `{Ramazan, Kunut, Münâcât, Ramazan Kunut Duaları, 40 Rabbenâ}`; `quranReference == '7:23'`; `expectedAudioFile == 'dua_0030.mp3'`; `editorialStatus == 'normalized'`.
  - Varyant `DUA-0054~plural_with_karim`: `variantOf == 'DUA-0054'`, `expectedAudioFile == 'dua_0054_plural_with_karim.mp3'`, 1 satır.
  - `DUA-0056-11`: 7 satır, tümü `none`, `srcMeaningTr` arşivdekiyle aynı.
  - Prior records: `DUA-0054`'ün eksik alanı yok; `text_ar: null` kaydı yeni dua oluşturmaz.
  - İdempotentlik: ikinci içe aktarma → `duasCreated == 0`, satır sayısı aynı.
  - Koruma: bir satırı onayla + `meaningTr` düzelt; JSON'da o duanın `meaning_tr`'sini değiştirip yeniden aktar → satır onaylı ve düzeltme duruyor, `srcMeaningTr` yeni, `changedDuaIds` o duayı içerir.
  - `ImportLogs`'a bir kayıt eklenir; `GRP-005.infoJson` `transcript_issues`'ı içerir.
- [ ] **Step 2:** Çalıştır → FAIL.
- [ ] **Step 3:** Uygula.
- [ ] **Step 4:** Çalıştır → PASS. Ek doğrulama: tam arşiv `content/import/dua-arsivi.json` mevcutsa geçici bir DB'ye aktarıp raporu yazdıran `packages/dua_core/tool/import_check.dart` çalıştır → 22 parça + 1 varyant = 23 dua, 2 grup.
- [ ] **Step 5:** Commit `feat(core): dua arşivi JSON içe aktarıcı`.

---

### Task 6: Claude ile çeviri alışverişi

**Files:**
- Create: `packages/dua_core/lib/src/translation/exchange.dart`, `content/translation/README.md`
- Test: `test/translation/exchange_test.dart`

**Interfaces:**
- Consumes: Task 2, Task 4 (`ReviewStatus`).
- Produces:
  - `Future<Map<String, dynamic>> buildPending(ContentDatabase db, {Set<String>? duaIds})` — `none` durumundaki satırları olan dualar.
  - `Future<TranslationImportReport> applyDone(ContentDatabase db, Map<String, dynamic> done)`; `class TranslationImportReport { int applied; List<int> staleSegmentIds; List<int> skippedApprovedIds; List<String> errors; }`

Formatlar (README'de de aynen):
```json
// pending.json
{"format":"dualarim.translation.pending/1","generated_at":"<ISO>",
 "duas":[{"dua_id":"DUA-0056-11","title_tr":"...","quran_reference":null,
   "source":{"pronunciation_tr":"...","pronunciation_en":"...","meaning_tr":"...","meaning_en":"..."},
   "segments":[{"segment_id":41,"position":0,"text_ar":"..."}]}]}
// done.json
{"format":"dualarim.translation.done/1",
 "segments":[{"segment_id":41,"text_ar":"<pending'deki ile aynı>",
   "pronunciation_tr":"...","pronunciation_en":"...","meaning_tr":"...","meaning_en":"..."}]}
```
Kurallar: `text_ar` mevcut metinle birebir değilse → `staleSegmentIds`, uygulanmaz. Onaylı satır → `skippedApprovedIds`. Kaynağı `user` olan alan ezilmez. Uygulanan alanların kaynağı `claude`, satır `review`.

README içeriği (Claude için): dosya yolları, formatlar, okunuş kuralı (spec §6.5: yaygın Türkçe okunuş, uzatmada şapka, `ğ`/`ḥ` yerine Türkçe harfler, arşivdeki `pronunciation_tr` üslubu örnek alınır), dua bazlı `source` metinlerinin satırlara **hizalı** bölünmesi, anlam satırın karşılığı olmalı; Arapça metne asla dokunulmaz.

- [ ] **Step 1: Failing tests:** pending yalnızca `none` satırları içerir; done uygulanınca satır `review` ve kaynak `claude`; `text_ar` farklı → stale; onaylı satır atlanır; `user` kaynaklı `meaningTr` korunur ama aynı satırdaki diğer alanlar uygulanır; yanlış `format` → `FormatException`.
- [ ] **Step 2:** Çalıştır → FAIL.
- [ ] **Step 3:** Uygula + README yaz.
- [ ] **Step 4:** Çalıştır → PASS.
- [ ] **Step 5:** Commit `feat(core): çeviri alışveriş dosyaları`.

---

### Task 7: Ses — eşleştirme, dalga formu, ffmpeg

**Files:**
- Create: `packages/dua_core/lib/src/audio/audio_matcher.dart`, `lib/src/audio/peaks.dart`
- Create: `apps/editor/lib/services/ffmpeg_service.dart`
- Test: `packages/dua_core/test/audio/audio_matcher_test.dart`, `test/audio/peaks_test.dart`, `apps/editor/test/ffmpeg_service_test.dart`

**Interfaces:**
- Produces:
  - `class AudioMatchResult { List<(String duaId, String fileName)> matched; List<String> unmatchedFiles; List<String> duasWithoutFile; }`
  - `Future<AudioMatchResult> matchAudioFolder(ContentDatabase db, Directory source, Directory contentDir, {String label = 'ElevenLabs'})` — `expectedAudioFile` ile **büyük/küçük harf duyarsız** eşleşen dosyaları `content/audio/`'ya kopyalar, `ownerKind=dua` kaydı ekler (aynı relPath varsa tekrar eklemez).
  - `Float32List peaksFromPcm16(Int16List samples, int buckets)` — her kova için mutlak tepe / 32768.
  - `class FfmpegService(String ffmpegPath)`: `Future<bool> isAvailable()`, `Future<File> extractAudio(File video, File outM4a)` (`-vn -c:a aac -b:a 128k`), `Future<Int16List> decodePcm(File audio, {int sampleRate = 8000})` (`-f s16le -ac 1 -ar 8000 pipe:1`), `Future<int> durationMs(File audio)`.
  - Ayar: ffmpeg yolu (varsayılan `ffmpeg` PATH'te). Kurulum: `winget install Gyan.FFmpeg`.

- [ ] **Step 1: Failing tests:** matcher: `DUA_0030.MP3` eşleşir, `rastgele.mp3` unmatched, beklenen dosyası olmayan dua listede, ikinci çalıştırma tekrar kayıt eklemez, relPath `audio/dua_0030.mp3`; peaks: `[0, 16384, -32768, 0]`, 2 kova → `[0.5, 1.0]`; ffmpeg (ffmpeg yoksa `skip`): 1 sn sinüs üretip (`-f lavfi -i sine=d=1`) `Kunut Duası 2024.mp4` adlı geçici dosyadan ses çıkarma → dosya var, `durationMs` 900–1100.
- [ ] **Step 2:** Çalıştır → FAIL.
- [ ] **Step 3:** ffmpeg'i kur (`winget install Gyan.FFmpeg`), uygula.
- [ ] **Step 4:** Çalıştır → PASS.
- [ ] **Step 5:** Commit `feat: ses eşleştirme, dalga formu ve ffmpeg servisi`.

---

### Task 8: Mobil için yayınlama

**Files:**
- Create: `packages/dua_core/lib/src/publish/publisher.dart`
- Test: `test/publish/publisher_test.dart`

**Interfaces:**
- Consumes: Task 4 `checkPublishable`.
- Produces:
  - `class PublishReport { int contentVersion; List<String> publishedDuaIds; Map<String, List<String>> skipped; List<String> publishedGroupIds; }`
  - `Future<PublishReport> publish(ContentDatabase db, {required Directory contentDir, required Directory outDir})`

Davranış: `outDir` temizlenir; yeni `content.db` aynı şemayla oluşturulur; yalnızca yayınlanabilir dualar, onların satırları, **tam zamanlı** kayıtları ve cue'ları, kategorileri; varyantlar ana duası yayınlanmasa da kendi başına değerlendirilir; gruplar yalnızca yayınlanan üyeleriyle (position korunur, en az 1 üye yoksa grup atlanır); grup kaydı yalnızca grubun **tüm** cue'lu satırları yayınlanan dualara aitse alınır. `src*`, `sourceJson`, `importDiff`, `infoJson`, `ImportLogs` boşaltılır. Ses dosyaları `outDir/audio/`'ya kopyalanır. `manifest.json`: `{"content_version": N, "published_at": "<ISO>", "duas": n, "groups": m}`; N = önceki manifest'teki + 1 (yoksa 1); yayınlanan her duanın `version`'ı kaynakta da N yapılır.

- [ ] **Step 1: Failing tests:** onaysız satırlı dua atlanır ve `skipped` nedenini içerir; yayınlanan DB'de `review != approved` satır sayısı 0; Arapça metin kaynakla bayt bayt aynı; grup 3 üyeden 2'si yayınlanabilir → grup 2 üyeyle, position'lar 1 ve 3 korunmuş; hiç üyesi yayınlanamayan grup yok; ikinci yayında `content_version == 2`; ses dosyası kopyalanmış; `sourceJson` null.
- [ ] **Step 2:** Çalıştır → FAIL.
- [ ] **Step 3:** Uygula.
- [ ] **Step 4:** Çalıştır → PASS.
- [ ] **Step 5:** Commit `feat(core): mobil için yayınlama`.

---

### Task 9: Cue zaman çizelgesi mantığı

**Files:**
- Create: `packages/dua_core/lib/src/sync/cue_timeline.dart`
- Test: `test/sync/cue_timeline_test.dart`

**Interfaces:**
- Produces (saf, DB'siz; editör UI'ı bunu kullanır, sonra DB'ye yazar):
  - `class CueEntry { int? id; int startMs; int? segmentId; }`
  - `class CueTimeline` — `CueTimeline(List<int> segmentOrder, List<CueEntry> cues)`; `int? nextSegmentId` (imleç: son işaretlenen satırdan sonraki; başta ilk satır); `void selectNext(int segmentId)`; `CueEntry markNext(int atMs)` (imleçteki satırı işaretler, imleci ilerletir); `CueEntry markGap(int atMs)`; `void nudge(CueEntry c, int deltaMs)` (komşu cue'ları geçemez, 0'ın altına inemez); `void move(CueEntry c, int toMs)` (aynı sınır); `void remove(CueEntry c)`; `CueEntry? activeAt(int ms)` (startMs ≤ ms olan son cue); `Set<int> untimedSegments`; `List<CueEntry> get sorted`.
  - Grup kaydı için `segmentOrder` = gruptaki duaların satırları position sırasıyla art arda.

- [ ] **Step 1: Failing tests:** 3 satır; `markNext(1000)`, `markNext(4000)` → imleç 3. satır; `markGap(6000)`; `activeAt(5000)` → 2. satır, `activeAt(6500)` → gap (segmentId null), `activeAt(500)` → null; `selectNext(seg1)` + `markNext(7000)` → seg1'in iki cue'su var (tekrar); `nudge(+100)` komşuyu geçmez; `untimedSegments == {seg3}`; ters sırayla eklenen cue'lar `sorted`'da sıralı.
- [ ] **Step 2:** Çalıştır → FAIL.
- [ ] **Step 3:** Uygula.
- [ ] **Step 4:** Çalıştır → PASS.
- [ ] **Step 5:** Commit `feat(core): cue zaman çizelgesi`.

---

### Task 10: Editör kabuğu ve dua listesi

**Files:**
- Create: `apps/editor/lib/main.dart`, `lib/app/app_state.dart`, `lib/services/settings.dart`, `lib/screens/dua_list_screen.dart`, `lib/screens/group_screen.dart`, `lib/widgets/category_chips.dart`, `assets/fonts/*`
- Test: `apps/editor/test/dua_list_screen_test.dart`

**Interfaces:**
- Consumes: Task 2, 4, 5, 6, 7, 8.
- Produces: `AppState` (`ChangeNotifier`): `Directory contentDir`, `ContentDatabase db`, `FfmpegService ffmpeg`, `Settings settings`; `Future<void> openContentDir(Directory d)`.

Davranış:
- Açılışta son klasör (`Settings`, `%APPDATA%\Dualarim\settings.json`), yoksa klasör seçtirir; `content.db` yoksa oluşturur.
- **Dua listesi:** sütunlar: id, başlık TR, durum (`computeProgress` → Türkçe etiket: Taslak / Çeviri bekliyor / Gözden geçirilecek / Onaylı), kategoriler, yayına hazır, kayıt sayısı, editoryal uyarı simgesi (`reconstructed`, `partial_match`, `importDiff != null`). Filtre: kategori (çoklu), grup, durum; arama (başlık/id).
- **Üst çubuk eylemleri:** "Yeni dua" (id `DUA-NNNN` önerilir: mevcut en büyük 4 haneli numara + 1; başlık TR zorunlu), "Yeni grup", "JSON içe aktar" (dosya seç → `ArchiveImporter` → rapor diyaloğu), "Sesleri eşleştir" (klasör seç → `matchAudioFolder` → rapor), "Çeviriye gönder" (`buildPending` → `content/translation/pending.json`, diyalog: "Claude'a 'çevirileri yap' deyin"), "Çevirileri içe aktar" (`content/translation/done.json` → `applyDone` → rapor), "Mobil için yayınla" (`publish` → rapor), "Ayarlar" (ffmpeg yolu; `isAvailable` sonucu).
- **Kategori yönetimi:** kategori ekle/yeniden adlandır/sil; `CategoryChips` widget'ı çoklu seçim (duaya kategori ata/çıkar).
- **Grup ekranı:** grup bilgileri, `infoJson` paneli (transcript_issues tablosu), üyeler sıralı listesi (sürükle-bırak sıra, dua ekle/çıkar), grup kayıtları listesi ve "Grup kaydı ekle".
- Arapça metin her yerde `Amiri`, `TextDirection.rtl`.

- [ ] **Step 1: Failing widget test:** bellek DB'sine mini fixture'ı aktar; listede `DUA-0030` satırında "Çeviri bekliyor" ve kategoriler görünür; "40 Rabbenâ" kategori filtresi yalnızca `DUA-0030`'u bırakır.
- [ ] **Step 2:** `flutter test test/dua_list_screen_test.dart` → FAIL.
- [ ] **Step 3:** Uygula.
- [ ] **Step 4:** Test → PASS; `flutter run -d windows` ile elle: klasör aç, `content/import/dua-arsivi.json` içe aktar, 23 dua görünür.
- [ ] **Step 5:** Commit `feat(editor): kabuk, dua listesi, grup ekranı`.

---

### Task 11: Dua düzenleme — metin ve çeviri gözden geçirme

**Files:**
- Create: `apps/editor/lib/screens/dua_edit_screen.dart`, `lib/widgets/segment_panel.dart`, `lib/widgets/review_fields.dart`
- Test: `apps/editor/test/dua_edit_screen_test.dart`

**Interfaces:**
- Consumes: Task 4 `SegmentRepo`, `canApprove`, `checkPublishable`; Task 10 `CategoryChips`.

Davranış:
- Üst bilgi: başlıklar (düzenlenebilir), id, Kur'an referansı, editoryal durum + not (uyarı rengiyle), `importDiff` varsa "JSON'da değişiklik var" paneli (eski/yeni) ve "gördüm" düğmesi (temizler), kategoriler (`CategoryChips`), varyantlar bağlantısı, "Yayına hazır" anahtarı + `checkPublishable` nedenleri.
- Sol: "Metin yapıştır" alanı + "Satırlara böl" (`replaceAllFromText`; satır varsa onay diyaloğu); JSON'dan gelen dua bazlı `src*` metinleri katlanabilir panelde (referans).
- Sağ: satır listesi; her satırda Arapça (düzenlenebilir), durum rozeti, "Böl" (imleç konumundan), "Alttakiyle birleştir", sürükle-bırak sıra; seçili satırda `ReviewFields`: 4 alan + kaynak rozeti (İçe aktarım / Claude / Siz) + "Onayla" (`canApprove` false iken pasif, ipucu hangi alanın eksik olduğunu söyler). "Tümünü onayla" (onay diyaloğuyla).

- [ ] **Step 1: Failing widget test:** satırın `meaningEn`'i boşken "Onayla" pasif; alan doldurulunca aktif; onaylanınca rozet "Onaylı"; Arapça düzenlenince rozet "Gözden geçirilecek".
- [ ] **Step 2:** Çalıştır → FAIL.
- [ ] **Step 3:** Uygula.
- [ ] **Step 4:** Çalıştır → PASS.
- [ ] **Step 5:** Commit `feat(editor): metin ve çeviri gözden geçirme`.

---

### Task 12: Oynatıcı, dalga formu ve zamanlama (tap-to-sync)

**Files:**
- Create: `apps/editor/lib/widgets/player_bar.dart`, `lib/widgets/waveform_view.dart`; Modify: `lib/screens/dua_edit_screen.dart`, `lib/screens/group_screen.dart`
- Test: `apps/editor/test/waveform_view_test.dart`, `apps/editor/test/sync_keys_test.dart`

**Interfaces:**
- Consumes: Task 7 `FfmpegService`, `peaksFromPcm16`; Task 9 `CueTimeline`.

Davranış:
- **Kayıt seçici:** duanın (veya grubun) kayıtları; "Kayıt ekle" (ses veya video; video ise `extractAudio` ile `content/audio/<ad>.m4a`; etiket sorulur; süre `durationMs`).
- **PlayerBar:** media_kit `Player`; oynat/duraklat, konum/süre (`mm:ss.d`), hız 0.5 / 0.6 / 0.75 / 0.9 / 1.0 (`setRate`, perde korumalı — `pitch` ayarı açık), ±2 sn atlama.
- **WaveformView:** `decodePcm` → `peaksFromPcm16` (genişliğe göre kova; sonuç `content/audio/.peaks/<ad>.bin` önbelleğine yazılır); oynatma imleci; cue işaretleri (satır numarasıyla etiketli dikey çizgi; gap gri); tıkla → seek; işaret sürükle → `CueTimeline.move`; yakınlaştırma (Ctrl+tekerlek).
- **Grup kaydında:** satır listesi gruptaki tüm duaların satırları (dua başlığı ayraçlarıyla); kaynağında `timestamp` ("18:22–19:02") olan dualar için bu aralık dalga formunda yarı saydam bant olarak gösterilir.
- **Klavye (oynatıcı odaklıyken):** Boşluk = oynat/duraklat; **Enter = `markNext`**; **G = `markGap`**; Sol/Sağ ok = seçili cue ±100 ms (`nudge`); Shift+ok = ±10 ms; Delete = seçili cue sil; Ctrl+Z = son işlemi geri al. Satıra tıklama = o satırın ilk cue'suna seek + `selectNext` (tekrar işaretlemek için).
- **Önizleme:** oynarken `activeAt` ile satır listesinde aktif satır vurgulanır ve görünür alanda tutulur.
- **Kaydetme:** her cue değişikliği DB'ye hemen yazılır (Cues tablosu, transaction).
- Not: spec "Boşluk ile işaretleme" örneği verdi; Boşluk evrensel oynat/duraklat olduğu için işaretleme Enter'a alındı (Claude'un kararı).

- [ ] **Step 1: Failing tests:** `waveform_view_test`: verilen peaks + cue'larla çizim, x=genişlik/2'ye tıklama `onSeek(durationMs/2)` çağırır; `sync_keys_test`: sahte oynatıcı konumu 1500 ms iken Enter → ilk satıra 1500 ms cue; G → gap cue; Sağ ok → seçili cue 1600 ms.
- [ ] **Step 2:** Çalıştır → FAIL.
- [ ] **Step 3:** Uygula (oynatıcıyı `abstract class PlaybackController { Stream<Duration> position; Duration get position; Future<void> seek(Duration); ... }` arkasına al; media_kit uygulaması + testte sahte).
- [ ] **Step 4:** Çalıştır → PASS. Elle doğrulama: `dua_0030.mp3` ile bir duayı 0.75x'te zamanla, önizlemede vurgulamanın sesi takip ettiğini gör; bir mp4 ekle → ses çıkarılır.
- [ ] **Step 5:** Commit `feat(editor): oynatıcı, dalga formu ve zamanlama`.

---

### Task 13: Uçtan uca doğrulama

**Files:**
- Create: `packages/dua_core/test/e2e/pipeline_test.dart`, `README.md` (kurulum: Flutter, ffmpeg, çalışma akışı 1–4)

- [ ] **Step 1: Test:** mini fixture → içe aktar → `buildPending` → elle hazırlanmış `done.json` (fixture) → `applyDone` → tüm satırları onayla → dua kaydı + her satıra cue → yayına hazır → `publish` → yayın DB'sinde dua, satırlar, cue'lar, kategoriler (çoklu), grup üyeliği mevcut.
- [ ] **Step 2:** `dart test` (tüm paket) ve `flutter test` (editör) → hepsi PASS; `flutter build windows --release` → başarılı.
- [ ] **Step 3:** Commit `test: uçtan uca içerik akışı; README`.
