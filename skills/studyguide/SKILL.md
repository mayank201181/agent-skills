---
name: studyguide
description: >-
  End-to-end builder for interactive school study-guide and question-bank web dashboards
  (any year group, curriculum, or subject: Maths, Science, Humanities, English, Languages,
  Computer Science, etc.). Scaffolds a Next.js 16 + TypeScript + Tailwind v4 app with
  zero-login local iPad progress persistence, a persistent bottom navigation dock across all
  screen sizes, AoPS discovery-first lessons, interactive explorables, procedural skill drills,
  Daily 5, 60s Fluency Sprints, a global Sitcom TV hub + per-topic Watch episodes, mandatory
  4-layer blind-solver & adversarial grader cross-checking, and Vercel deployment.
---

# Study Guide & Question Bank Builder (`studyguide`)

Use this skill whenever the user asks to create, expand, or audit a web-based study guide and
question bank dashboard for a school subject and year group — without needing to copy or
reference an old subject repo manually.

## 1. Intake (Batch into 1 Short Question Set Only If Unspecified)
1. **Subject, Year Group & Curriculum/Syllabus** (e.g., Tanglin Year 8 Computer Science, IGCSE Physics, KS3 French — extract topics directly if a curriculum PDF/image is provided).
2. **Watch / Animated Sitcom Season**: Confirm whether to generate and render local narrated Watch-tab sitcom episodes (1 per topic via Kokoro neural TTS + `static-ffmpeg`).
3. **Target GitHub Repo & Launcher**: Confirm target repo under `mayank201181/<repo>` (and whether to add a card to a launcher repo like `Year8allsubjects`).

## 2. Core UX & Architecture Standards (Non-Negotiable Defaults)
- **Stack**: Next.js 16 (App Router) + React 19 + TypeScript 5 + Tailwind CSS 4.
- **Zero-Login Open Access + Automatic iPad `localStorage` Persistence**:
  - **Never block learners behind a login/password screen on launch.** `StoreProvider` (`lib/store.tsx`) must boot directly into local device storage (`loadGuest()`) whenever no active cloud cookie exists (including when offline).
  - Every star, streak, daily goal, read guide section, **in-progress quiz/paper state (`saveAttempt`: current question index, selected option, typed draft, unlocked hints)**, skill mastery, spaced-repetition queue (`[1, 3, 7, 16, 35]` days), and watched episode saves synchronously to `localStorage` so closing Safari or getting distracted on an iPad never loses progress.
  - Keep optional cloud sign-in / PIN parent dashboard tucked discretely inside the top-right profile menu (`☁️ Sign in / create account`) for families who opt into Vercel Blob sync.
- **Persistent Bottom Navigation Dock (All Screen Sizes — Mobile, Tablet & Desktop)**:
  - Render a fixed bottom dock (`fixed inset-x-0 bottom-0`, **never `md:hidden`**) with `<main className="... pb-28">` clearance and floating mascots positioned at `bottom-20`:
    `🏠 Home (/) · 📚 Topics (/topics) · 🎬 Watch (/watch) · 📺 Sitcom (/episodes) · 🎯 Daily 5 (/daily) · 🔁 Review (/review) · 📈 Progress (/progress)`
  - Also surface `📺 Sitcom` (`/episodes`) and `🎬 Watch` (`/watch`) in the top header bar on both narrow and wide viewports so the all-episodes binge hub is always one tap away.
- **Fast Scaffolding (Laptop OR Cloud VM — Zero Laptop Needed)**:
  - Run [scaffold-from-v2.sh](./scripts/scaffold-from-v2.sh) `<new-repo-dir>` (uses local `/Users/mayankrawat/Downloads/year8-workspace/Year8geography` if available, or automatically runs `git clone --depth 1 --filter=blob:none https://github.com/mayank201181/Year8geography.git` when running in a Cloud VM such as Google Jules `jules.google` or Claude Web `claude.ai/code`; pass `https://github.com/mayank201181/Year8chinese.git` as 2nd arg for language subjects) to copy ONLY the hardened engine skeleton (~300 KB, stripping `.mp4` videos and old subject topics/READMEs so zero old subject icons or exam IDs leak).
- **Gemini Web / Mobile Canvas Fallback (`gemini.google.com` without a Cloud VM)**:
  - When invoked inside `gemini.google.com` chat/mobile (where shell/GitHub VM tools are unavailable), generate a complete, self-contained **Gemini Canvas** single-file React + Tailwind interactive study-guide & question-bank app featuring the same AoPS discovery lessons, inline SVGs, interactive parameter-driven explorable widget, shuffled MCQs (zero `"All/None of the above"` or `"Option A"` traps), hardened short-answer & written self-grader, zero-login `localStorage` persistence, and the persistent bottom navigation dock (`Home · Topics · Daily 5 · Review · Progress`), verifying 100% of answer keys cold before outputting.

