# Reusing a Site's Prior Mappings

When a site supplies mappings from an earlier round, reuse takes priority over re-derivation. Stability matters more than your own judgment here: a category that silently changes between ETL runs breaks longitudinal data and downstream cohort definitions.

## Accepted input formats

Prior mappings arrive as another sheet in the workbook, a separate file, or pasted text. Accept any of these:

1. **Canonical clif_vocab format** (most common — the consortium exchange format, and what this skill produced last time): `<var>_category, <var>_name, n, site`. Ignore the old `n` and `site` values; the current run's counts win.
2. **Any two columns that clearly hold a raw name and a category.** Identify them by header (`med_name` + `med_category`) or by content (one column matches vocab categories, the other holds raw EHR strings). If a file has several candidate column pairs, ask which to use rather than guessing.
3. **A previous run's review-columns export**, which additionally carries `mapping_confidence`, `mapping_source`, and `mapping_note`. Ignore the old confidence and source values — recompute both — but read old `mapping_note` text for context on judgment calls.

If the prior file's categories belong to a different CLIF variable than the one you are mapping (e.g., a lab mapping supplied for a medication column), stop and tell the user; do not partially apply it.

## Matching rules

Match each unique raw value from the current data against the prior mapping in this order:

1. **Exact string match** → reuse, `mapping_source = prior_mapping`.
2. **Normalized match** — trim leading/trailing whitespace, collapse internal runs of whitespace, compare case-insensitively → reuse, `mapping_source = prior_mapping`, and note the difference (e.g., "matched prior mapping ignoring case"). Keep the *current* data's spelling in the `<var>_name` column; the site's raw strings are the record.
3. **No match** → map from scratch per Step 3, `mapping_source = new_mcide`.

Do not fuzzy-, substring-, or semantically match against prior mappings. "NOREPINEPHRINE 8 MG/250 ML" and "NOREPINEPHRINE 4 MG/250 ML" are different strings and the second is a new mapping — it may well deserve the same category, but that determination is a fresh mapping decision with its own confidence, not inherited provenance.

## Confidence on reused rows

- A reused mapping that is still valid gets `mapping_confidence = high` and `needs_review = FALSE` — it was reviewed by the site already.
- **Exception, and it takes precedence:** if a Step 4 disambiguation rule fires against a reused row (unit mismatch, unresolved specimen, additive product, wrong-table row), set `needs_review = TRUE` anyway and explain why in the note. Reuse suppresses redundant review, never a live data-quality signal. Keep the prior category and leave confidence at `high`; the flag is about the finding, not about doubting the mapping.
- A row marked `prior_mapping_retired` gets its confidence derived fresh, exactly as if it were a new mapping (Step 3's ladder), and always `needs_review = TRUE`.
- If the prior category is `no_match`, do not treat that as settled — re-attempt the mapping, since the vocabulary may have gained a category since. Either way the outcome is a fresh decision, so `mapping_source = new_mcide`:
  - You now find a defensible category → map it, flag it for review, note that it was previously unmapped.
  - It is still `no_match` → leave it unflagged beyond the usual `none`/`TRUE` treatment, and do not re-report it as news.

## Prior categories that are no longer valid

Check every reused category against the current vocab CSV. If it is absent (retired, renamed, or merged — mCIDE evolves):

- Remap the raw value from scratch per Step 3.
- Set `mapping_source = prior_mapping_retired` and `needs_review = TRUE`.
- Note both values: "prior category `glucose_serum` no longer in mCIDE; remapped to `glucose`".
- List every one of these in the Step 6 report — this is exactly the signal a site needs when upgrading mCIDE versions, and it is often a systematic change affecting many rows.

## When you disagree with a prior mapping

If a valid prior mapping contradicts what you would have chosen (including when a Step 4 disambiguation rule fires against it — say the dose unit conflicts with the prior category):

- **Keep the prior mapping.** Do not overwrite it.
- Set `needs_review = TRUE` and state the disagreement plainly in `mapping_note`: "prior mapping `dextrose_5_water`; dose unit and name suggest `dextrose_10_water` — please confirm".
- Surface these in the report as a distinct group. The site decides, not you.

## Prior entries absent from current data

Raw names in the prior mapping that do not appear in the current extract are usually discontinued formulary items. Do not add them to the output. Report the count, and list them only if there are few (≤10) or the user asks.

Before dismissing them, give each a quick sanity check against the vocab — a wrong mapping that happens to be dormant is invisible otherwise, and this file becomes the input to the next round, where the item may reappear and be reused silently. Call out any entry whose category is retired or clearly does not match its raw name (e.g., `DESMOPRESSIN 4 MCG/ML IV` mapped to `vasopressin` — a different drug), and recommend re-review rather than reuse if it returns.
