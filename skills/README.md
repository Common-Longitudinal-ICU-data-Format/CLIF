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
   > Map column B to mCIDE med_category for medication_admin_continuous, site = RUSH
   If the skill doesn't trigger automatically, type `/` and pick **mcide-mapper**.
3. Claude appends review columns (`<var>_category`, `mapping_confidence`, `needs_review`, `mapping_note`) and creates a `clif_vocab_...` mapping sheet.
4. **Review before use in ETL**: filter `needs_review = TRUE`, have a clinician or data manager correct those rows, then export the mapping sheet.

### Reusing mappings you've already done

If you mapped this variable before, give Claude your previous mapping file (or point it at an existing `clif_vocab_*` sheet in the workbook):

> Map column B to mCIDE med_category for medication_admin_continuous, site = RUSH. We already mapped most of these last year — the old mapping is in the `clif_vocab_med_cont_med_RUSH` sheet.

Names that match a prior mapping keep their existing category and are marked `mapping_source = prior_mapping`; only genuinely new names get mapped fresh, as `new_mcide`. If a category you used previously has since been retired from mCIDE, the row is remapped, marked `prior_mapping_retired`, and flagged so you can see exactly what the vocabulary change did to your data. Claude never silently overwrites a prior mapping it disagrees with — it keeps yours and flags the disagreement for you to decide.

Prior mappings can be in the canonical `clif_vocab` format or any sheet with a raw-name column and a category column.

Tips:
- For labs, include specimen and result-unit columns — several mCIDE lab categories are distinguished only by specimen (e.g., serum vs urine albumin).
- Continuous infusions and intermittent administrations use different category sets; map them separately.
- The `clif_vocab_...` sheet from each run is the input for your next run — keep it.

### Notes for maintainers

- **`mcide-mapper.zip` is committed on purpose** so sites can download it straight from GitHub. It goes stale the moment `mCIDE/` changes, so after any vocabulary edit run `./skills/build_skill.sh` and commit the updated zip in the same PR.
- `./skills/build_skill.sh --check` reports whether the committed zip matches the current sources and exits non-zero if not — useful before tagging a release. The version string is `<build date>+<content hash>`, and the hash covers only the mCIDE CSVs and the hand-written skill docs, so unrelated commits never mark the zip stale. Rebuilds skip repackaging when nothing changed, keeping the binary out of the diff (`--force` overrides).
- `skills/mcide-mapper/vocab/`, `reference/INDEX.md`, and `VERSION` are **generated** by `build_skill.sh` from `mCIDE/` — never edit them by hand; rerun the build after any mCIDE change.
- Hand-written skill content: `SKILL.md`, `reference/output-format.md`, `reference/disambiguation.md`.
- `*.xlsx` is gitignored in this repo, and site mapping files can contain site-specific strings — share them per consortium policy, not by committing here.
