# Dualarım — Tasarım Belgesi

Tarih: 2026-11-14
Durum: Taslak (kullanıcı onayı bekliyor)

## 1. Amaç ve neden

Duaları Arapça aslıyla, isteğe bağlı Türkçe okunuşu, Türkçe anlamı ve İngilizce anlamıyla gösteren; dua seslerini çalarken okunan satırı ekranda takip eden bir mobil uygulama (iOS + Android).

- **Kimin için:** Önce kullanıcının kendisi ve yakınları. İleride mağazada yayınlanabilir; tasarım bu yolu kapatmamalı.
- **İçerik nasıl üretilir:** Kullanıcı bir Windows editör uygulamasında sesi dinleyerek Arapça metni zaman çizelgesine yerleştirir. Okunuş ve çevirileri Claude (Claude Code oturumunda) üretir; kullanıcı editörde gözden geçirip düzeltir ve onaylar. Editörün çıktısı, mobil uygulamaya gömülen veritabanıdır.
- **Sıra:** Önce Windows editörü ve veritabanı, sonra mobil uygulama.

## 2. Hedefler

1. Windows editörü: dua oluşturma, ses/video dosyası ekleme, Arapça metni yapıştırıp satırlara bölme, sesi dinlerken satır başlangıçlarını işaretleme (zamanlama), çevirileri içe/dışa aktarma, gözden geçirme/onaylama, mobil için yayınlama.
2. Mobil uygulama: dua listesi, dua okuma ekranı (Arapça her zaman; okunuş / Türkçe / İngilizce açılıp kapanır), ses çalarken satır satır vurgulama ve otomatik kaydırma, çalma listeleri.
3. Editör ile mobil aynı veritabanı kodunu kullanır; uyumsuzluk mümkün olmamalı.

## 3. Hedef olmayanlar (ilk sürümde yok)

- Kelime kelime (karaoke) vurgulama. Veri modeli ileride eklemeye engel olmamalı ama ilk sürümde yapılmaz.
- İçeriği internetten indirme / sunucu. İçerik uygulama içine gömülü gelir. (Yayın kararı verilirse eklenir — bkz. §9.)
- Kullanıcı hesabı, senkronizasyon, bulut.
- Editörün içinde yapay zekâ / çeviri servisi bağlantısı.
- Mobilde video oynatma (mobil yalnızca ses çalar).
- macOS / Linux editör.

## 4. Kesinlikle olmaması gerekenler (anti-hedefler)

- **Onaylanmamış okunuş veya çevirinin mobil uygulamaya girmesi.** Dini metinde yanlış okunuş/anlam kabul edilemez; yayınlama yalnızca tüm satırları onaylı duaları dışa aktarır.
- Arapça metnin bozulması: harekeler, harf birleşmeleri ve sağdan sola yazım editörde ve mobilde doğru görünmeli; metin hiçbir aşamada normalize edilip harekesi silinmemeli.
- Editörün ürettiği veritabanını mobilin okuyamaması (şema uyumsuzluğu).
- İçerik güncellemesinin kullanıcının çalma listelerini/ayarlarını silmesi.

## 5. Yaklaşımlar

| Yaklaşım | Artı | Eksi |
|---|---|---|
| **A) Tek depo: iki Flutter uygulaması + ortak `dua_core` paketi** (seçildi) | Şema ve modeller tek yerde; editörün ürettiği DB'yi mobil kesin okur; Flutter makinede kurulu | Flutter masaüstünde medya/dalga formu araçları WPF kadar olgun değil |
| B) Editör C#/WPF, mobil Flutter | Windows'ta olgun medya araçları | Şema iki dilde yazılır, sürekli uyumsuzluk riski |
| C) Editör tarayıcı tabanlı | Kurulum yok | Yerel dosya ve DB'ye doğrudan yazmak zahmetli; kullanıcı Windows uygulaması istedi |

