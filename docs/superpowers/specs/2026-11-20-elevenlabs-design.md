# ElevenLabs Seslendirme, Çok Dilli Ses ve Türkçe Dualar — Tasarım

Tarih: 2026-11-20 · Durum: taslak (kullanıcı onayı bekliyor) · Üst belge: `2026-11-14-dualarim-design.md`

## 1. Amaç

Kullanıcı duaların sesini elle kaydetmek yerine editörden doğrudan ElevenLabs ile üretmek istiyor: Arapça (ör. "Hanafi" sesi), Türkçe ve İngilizce. Ses isteğe bağlıdır; sesi olmayan dua metin olarak yayınlanır. Yalnızca Türkçe olan dualar da eklenebilir. Telefonda kullanıcı dinleme dilini seçer.

## 2. Hedefler

1. Editörde ElevenLabs ayarları: API anahtarı girişi, her dil (ar/tr/en) için ses seçimi, seçilen sesi kısa bir metinle **deneme** alanı.
2. Bir duanın Arapça / Türkçe / İngilizce sesini tek tuşla üretme (dua ekranında düğme, listede sağ tık); listede birden çok dua seçip toplu üretme.
3. Üretilen sesin satır zamanlaması **otomatik**: ElevenLabs'in harf zamanlarından satır işaretleri konur; elle zamanlama gerekmez.
4. Ses isteğe bağlı: sesi olmayan (ya da yalnız bazı dillerde sesi olan) dua yayına girer; sesi yoksa metin olarak kalır.
5. Yalnızca Türkçe dua: Arapçası olmayan dua oluşturulabilir, gösterilir, Türkçe sesi üretilebilir.
6. Telefonda **dinleme dili** seçimi: Arapça / Türkçe / İngilizce (kalıcı tercih).

## 2.1 Ön iş: eksik satır anlamları (kullanıcı kararı)

