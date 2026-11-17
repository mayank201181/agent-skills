# 4-Layer Grader & Content Audit Checklist

Every bug class below was caught on real production repositories across 6,500+ questions and 244,000+ fuzzed drill items. Enforce all of them during Phase 5 of `studyguide`.

## 1. Blind-Solver Protocol (`Layer 1`)
- Verify `scripts/blind-export.ts` and `scripts/blind-compare.ts` list the **exact** exam paper IDs in `lib/exam/` (never leave template IDs like `exam-n1` if the subject uses `exam-1` or `exam-r1`).
- Blind-solver subagents must **only** read `.audit-tmp/questions/*.json` — never `lib/topics/`, `lib/vocab/`, or `lib/exam/`.
- When comparing blind answers:
  - **Wrong key**: Fix `answerIndex` or `answer.value` AND update `explanation` / `solution`.
  - **Valid student phrasing rejected**: Widen `accept` or numeric `tolerance` (e.g., intermediate rounding, optional Spanish subject pronouns, Castilian/Latin American synonyms, Singapore vs Beijing Mandarin neutral tones & `一`/`不` sandhi, spaced vs unspaced Pinyin, historical title variants).
  - **Ambiguous stem or overlapping distractor**: Tighten the stem or replace the competing distractor so exactly **one** option is defensible.
  - **Prompt answer leaks**: Ensure worked format hints (`e.g. ...`) in the stem never accidentally give away the target answer.

## 2. Auto-Grader Hardening (`Layer 2`)
### Short-Answer Checker (`lib/answerCheck.ts`)
- **`displayAnswer` Self-Check**: Assert `checkAnswer(spec, displayAnswer(spec)) === "correct"` on 100% of `ShortQ`, `yourTurn`, and generated drill items inside `lib/validate.ts`. Strip domain units (`km²`, `m per year`, `Category 4`, `16th century`, `Article 48`, `19 元`) cleanly in numeric checks.
- **Word-by-Word Typo Forgiveness (`>= 6` chars) + Confusable Blocklist**:
  - Never compute edit distance across an entire multi-word string (`"Lagos, Nigeria"` vs `"Laos, Nigeria"` = 1 edit!). Check token-by-token, only allow 1-edit forgiveness on tokens of length `>= 6`, protect proper nouns ending in `s` (`Lagos`, `Laos`, `Paris`, `Andes`), and maintain a subject `CONFUSABLE_GROUPS` / `ANTONYM_PAIRS` blocklist (`Harald/Harold`, `Angkar/Angkor`, `corrasion/corrosion`, `insolation/insulation`, `hygrometer/hydrometer`, `bueno/malo`, `热/冷`, `买/卖`).
- **Sign & Operator Preservation**: Never strip `-`/`−` before digits into spaces (`-32` must not match `32`).

### Written Self-Grader (`lib/writtenCheck.ts`)
- **Non-Answer Filter**: Immediately return `0` marks for `""`, `"I don't know"`, `"idk"`, `"not sure"`, `"no sé"`, `"我不知道"`, or generic filler (`"makes the reader want to read on"`).
- **Stem-Copy & Extract-Copy Scrubber**: Strip contiguous `>= 4`-word verbatim spans copied from `q.question` (and any source extract) before matching keywords so pasting the prompt earns **0 marks**.
- **Short-Keyword Word Boundaries**: Keywords of length `<= 3` (`"now"`, `"men"`, `"sa"`, `"un"`) must use whole-word boundaries so `"I don't know"` never matches `"now"` and `"government"` never matches `"men"`; pure-punctuation keywords (`"¿"`, `"¡"`) match directly without alphanumeric word-boundary wrappers; strip inline markdown (`*`, `**`, `_`, `` ` ``) before matching.
- **Operator-Stripped `commonError` Guard**: Never put `"÷ 581"` as a keyword if punctuation stripping turns it into bare `"581"` (a number already in the stem!).

## 3. Shuffle-Safety (`McqCard`)
- `optionOrder()` permutes MCQ choices in the UI. Assert in `lib/validate.ts`:
  - `0` options matching `/\b(all|none) of the above\b/i` or `/\bboth [a-d] and [a-d]\b/i` or bare `["A","B","C","D"]`.
  - `0` explanations or hints matching `/\boption\s+[a-d]\b/i` or `/\b[Tt]he (first|second|third|fourth|last) (option|answer|choice)\b/` (case-insensitive!).

## 4. Sprint & Procedural Drills (`Layer 3`)
- **Preserve `tolerance` in `lib/sprint.ts`**: Always pass the full `AnswerSpec` (including `tolerance`) into `SprintRunner` so approximate dates/figures (`1069.5 ± 0.5`) accept `1069` and `1070`.
- **Vocab Sprint Grouping**: Never split verb glosses like `"he/she goes"` on unspaced `/`; filter out grammar frames (`voy a + infinitive`); group shared English prompts so all valid target-language synonyms pass.
- **Standalone Context**: Every drill/question pulled into Mixed Sprint, Daily 5, or Spaced Review must include enough context (country/period/table/diagram) to be answered standalone.