Kullanıcı **A**'yı seçti.

## 6. Kararlaştırılan tasarım

### 6.1 Depo yapısı

```
Dualarim/
  packages/dua_core/   ← veritabanı şeması, modeller, sorgular, içerik dosya formatları
  apps/editor/         ← Flutter Windows masaüstü uygulaması
  apps/mobile/         ← Flutter iOS + Android uygulaması
  content/             ← editörün çalışma klasörü (kaynak içerik; bkz. 6.3)
  docs/
```

### 6.2 Veri modeli (içerik veritabanı, SQLite)

Model, kullanıcının verdiği `dua-arsivi.json` (schema_version 1) yapısına göre kurulmuştur (eşleme: §6.3.2).

- **Dua**: id (JSON'daki kalıcı kod, ör. `DUA-0030`, `DUA-0056-01`; değişmez), başlık TR / EN / AR (AR isteğe bağlı), **varyant bilgisi** (`variant_of` → ana dua id, `variant_key`; bkz. aşağı), Kur'an referansı (isteğe bağlı, ör. "7:23"), **editoryal durum** (JSON `status`: normalized / partial_match / reconstructed … — editörde gösterilir), editoryal not (JSON `source.note_tr`), kaynak bilgisi (JSON `source` nesnesi olduğu gibi saklanır), **sürüm numarası**, "yayına hazır" bayrağı.
- **Kategori** (etiket): id, ad TR, ad EN, sıra. **Dua ↔ Kategori çoka-çok** (`dua_category` tablosu): bir dua birden fazla kategoride olabilir (ör. Hz. Âdem'in duası hem "Rabbenâ" hem "Ramazan", "Kunut").
- **Grup (koleksiyon)**: id, başlık TR / EN / AR, açıklama, kategoriler (gruba da çoka-çok kategori), editoryal durum. **Grup ↔ Dua çoka-çok ve sıralı** (`group_item`: grup_id, dua_id, sıra no). Aynı dua birden fazla grupta yer alabilir (ör. `DUA-0030` hem "40 Rabbenâ" hem "Ramazan Kunut Duaları" 3. parça). Grup mobilde baştan sona sırayla okunabilen/çalınabilen hazır bir liste gibi davranır.
- **Satır (segment)**: id, dua_id, sıra no, **Arapça metin**, Türkçe okunuş, İngilizce okunuş (isteğe bağlı), Türkçe anlam, İngilizce anlam, her alan için kaynak (içe aktarım / Claude / kullanıcı düzeltmesi), **onay durumu** (çeviri yok / gözden geçirilecek / onaylı).
- **Ses kaydı (track)**: id, dosya adı, okuyan/etiket (ör. "ElevenLabs", "Halis Bayancuk"), süre, ve **sahibi: ya bir dua ya bir grup**. Bir duanın / grubun birden fazla kaydı olabilir.
  - Dua kaydı: yalnızca o duanın satırlarını içerir (ör. `dua_0030.mp3`).
  - Grup kaydı: grubun tamamını içeren uzun kayıt (ör. 25 dakikalık Kunut videosu). Satırlar birden fazla duaya ait olabilir; aralarda anlatım/ek yakarış gibi metni olmayan bölümler bulunur.
- **Zamanlama (cue)**: track_id, başlangıç ms, segment_id **veya boş**. Bitiş = sonraki cue'nun başlangıcı (son cue kaydın sonuna kadar). Boş segment = "metinsiz bölüm" (vurgulama yok). **Aynı satır bir kayıtta birden fazla kez işaretlenebilir** (imamın tekrarları için). Zamanlama kayda özeldir.

Kelime kelime takibi için ileride segment altına "kelime zamanlaması" tablosu eklenebilir; şimdi yapılmaz.

**Varyantlar** *(Claude'un kararı)*: JSON'daki `variants` (ör. `DUA-0054` kerîm'li / kerîm'siz okunuş) **ayrı dua kaydı** olarak saklanır: id `DUA-0054~plural_with_karim`, `variant_of = DUA-0054`, kendi metni, satırları ve ses dosyası vardır. Mobilde ana duanın ekranında "Diğer okunuşlar" olarak görünür. Grupta kullanılan varyant hangisiyse `group_item` o kayda bağlanır.

**Satır bazında okunuş/anlam** *(Claude'un kararı)*: JSON'da okunuş ve anlamlar dua bazında (tek paragraf). Satır satır vurgulamada her satırın kendi okunuşu/anlamı görünmesi için, içe aktarımda Arapça metin satırlara bölünür ve Claude okunuş/anlamları bu satırlara hizalı biçimde böler (gerekirse yoğunlaştırılmış anlamları satır karşılıklarına açar; ör. parça 16). Bu bölünmüş hâller "gözden geçirilecek" olarak gelir. JSON'daki dua bazlı orijinal metinler de duada saklanır (karşılaştırma için).

### 6.3 Editör çalışma klasörü

`content/` klasörü editörün tek doğru kaynağıdır:
- `content/content.db` — içerik veritabanı (yukarıdaki şema; taslak + onaysız her şey dahil)
- `content/audio/` — ses dosyaları
- `content/translation/` — Claude ile çeviri alışverişi dosyaları (bkz. 6.5)

Bu klasör git ile sürümlenebilir (yedek ve geçmiş için).

### 6.3.1 İş sırası ve JSON ile toplu içe aktarma

Kullanıcının belirttiği sıra:
1. Önce Windows editörü: zamanlama (senkron) akışı ve çalma hızı ayarı oturtulur.
2. Kullanıcı mevcut dua içeriğini bir **JSON dosyası** olarak verecek. Editör bu JSON'u toplu içe aktarır (dualar, kategoriler, Arapça metin ve JSON'da varsa okunuş/çeviriler). **Veri modeli ve mobil şablon bu JSON'un yapısına göre son hâlini alır** — JSON gelince §6.2 gözden geçirilir.
3. Kullanıcı mp3 dosyalarını verir; editörde her birini dinleyerek ilgili duaya bağlar ve satırları zamanlar.
4. Claude eksik okunuş/çevirileri tamamlar (§6.5), kullanıcı onaylar, mobil için yayınlanır.

JSON'dan gelen okunuş/çeviriler de "gözden geçirilecek" durumunda gelir; kullanıcı onaylamadan yayına girmez.

### 6.3.2 `dua-arsivi.json` eşlemesi (schema_version 1)

| JSON | Veritabanı |
|---|---|
| `groups[]` | Grup. `id: null` olan grup (ör. "40 Rabbenâ") için içe aktarımda geçici id üretilir (ör. `GRP-TMP-40-rabbena`); kullanıcı editörde kalıcı kodu verebilir. `known_record_ids` → sırasız `group_item` (sıra kullanıcıya kalır). |
| `parent_record` (ör. `DUA-0056`, `text_ar: null`) | Kendi metni olmayan "bileşik dua" ayrı dua olarak **oluşturulmaz**; başlığı (AR dahil) ve `categories_tr` bilgileri ilgili gruba (`group_id`) aktarılır. |
| `parts[]` | Dua + `group_item` (sıra = `part_number`). `text_ar` satırlara bölünür (bkz. aşağı). `pronunciation_tr/en`, `meaning_tr/en` dua bazında saklanır, satırlara Claude böler. |
| `parts[].variants[]` | Varyant dua (§6.2). |
| `parts[].elevenlabs.output_filename` | Beklenen ses dosyası adı. Kullanıcı mp3 klasörünü verdiğinde editör dosya adına göre **otomatik eşler** (dua kaydı, etiket "ElevenLabs"); eşleşmeyenler listelenir. |
| `parts[].source` | Kaynak bilgisi olarak saklanır; `pdf_time_window` **uzun grup kaydında zamanlama yaparken ipucu** olarak gösterilir (o duanın kayıtta yaklaşık nerede olduğu). |
| `status`, `note_tr`, `quran_reference` | Editoryal durum / not / Kur'an referansı. `reconstructed` ve `audio_verification_pending` durumundaki dualar editörde uyarıyla gösterilir: kullanıcı sesi dinlerken Arapça metni doğrular/düzeltir. |
| `prior_archive_records[]` | Aynı id'li dua varsa yalnızca eksik alanları ve grup üyeliğini (`group_title_tr` → grup) tamamlar; `text_ar: null` olan kayıtlar metin olarak içe alınmaz. |
| Kategoriler | `parent_record.categories_tr` gruba ve grubun tüm dualarına kategori olarak atanır; grup başlığı da (ör. "40 Rabbenâ") kategori olarak eklenir. Kategoriler editörde serbestçe eklenip çıkarılabilir. |
| `sources`, `transcript_issues`, `archive_coverage`, `editorial_notes_tr` | İçe aktarım kaydı olarak saklanır; editörde grup bilgi panelinde gösterilir; mobile gitmez. |

**Satırlara bölme varsayılanı** *(Claude'un kararı)*: `text_ar` önce boş satırdan (`\n\n`), sonra Arapça virgül (`،`) ve noktadan bölünür. Kullanıcı editörde birleştirip yeniden bölebilir. Hareke ve özel karakterler (ör. `ىٰ`) asla değiştirilmez.

İçe aktarma **tekrar çalıştırılabilir**: aynı id'ler güncellenir; kullanıcının onayladığı veya düzelttiği alanlara dokunulmaz, farklılık varsa editörde "JSON'da değişiklik var" uyarısı gösterilir.

### 6.4 Windows editörü

**Dua listesi ekranı:** duaları ve durumlarını (taslak, çeviri bekliyor, gözden geçirilecek, onaylı) listeler; yeni dua, kategori yönetimi.

**Dua düzenleme ekranı** — üç bölge:

```
┌───────────────────────────────────────────────────────────┐
│ [Kayıt: Mishary ▼]  ▶ ⏸  00:12.4 / 01:45   hız: 0.75x     │
│ ▁▃▅▇▅▃▁▂▅▇▇▅▃▁▁▃▅▇▅▃  (dalga formu + satır işaretleri)    │
│    |1      |2         |3       |4                          │
├──────────────────────────┬────────────────────────────────┤
│ Metin yapıştır alanı     │ Satırlar                        │
│ (Arapça; her satır =     │ 1 ✓ 00:00.8  بِسْمِ اللَّهِ...       │
│  bir segment)            │ 2 ✓ 00:04.1  ...                │
│                          │ 3 ▶ (sıradaki işaretlenecek)    │
│ [Satırlara böl]          │   okunuş / TR / EN (düzenlenir) │
│                          │   [Onayla]                      │
└──────────────────────────┴────────────────────────────────┘
```

- **Medya:** mp3 / m4a / wav ses ve mp4 video açılabilir. Video eklenince sesi ayrılıp `content/audio/` altına ses dosyası (m4a) olarak kaydedilir; mobil yalnızca bu ses dosyasını kullanır.
- **Yavaşlatma:** 0.5x – 1.0x çalma hızı (perdeyi bozmadan, zamanlamayı kolaylaştırmak için).
- **Metin girişi:** Arapça metin yapıştırılır, satır sonlarına göre segmentlere bölünür; segmentler sonradan bölünebilir/birleştirilebilir/yeniden sıralanabilir.
- **Zamanlama (tap-to-sync):** ses çalarken kullanıcı bir tuşa (ör. Boşluk) bastığında o an, sıradaki satırın başlangıcı olarak kaydedilir ve imleç bir sonraki satıra geçer. Ayrı bir tuş (ör. G) "metinsiz bölüm başladı" işareti koyar (anlatım, ek yakarış). Tekrarlanan bir satır için kullanıcı satır listesinden o satırı seçip işaretler (sıradaki satır imleci yalnızca varsayılandır). Grup kaydında satır listesi grubun tüm dualarını sırayla gösterir ve her duanın JSON'daki yaklaşık zaman penceresi ipucu olarak görünür. Sonra işaretler dalga formu üzerinde sürüklenerek veya ±100 ms kaydırılarak düzeltilir. Bir satıra tıklayınca ses o satırın başına atlar (kontrol için).
- **Önizleme:** mobildeki gibi satır vurgulamalı oynatma.
- **Çeviri gözden geçirme:** her satırda okunuş / TR / EN alanları görünür ve düzenlenebilir; satır tek tek veya toplu onaylanır. Kullanıcının düzelttiği alan "kullanıcı düzeltmesi" olarak işaretlenir.

### 6.5 Çeviri akışı (Claude ile)

1. Editörde **"Çeviriye gönder"**: çevirisi olmayan satırlar `content/translation/pending.json` dosyasına yazılır (dua bağlamı + satır id + Arapça metin).
2. Kullanıcı Claude Code'a "çevirileri yap" der. Claude dosyayı okur, her satır için Türkçe okunuş, Türkçe anlam, İngilizce anlam yazar → `content/translation/done.json`.
3. Editörde **"Çevirileri içe aktar"**: alanlar doldurulur, durum "gözden geçirilecek" olur. Onaylı veya kullanıcının düzelttiği alanların üzerine asla yazılmaz.
4. Kullanıcı gözden geçirir, düzeltir, onaylar.

Okunuş yazım kuralı: yaygın Türkçe okunuş geleneği (ör. "Bismillâhirrahmânirrahîm"; uzatmalar için şapka) — Claude tutarlı uygular, kullanıcı değiştirmek isterse kural güncellenir.

### 6.5.1 Onay kuralları *(Claude'un kararı — kullanıcı değiştirebilir)*

- Onay **satır bazındadır** (alan bazında değil). Satırın onay durumu: çeviri yok / gözden geçirilecek / onaylı.
- Bir satırın onaylanabilmesi için Arapça, Türkçe okunuş, Türkçe anlam ve İngilizce anlamın **dördü de dolu** olmalıdır.
- Onay, satırın Arapçası + üç çevirisinin birlikte doğru olduğunu kabul etmektir. Zamanlama ayrıca onaylanmaz; "tüm satırlar zamanlanmış mı" yayın kontrolünde bakılır.
- **Onayı bozan işlemler:** satırın Arapçası değişirse, satır bölünür veya birleştirilirse ilgili satır(lar) "gözden geçirilecek"e döner (bölme/birleştirmede çeviriler boşaltılır → "çeviri yok"). Yalnızca sıra değiştirmek ve kullanıcının bir çeviri alanını düzeltmesi onayı bozmaz (düzeltme zaten kullanıcının elinden çıkıyor).

### 6.5.2 Dua durumu *(Claude'un kararı)*

- Listede görünen durum (taslak / çeviri bekliyor / gözden geçirilecek / onaylı) **satırlardan hesaplanır**, saklanmaz.
- Ayrıca kullanıcının elle işaretlediği bir **"yayına hazır"** bayrağı vardır (saklanır).
- **Yayınlanabilirlik:** yayına hazır işaretli + en az bir satır + tüm satırlar onaylı + en az bir ses kaydı olup o kayıtta tüm satırlar zamanlanmış. Zamanlaması eksik kayıtlar yayına alınmaz. Sessiz (yalnızca metin) dua ilk sürümde yayınlanmaz.

### 6.6 Mobil için yayınlama

Editörde **"Mobil için yayınla"**:
- Yalnızca 6.5.2'deki kurala göre yayınlanabilir duaları ve tam zamanlanmış kayıtlarını alır.
- Bunlardan ayrı bir `content.db` (yayın kopyası) ve kullanılan ses dosyalarını `apps/mobile/assets/content/` altına kopyalar; içerik sürüm numarasını artırır.
- Ardından mobil uygulama yeniden derlenir.

### 6.7 Mobil uygulama

- **Ana ekran:** Gruplar (ör. "Ramazan Kunut Duaları", "40 Rabbenâ") ve kategoriler; bir dua birden fazla kategoride/grupta görünür. Arama (Türkçe başlık, okunuş, anlam; Arapçada harekesiz eşleşme).
- **Grup ekranı:** grubun duaları sırayla; tamamını art arda çalma (her duanın kendi kaydıyla) veya grubun uzun kaydı varsa onu çalma. Uzun kayıtta metinsiz bölümlerde vurgulama olmaz, ekranda "…" gösterilir.
- **Varyantlar:** ana duanın ekranında "Diğer okunuşlar" (ör. kerîm'li okunuş).
- **Dua ekranı:** Arapça her zaman görünür; okunuş, Türkçe anlam, İngilizce anlam ayrı ayrı açılıp kapanır (tercih kalıcı). Yazı boyutu ayarı. Ses kaydı seçimi (birden fazla varsa).
- **Oynatma:** ses çalarken o anki satır vurgulanır, ekran onu ortada tutacak şekilde kayar; bir satıra dokununca ses oraya atlar. Arka planda ve kilit ekranında çalmaya devam eder; kilit ekranı kontrolleri.
- **Çalma listeleri:** kullanıcı liste oluşturur, dualar ekler (hangi ses kaydıyla), sıralar; liste art arda çalar, ekranda o an çalan dua ve satırı takip edilir. Tekrar (listeyi / tek duayı) seçeneği.
- **Kullanıcı verisi ayrı tutulur:** çalma listeleri ve ayarlar ayrı bir yerel veritabanında; içerik değiştirilince (yeni sürüm) silinmez. Çalma listesi duaya slug ile bağlanır; içerikten kaldırılmış dua listede sessizce atlanır.
- **Arayüz dili:** Türkçe. Metinler yerelleştirme dosyasında tutulur (ileride İngilizce arayüz için).

## 7. Kısıtlar

- Geliştirme makinesi Windows; editör ve Android burada derlenir. **Kullanıcının Mac'i ve Apple geliştirici hesabı var**; iOS ilk sürümün parçasıdır, Mac'te derlenip test edilir.
- Tüm sesler uygulamaya gömülür (kullanıcı kararı). Toplam boyut büyürse ses sıkıştırma (ör. m4a/AAC ~64 kbps mono) uygulanır.
- Flutter 3.47 kurulu (`D:\tools\flutter`).
- Arapça yazı tipi uygulamayla dağıtılabilir lisanslı olmalı (ör. Amiri veya Scheherazade New — OFL).
- Ses dosyalarının telif durumu kullanıcının sorumluluğunda; kişisel kullanımda sorun değil, yayın öncesi gözden geçirilmeli.
- Uygulama boyutu gömülü seslerle büyür; şimdilik kabul.

## 8. Uygulayıcıya bırakılanlar

- Paket seçimleri (ör. SQLite erişimi için drift; mobil ses için just_audio + audio_service; Windows'ta ses/video için media_kit; video→ses ayırma için ffmpeg), monorepo aracı (Dart pub workspaces veya melos).
- Dalga formunun nasıl çizileceği.
- Ekranların görsel tasarım ayrıntıları, renkler, ikonlar.
- Test stratejisi (şema/yayınlama/çeviri içe aktarma mantığı için birim testleri beklenir).

## 9. İleride (yayın kararı verilirse)

- İçeriği sunucudan indirme: duaların sürüm numarası ve ayrı ses dosyaları bu geçişi kolaylaştırır.
- Kelime kelime vurgulama.
- İngilizce arayüz.
