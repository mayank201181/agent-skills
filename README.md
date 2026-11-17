# Reusable Agent Skills (`mayank201181/agent-skills`)

Cloud-portable skills for building verified interactive web dashboards from any device — laptop, iPad, or phone.

## Included Skill: `studyguide`
- **Manifest:** [`skills/studyguide/SKILL.md`](./skills/studyguide/SKILL.md)
- **4-Layer Audit Checklist:** [`skills/studyguide/references/grader-and-audit-checklist.md`](./skills/studyguide/references/grader-and-audit-checklist.md)
- **Cloud/Local Scaffolder:** [`skills/studyguide/scripts/scaffold-from-v2.sh`](./skills/studyguide/scripts/scaffold-from-v2.sh)
- **Ready-to-Upload `.zip` Package (for Gemini & Claude Web):**
  - Direct download: **`https://github.com/mayank201181/agent-skills/releases/latest/download/studyguide.zip`** (or [`dist/studyguide.zip`](./dist/studyguide.zip))

---

## How to Use Away from Your Laptop (Phone / iPad / Any Browser)

### 1. Google Gemini (`gemini.google.com`)
1. Download [`studyguide.zip`](https://github.com/mayank201181/agent-skills/releases/latest/download/studyguide.zip) on any device.
2. Open **https://gemini.google.com** → **Customize** → **Skills** → **Upload** → select `studyguide.zip` → **Save**.
3. Type `/studyguide` in Gemini on your phone or iPad to generate an instant interactive **Gemini Canvas** study guide & quiz app.

### 2. Google Jules (`jules.google` — Full GitHub + Vercel Cloud VM)
1. Open **https://jules.google** on your phone/iPad and select `mayank201181/agent-skills` (or your target subject repo).
2. Prompt Jules: *"Follow `skills/studyguide/SKILL.md` in `mayank201181/agent-skills` to scaffold, blind-audit, and push `<new-subject>`."*

### 3. Claude Web (`claude.ai` & `claude.ai/code`)
1. Upload [`studyguide.zip`](https://github.com/mayank201181/agent-skills/releases/latest/download/studyguide.zip) once under **Settings → Capabilities → Skills** on **https://claude.ai**.
2. Open **https://claude.ai/code** from your phone or iPad to build, blind-check, and push full Next.js + Vercel repositories in the cloud.

### 4. CLI / Antigravity / Local Install on Any New Machine
```bash
npx skills add mayank201181/agent-skills
```
