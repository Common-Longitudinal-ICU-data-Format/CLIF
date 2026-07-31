# CLIF Claude Skills

## mcide-mapper

A [Claude Agent Skill](https://support.claude.com/en/articles/12512180-use-skills-in-claude) that helps CLIF sites map raw EHR names (medication names, lab names, vitals, devices, organisms, …) in Excel to standardized [mCIDE](https://clif-icu.com/mCIDE) `*_category` values. It bundles all mCIDE controlled vocabularies from this repository (see the `VERSION` file inside the zip for the vocabulary snapshot date), maps each unique raw name with a confidence level, flags rows that need human review, and writes the consortium-standard `clif_vocab_<table>_<variable>_<site>` mapping sheet.

### Install

1. **Download [`skills/mcide-mapper.zip`](mcide-mapper.zip) from this repository.** On GitHub, open the file and click the download button; you do not need to clone the repo or run anything. The zip always carries the mCIDE vocabularies as of its last build — check the `VERSION` file inside it, or ask Claude, which reports the version with every mapping.
2. On [claude.ai](https://claude.ai): **Settings → Capabilities → Skills**, then **+ → Create skill**, and select the zip. Make sure the skill is toggled on. (Team/Enterprise users: an org admin may need to enable custom skills first.)
3. That's it — skills enabled on claude.ai are automatically available in the [Claude for Excel](https://support.claude.com/en/articles/12650343-use-claude-for-excel) add-in. Requires a Pro, Max, Team, or Enterprise plan. If the add-in was already open, close and reopen the Claude sidebar so the new skill appears under `/`.

Re-download and re-upload the zip when the mCIDE vocabularies change — Claude only knows the categories bundled in the copy you uploaded.

### Use in Excel

1. Open your workbook with the raw names (e.g., a `med_name` column, ideally with a dose-unit column alongside) and open the Claude for Excel sidebar.
2. Ask naturally, for example:
   > Map column B to mCIDE med_category for medication_admin_continuous

   Adding `, site = <your short name>` is optional — it only fills the `site` column and the sheet name, which matter when mapping files are pooled across sites. Leave it out and Claude writes `SITE`, which you can find-and-replace later.
   If the skill doesn't trigger automatically, type `/` and pick **mcide-mapper**.
3. Claude appends review columns (`<var>_category`, `mapping_confidence`, `needs_review`, `mapping_note`) and creates a `clif_vocab_...` mapping sheet.
4. **Review before use in ETL**: filter `needs_review = TRUE`, have a clinician or data manager correct those rows, then export the mapping sheet.

### What Claude does, step by step

**1. Identifies the target variable.** Works out which CLIF table and category variable your column represents, then looks it up in a bundled index of all 68 vocabulary files and opens only the one it needs. Files that aren't mapping targets (code lists, group lookup aids) are excluded. If the choice is genuinely ambiguous — continuous vs. intermittent medications, which have different category sets — it asks rather than guessing.

**2. Collects the raw values.** Deduplicates to unique names and works out `n` for each: carried through if your sheet has a count column (under any name), summed if a name appears on several counted rows, counted directly otherwise, and `1` only for a deduplicated list with no counts. It also notes companion columns — dose units, specimen, result units — for step 4.

**3. Loads your prior mapping,** if you have one. See [Reusing mappings you've already done](#reusing-mappings-youve-already-done).

**4. Maps each unique name through a five-layer cascade,** stopping at the first hit:

| Layer | Match | Result |
|---|---|---|
| 1 | Exact match in your prior mapping | reused · `prior_mapping` · high |
| 2 | Same, ignoring case and whitespace | reused · `prior_mapping` · high |
| 3 | Exact match to an mCIDE category or one of its listed examples | `new_mcide` · high |
| 4 | Clinical reasoning — synonyms, brand→generic, formulation | `new_mcide` · medium at best |
| 5 | Nothing defensible | `no_match` · none |

Only layer 4 requires real reasoning; layers 1–3 are string comparison, which is why a good prior mapping makes a re-run cheap. Layers 1 and 2 hit only if the prior category still exists in current mCIDE — if it was retired, renamed, or merged, the name is re-derived from layer 3 and marked `prior_mapping_retired` for review. Claude reports how many names settled at each layer, so you can see at a glance whether your prior mapping is being matched.

**5. Applies domain-specific rules** for labs and medications. `lab_category` isn't unique — the same analyte appears for different specimens — so specimen and unit columns pick the right row, and specimen-ambiguous analytes are flagged when you have no specimen column. For medications, dose units are cross-checked against the vocabulary's expected units.

**6. Writes two outputs.** Review columns appended to your sheet (`<var>_category`, `mapping_confidence`, `mapping_source`, `needs_review`, `mapping_note`), and a `clif_vocab_<table>_<variable>_<site>` sheet in the consortium exchange format. Rows needing review get a yellow fill. Your original columns are never modified or reordered.

**7. Reports** confidence and cascade-layer counts, prior-mapping statistics, every `no_match` and flagged row with its reason, systematic issues it noticed, and the mCIDE version used.

Throughout: a category is only ever emitted if it appears verbatim in the bundled vocabulary, unmatched names become `no_match` rather than a forced guess, and `needs_review` is `TRUE` for anything low-confidence *or* wherever a disambiguation rule fired — even at high confidence, even on a reused row.

### Reusing mappings you've already done

If you mapped this variable before, give Claude your previous mapping file (or point it at an existing `clif_vocab_*` sheet in the workbook):

> Map column B to mCIDE med_category for medication_admin_continuous, site = RUSH. We already mapped most of these last year — the old mapping is in the `clif_vocab_med_cont_med_RUSH` sheet.

Names that match a prior mapping keep their existing category and are marked `mapping_source = prior_mapping`; only genuinely new names get mapped fresh, as `new_mcide`. If a category you used previously has since been retired from mCIDE, the row is remapped, marked `prior_mapping_retired`, and flagged so you can see exactly what the vocabulary change did to your data. Claude never silently overwrites a prior mapping it disagrees with — it keeps yours and flags the disagreement for you to decide.

Prior mappings can be in the canonical `clif_vocab` format or any sheet with a raw-name column and a category column.

### Getting a fast, uninterrupted run

Claude infers anything you leave out, and asks when it can't. Naming these up front avoids both, in rough order of value:

1. **The table and variable** — `discharge_category for the hospitalization table`.
2. **Where your prior mapping is** — the biggest lever on a re-run; it decides whether names are reused or re-derived from scratch.
3. **Which column holds the raw names, and which holds counts** — selecting the column covers the first half.
4. **Companion columns for disambiguation** — for labs, where specimen and result units live; for medications, the dose-unit column. This mostly saves *review* time: without a specimen column, every specimen-ambiguous lab comes back flagged.
5. **That the list is already deduplicated**, if it is.
6. **Your site short name**, to avoid a `SITE` placeholder you replace later.

All together:

> map column A to mCIDE lab_category for the labs table, site = UCMC. Specimen is in column C and result units in column D. Column E has the counts and the list is already deduplicated. Prior mapping is in the `labs_old` sheet.

**Bigger than any wording:** pre-aggregate first. Effort scales with the number of *unique* names, not rows. A pivot turning 200,000 administrations into 400 distinct names with counts does more for runtime than any prompt, and gives you the count column the output wants anyway.

Tips:
- For labs, include specimen and result-unit columns — several mCIDE lab categories are distinguished only by specimen (e.g., serum vs urine albumin).
- Continuous infusions and intermittent administrations use different category sets; map them separately.
- The `clif_vocab_...` sheet from each run is the input for your next run — keep it.

### Notes for maintainers

- **`mcide-mapper.zip` is committed on purpose** so sites can download it straight from GitHub. It goes stale the moment `mCIDE/` changes, so after any vocabulary edit run `./skills/build_skill.sh` and commit the updated zip in the same PR.
- `./skills/build_skill.sh --check` reports whether the committed zip matches the current sources and exits non-zero if not — useful before tagging a release. The version string is `<build date>+<content hash>`, and the hash covers only the mCIDE CSVs and the hand-written skill docs, so unrelated commits never mark the zip stale. Rebuilds skip repackaging when nothing changed, keeping the binary out of the diff (`--force` overrides).
- `skills/mcide-mapper/vocab/`, `reference/INDEX.md`, and `VERSION` are **generated** by `build_skill.sh` from `mCIDE/` — never edit them by hand; rerun the build after any mCIDE change.
- Hand-written skill content: `SKILL.md`, `reference/output-format.md`, `reference/disambiguation.md`, `reference/prior-mappings.md`. The step-by-step description above mirrors `SKILL.md` — update both together.
- `*.xlsx` is gitignored in this repo, and site mapping files can contain site-specific strings — share them per consortium policy, not by committing here.
