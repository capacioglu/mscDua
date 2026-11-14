# Çeviri alışverişi (Editör ↔ Claude)

1. Editörde **"Çeviriye gönder"** → `content/translation/pending.json` yazılır.
2. Kullanıcı Claude'a "çevirileri yap" der. Claude `pending.json`'u okur, `content/translation/done.json` yazar.
3. Editörde **"Çevirileri içe aktar"** → alanlar dolar; kullanıcı gözden geçirip onaylar.

## pending.json (`dualarim.translation.pending/1`)

```json
{"format":"dualarim.translation.pending/1","generated_at":"<ISO>",
 "duas":[{"dua_id":"DUA-0006","title_tr":"...","variant_of":null,"quran_reference":"20:25-28",
   "source":{"pronunciation_tr":"...","pronunciation_en":"...","meaning_tr":"...","meaning_en":"..."},
   "segments":[{"segment_id":41,"position":0,"text_ar":"...",
     "pronunciation_tr":"...|null","pronunciation_en":"...|null","meaning_tr":null,"meaning_en":null,"review":"none"}]}]}
```

`source`: arşivdeki dua bazlı (tüm duanın) okunuş ve anlamları. `segments`: satırlar ve şu anki alanları.

## done.json (`dualarim.translation.done/1`)

```json
{"format":"dualarim.translation.done/1",
 "segments":[{"segment_id":41,"text_ar":"<pending'deki ile birebir aynı>",
   "pronunciation_tr":"...","pronunciation_en":"...","meaning_tr":"...","meaning_en":"..."}]}
```

Editörün uyguladığı kurallar: `text_ar` farklıysa satır uygulanmaz; onaylı satıra ve kullanıcının düzelttiği alana dokunulmaz; boş/null alan atlanır; dört zorunlu alan (okunuş TR, anlam TR, anlam EN) doluysa satır "gözden geçirilecek", değilse "çeviri bekliyor" olur.

## Claude için kurallar

- **Arapça metne asla dokunma.** `text_ar`'ı pending'den birebir kopyala.
- **Hizalama:** `source` metinlerini satırlara böl; her satırın okunuşu ve anlamı **yalnızca o satırın Arapçasının** karşılığı olmalı. Satırların birleşimi `source` anlamının tamamını kapsamalı; ekleme ya da yorum yapma.
- Satırda zaten dolu olan okunuşları (içe aktarımdan gelen) koru; yalnız eksikleri yaz. Eksik okunuşu `source` metninin ilgili parçasından al.
- `source` boşsa (yeni dua) çeviriyi sıfırdan yap.
- **Türkçe okunuş üslubu** arşivdekiyle aynı: uzatmada şapka (`â î û`), `ğ` ile gayın, kelime birleşmelerinde tire (`fid-dünyâ`, `alel-kavmil-kâfirîn`), kesme işareti `'` (ayn/hemze). Örnek: `Rabbenâ âtinâ fid-dünyâ haseneten`.
- **İngilizce okunuş**: arşivdeki sade ASCII + `'` üslubu (`Rabbana atina fid-dunya hasanatan`).
- **Anlamlar**: arşivdeki meal üslubu; Türkçe "Rabbimiz!", "Allah'ım!" hitapları; İngilizce "Our Lord," / "O Allah,".
- Çoğul varyantlarda (`variant_of` dolu) anlamı çoğul kişiyle ver ("bize", "us").