Şu an 148 duanın 38'inde (189 satır) satır bazında Türkçe/İngilizce anlam yok. Ses üretiminden önce bu satırların anlamları, 2026-11-14'teki 449 satırdaki yöntemle (JSON'daki dua paragrafını satırlara bölme; `tool/translation_io.dart` export → bölme → apply; editör kapalıyken) doldurulur. Böylece Türkçe/İngilizce ses satır vurgusuyla üretilir.

## 3. Hedef olmayanlar

- Satır satır sıralı dinleme (Arapça satır → Türkçe anlamı): kullanıcı "dil seçimi"ni seçti.
- Tek satırı yeniden üretme: ses dua bazında üretilir (kullanıcı yaklaşım 1'i seçti).
- Telefonda ses üretimi / ElevenLabs çağrısı: yalnızca editör çağırır.
- ElevenLabs dışında TTS sağlayıcısı.

## 4. Kesinlikle olmaması gerekenler

- **API anahtarı bu bilgisayardan çıkmamalı:** yalnızca editörün ayar dosyasında (`%APPDATA%\Dualarim\settings.json`) durur; içerik veritabanına, yayın çıktısına, git'e girmez; kayıtlarda/hata mesajlarında gösterilmez (yalnız son 4 hanesi).
- **Elle yapılmış kayıt ve zamanlama sessizce silinmemeli:** aynı dilde var olan kaydı değiştirmek onay ister; elle eklenmiş (ElevenLabs olmayan) kayıt hiçbir zaman kendiliğinden silinmez.
- **Arapça metin değiştirilmemeli:** ElevenLabs'e gönderilen metin satırların birleştirilmiş hâlidir; satırların kendisine dokunulmaz.
- **Yarım kayıt oluşmamalı:** üretim başarısız olursa (ağ, anahtar, kota) hiçbir dosya/kayıt/işaret yazılmaz.

## 5. Yaklaşımlar

| Yaklaşım | Artı | Eksi |
|---|---|---|
| **1. Duanın tamamı tek istekte, zamanlarla (`with-timestamps`)** — seçildi | Dua başına bir istek; doğal okuyuş; işaretler otomatik | Tek satır yeniden üretilemez (tüm dua yeniden üretilir) |
| 2. Her satır ayrı üretilip birleştirilir | Tek satır yenilenebilir | Tonlama kopukluğu, çok istek (Vird-i Settâr yüzlerce satır), birleştirme için ffmpeg |
| 3. Tek seferde üret, elle zamanla | En basit | Her seste elle Enter'la zamanlama; istenen kolaylığı vermez |

## 6. Tasarım

### 6.1 Veri modeli değişiklikleri (içerik veritabanı, şema v2)

- **Tracks**: `language TEXT NOT NULL DEFAULT 'ar'` (`ar` | `tr` | `en`), `source TEXT NOT NULL DEFAULT 'manual'` (`manual` | `elevenlabs`), `voiceId TEXT NULL`, `voiceName TEXT NULL`, `isPrimary BOOL NOT NULL DEFAULT true`, `textHash TEXT NULL` (üretimde kullanılan birleşik metnin SHA-1'i). Var olan kayıtlar `ar` + `manual` + birincil olur.
- **Birincil kayıt** *(Claude'un kararı)*: aynı dua+dilde birden çok kayıt olabilir; en son eklenen birincil olur, editörde "Telefonda bu çalsın" ile değiştirilir. Telefon dua+dil için birincil kaydı çalar; birincil tam zamanlı değilse aynı dildeki başka tam zamanlı kayda düşer.
- **Metin değişikliği** *(Claude'un kararı)*: ElevenLabs kaydının `textHash`'i, satırların şu anki metninden üretilen hash'ten farklıysa editörde "metin değişti — sesi yeniden üret" uyarısı (liste + dua ekranı + yayın raporu). Yayını engellemez.
- **Duas**: `textLanguage TEXT NOT NULL DEFAULT 'ar'` (`ar` | `tr`). `tr` = yalnızca Türkçe dua.
- **Segments**: Türkçe duada satırın ana metni `meaningTr`'dedir; `textAr` boş dize (`''`) olur. (Sütun NOT NULL kalır.)
- drift `schemaVersion` 1 → 2, `onUpgrade` ile sütun ekleme. Yayın çıktısı aynı şemayla yazılır; mobil uygulama bu şemayı okur.

### 6.2 Yalnızca Türkçe dua (editör)

- "Yeni dua" diyaloğunda **"Yalnızca Türkçe"** seçeneği → `textLanguage = 'tr'`.
- Metin yapıştırma alanı Türkçe duada Türkçe metni cümle sonlarından (`.`, `!`, `?`, boş satır) satırlara böler ve `meaningTr`'ye yazar; `textAr = ''`.
- Satır kartında Arapça alanı gizlenir; ana metin olarak Türkçe gösterilir. İsteğe bağlı İngilizce anlam (`meaningEn`) girilebilir.
- Türkçe duada Arapça ses üretimi kapalıdır.

### 6.3 ElevenLabs ayarları (editör → Ayarlar → ElevenLabs sekmesi)

- **API anahtarı** alanı (gizli yazı, göster/gizle) + "Bağlantıyı dene" → `GET /v1/user/subscription` ile doğrular ve **kalan karakter kotasını** gösterir (`character_limit - character_count`).
- **Sesler:** her dil (Arapça, Türkçe, İngilizce) için ayrı seçim. Liste `GET /v1/voices` (hesaptaki sesler). Ayrıca **"Ses kitaplığında ara"** (`GET /v1/shared-voices?search=…`, ör. "Hanafi") → seçilen kitaplık sesi "Hesabıma ekle" (`POST /v1/voices/add/{public_owner_id}/{voice_id}`) ile hesaba eklenir. Elle **ses kimliği (voice ID)** girmek de mümkün.
- **Deneme alanı:** metin kutusu (varsayılan: o dilde kısa bir dua cümlesi) + "Seslendir" → `POST /v1/text-to-speech/{voice_id}` → editörde çalınır; dosya kalıcı yazılmaz.
- Model: `eleven_multilingual_v2` (ar, tr, en destekli); çıktı `mp3_44100_64`. Ayarda değiştirilebilir (varsayılan bu).
- Ayarlar `settings.json`'a yazılır: `elevenLabs: { apiKey, modelId, voices: { ar: {id, name}, tr: {...}, en: {...} } }`.

### 6.4 Ses üretimi

**Metin:** dil `ar` → satırların `textAr`'ı; `tr` → satırların `meaningTr`'ı; `en` → satırların `meaningEn`'ı. Satırlar `\n` ile birleştirilir; her satırın birleşik metindeki başlangıç ofseti tutulur. Seçilen dilde metni boş olan satır varsa: o dil için üretim yapılmaz, uyarı verilir ("3 satırın Türkçe metni yok").

**İstek:** `POST /v1/text-to-speech/{voice_id}/with-timestamps` gövde `{text, model_id}`; yanıt `{audio_base64, alignment: {characters[], character_start_times_seconds[], character_end_times_seconds[]}}`.

**Uzun metin:** birleşik metin 4.500 karakteri aşarsa satır sınırlarından parçalara bölünür, parçalar sırayla üretilir; ses parçaları ffmpeg ile birleştirilir (`concat`), her parçanın zaman ofseti bir önceki parçaların süresiyle kaydırılır.

**Zamanlama:** her satır için cue = satırın ilk boşluk-olmayan karakterinin `character_start_times_seconds` değeri (ms). Hizalama dizisi metinle karakter karakter eşleşir; eşleşmezse (uzunluk farkı) satır başları, normalleştirilmiş metinde ofset aranarak bulunur; bulunamazsa üretim hata verir, kayıt yazılmaz.

**Kayıt:** ses `content/audio/tts/<duaId>_<dil>.mp3` olarak yazılır; Track (`language`, `source='elevenlabs'`, `voiceId`, `voiceName`, `label = "ElevenLabs – <ses adı>"`, `durationMs`) ve her satır için Cue tek transaction'da eklenir. Aynı dua+dilde zaten kayıt varsa onay sorulur; ElevenLabs kaydıysa değiştirilir, elle eklenmiş kayıtsa yanına yeni kayıt eklenir (silinmez).

**Arayüz:**
- Dua ekranı sağ panelinde: "Ses üret: [Arapça] [Türkçe] [İngilizce]" düğmeleri (dua dili/metni uygun değilse pasif, ipucuyla).
- Dua listesinde çoklu seçim (Ctrl/Shift+tık) ve sağ tık menüsü: "Arapça sesi üret", "Türkçe sesi üret", "İngilizce sesi üret".
- Toplu üretimden önce özet: dua sayısı, toplam karakter, kalan kota; onay. Üretim sırasında ilerleme ve iptal; her dua bağımsızdır (biri hata verirse diğerleri sürer), sonunda rapor.
- Listede zamanlama durumu dil bazında gösterilir (ör. "AR ✓ · TR ✓ · EN –").

### 6.5 Yayın kuralı (değişiklik)

- Dua yayınlanır: satırı varsa (metin). **Ses zorunlu değil** (kullanıcı: "bazen hiç ses eklemeyebiliriz, bu durumda text olarak kalır"). Sonuç: içerikteki tüm dualar (148) yayına girer; varyantlar listede tek başına görünmez (mevcut `standaloneVisible`).
- Kayıt yayına girer: dosyası diskte, tüm satırları işaretli (tam zamanlı). Diğer kayıtlar atlanır (raporda belirtilir) ama dua metin olarak yayınlanır.
- Grup kaydı kuralı aynen kalır.

### 6.6 Mobil uygulama

- Okuma seçeneklerine **"Dinleme dili: Arapça / Türkçe / İngilizce"** (kalıcı).
- Kuyruk kurulurken her dua için sıra: seçilen dildeki birincil kayıt → duanın kendi dilindeki (`textLanguage`) kayıt → Arapça kayıt → metin olarak geç (mevcut "sesi yok" davranışı). *(Claude'un kararı.)*
- Yalnızca Türkçe dua: Arapça satır yerine Türkçe ana metin büyük puntoyla gösterilir; "Türkçe anlam" ayrıca tekrar edilmez.
- Kilit ekranı / küçük oynatıcı başlığında dil kısaltması (AR/TR/EN).

## 7. Kısıtlar

- ElevenLabs karakter kotası sınırlı; toplu üretimden önce sayı gösterilir.
- Ağ gerekir; çevrimdışıyken düğmeler pasif değil ama anlaşılır hata verir.
- ffmpeg yalnızca uzun metin birleştirmede gerekir (zaten kurulu).
- Mevcut testler korunur; yeni şema geçişi eski `content.db` üzerinde test edilir.
- Mobil `pubspec.yaml` asset listesine `assets/content/audio/tts/` eklenir (Flutter asset klasörleri özyinelemeli değil).

## 8. Uygulayıcıya bırakılanlar

- HTTP istemcisi (`package:http`), yeniden deneme (429 için bekleyip bir kez tekrar), zaman aşımı değerleri.
- Ayarlar sekmesinin görsel düzeni, ses listesinde dinleme önizlemesi (`preview_url` varsa).
- Hizalama eşlemesinde normalleştirme ayrıntıları (test edilmek şartıyla).