## 3. Pedagogy & Content Depth (AoPS Discovery Style)
- **Lessons (`lib/topics/<id>/guide.ts`)**:
  - 4–5 sections per topic. Every section opens with a `discovery` puzzle (*Try this first*), followed by clear explanation (*derive, don't decree*), inline accessible `<svg>` diagram (`viewBox`, `role="img"`, `aria-label`, no `${` or backticks), worked example, auto-marked `yourTurn` check, `whyItWorks`, `strategies`, and `LearnSmart` flashcards + common exam traps.
- **Question Bank (`mcq.ts`, `practice.ts`) & Big Exam (`lib/exam/`)**:
  - Globally unique question IDs (`<topic>-m1-q01`, `<topic>-p1-q01`, `<topic>-ch-q01`).
  - Per topic: Quick Quiz (10 Qs), 3 MCQ Papers (15 Qs each), 2–3 Practice Papers (auto-marked short answers + self-marked extended responses), and an 8–10 question **Challenge Set** (`warmup` / `core` / `challenge` tiers + 3-step `hints` ladders).
  - Cross-topic **Big Exam**: 3–4 full papers in `lib/exam/`.
  - Standalone safety: every question must embed any table/diagram/extract it needs so it works standalone in **Daily 5** and **Spaced Review** (never write *"Use the table in the previous question"*).
- **Procedural Skill Drills (`lib/drills/<id>.ts`) & 60s Sprint (`lib/sprint.ts`)**:
  - Unlimited seeded generators across 3 difficulty tiers per topic skill + 60-second Fluency Sprint.
- **Interactive Explorables (`components/widgets/<id>.tsx`)**:
  - 1–2 genuine parameter-driven interactive widgets per topic (change sliders/steppers/inputs → live visual & calculated output).
- **Subject-Specific Adaptations**:
  - **Maths / Science**: Equivalent-form numeric/fraction/expression parser, unit stripping (`m/s`, `km²`, `%`), tolerance preservation in both drills and Sprint.
  - **Humanities (History / Geography)**: Source provenance (NOP), timeline/key-terms reference sheet, PEEL mark schemes, Roman-numeral & confusable-proper-noun guards.
  - **Languages (Spanish / Mandarin / French / Latin)**: Dedicated **Vocab Tab** (~800–1,000 items) with Web Speech audio (`🔊` normal + `🐢` slow), on-screen accent/Pinyin tone keypad, accent/tone-slip `"close"` nudge instead of harsh fail, sandhi/regional pronunciation tolerance, and verb/grammar sheet.

## 4. Animated Watch-Tab & Sitcom Season Pipeline
- Author 1 funny, curriculum-exact episode per topic (`scripts/sitcom/episodes/<topic>.py`) with 3 interactive pause challenges, recurring cast, chalkboard/whiteboard visual beats, and synthesized audio via local Python 3.12 `uv` virtualenv (`kokoro-onnx` + `misaki` + `static-ffmpeg`).
- Render `.mp4` + poster `.jpg` into `public/videos/` and generate `lib/sitcom.ts` so every episode appears both on `/topic/<id>?tab=watch` AND together on `/episodes` (`📺 Sitcom` binge hub) and `/watch`.

## 5. Mandatory 4-Layer Blind-Solver & Adversarial Grader Audit
**Never ship generated questions without completing all 4 verification layers.** Read [grader-and-audit-checklist.md](./references/grader-and-audit-checklist.md) and execute:
1. **Layer 1 — True Blind Solving**: Export all `mcq` + `short` questions stripped of `answerIndex`, `answer` values, `explanation`, and `hints` (`scripts/blind-export.ts`). Dispatch isolated blind-solver subagents (forbidden from reading `lib/topics/` or `lib/exam/`) to solve cold from first principles. Diff with `scripts/blind-compare.ts` and resolve 100% of disagreements until agreement = **100.0%**.
2. **Layer 2 — Adversarial Grader & Shuffle-Safety Falsification**:
   - **MCQs**: `0` `"All/None of the above"` or `"Both A and B"`, `0` duplicate options, `0` case-insensitive positional/letter refs (`Option A`, `The first option`) in `explanation` or `hints`.
   - **Short Answers**: `checkAnswer(spec, displayAnswer(spec))` must return `"correct"` on **100%** of static questions, `yourTurn` checks, and generated drills; word-by-word typo forgiveness (`>= 6` chars) + `CONFUSABLE_GROUPS` must block 1-edit false positives (`Harald/Harold`, `corrasion/corrosion`, `热/冷`, etc.).
   - **Written QAs (`lib/writtenCheck.ts`)**: `100%` of `modelAnswer`s score full marks; pasting `q.question` verbatim scores **0**; `"I don't know"` / `"idk"` / `"no sé"` / `"我不知道"` scores **0**; short keywords (`<= 3` chars) enforce whole-word boundaries.
3. **Layer 3 — Drill & Sprint Fuzzing**: Fuzz **200+ seeds × 3 tiers** per drill + all Sprint modes (`0` crashes, `0` synonym collisions, `tolerance` preserved in Sprint).
4. **Layer 4 — Build & Test Gate**: `npm run gen && npm run validate && npm test && npm run lint && npm run build` must pass with **0 errors**.

## 6. Git & Vercel Deployment Rules
- Before committing, always set the Vercel-authorized git author:
  ```bash
  git config user.name "mayank201181"
  git config user.email "mayank2011@gmail.com"
  ```
- Push cleanly to `origin main` (ensure `.audit-tmp/`, `scripts/sitcom/out/`, `tts_cache/`, and `__pycache__/` are gitignored/removed).
- Verify GitHub commit status (`gh api repos/mayank201181/<repo>/commits/main/statuses`) reaches `success` and live URL returns `HTTP 200`, then add/enable the subject card in `Year8allsubjects` (or corresponding launcher repo) if applicable.
