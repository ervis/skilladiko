---
name: test-impact-rails
description: Rails/Ruby stack pack for /test-impact — vocabulary, entry points, invariants, test layers, flakiness fixes. Loaded by /test-impact when a Rails/Ruby project is detected.
---

# Test Impact — Rails/Ruby Stack Pack

**Stack pack**: concrete vocabulary the generic `/test-impact` skill loads when it detects a Rails or Ruby project. Not invoked directly — `/test-impact` loads it.

Detection signals (any one): `Gemfile` containing `rails`, `config/routes.rb`, `app/` + `config/` layout, `spec/` or `test/` dirs, `*.gemspec`, `Rakefile` with `RSpec`/`Minitest`.

When loaded, this pack replaces the generic terms in `/test-impact` with the Rails-specific ones below.

## Symbols & roles

- Public surface = public methods (instance, class, module), constants, public API.
- Roles: **instance method**, **class method**, **module method**, **constant**, **ActiveRecord scope**, **callback** (`before_save`, `after_commit`, …), **validation**, **side-effecting** (mailer, job, broadcast, cache write).
- Skip private/protected helpers unless they encode an invariant.

## Dependency tracing

Grep for callers:
- `#method_name` and `.method_name`
- `include ModuleName`, `prepend ModuleName`, `extend ModuleName`
- `def method_name` overrides (subclasses, modules)
- Scope usage: `Model.scope_name`

Mark direct vs transitive. A chain crosses a process/api boundary when it hits controller → service → model callback, or a job enqueued from one.

## Blast radius tiers

- **Tier 0 — Direct change**: the files/methods in the diff.
- **Tier 1 — Direct consumers**: controllers calling a service, services calling a model method, views calling a helper.
- **Tier 2 — Transitive consumers**: code depending on Tier 1, plus Rails integration points — routes, ActionMailers, ActiveJob/Sidekiq workers, ActionCable channels, Rake tasks, mounted engines.
- **Tier 3 — Boundary effects**: HTTP responses, persisted DB state, enqueued jobs, delivered mails, broadcasts, logs, cache writes, published events.

## Entry points

- Rails routes (controller actions) — `config/routes.rb` mappings
- Rake tasks / `bin/` scripts
- Mailers (ActionMailer) / jobs (ActiveJob, Sidekiq) / channels (ActionCable)
- Background jobs / cron / queue consumers
- Public API endpoints / mounted engines
- ActiveRecord callbacks triggered by persistence
- View helpers / partials rendered by controllers

Each entry point → candidate for a request spec, system spec, or job spec.

## Test layers

- **unit**: model spec, service spec, plain Ruby spec
- **integration**: request spec, mailer spec, job spec, channel spec
- **e2e**: system spec
- **contract**: API contract spec (e.g. Pact)
- **property**: property-based with `rantly`/`prop_check`

## Invariants (examples, never invent — cite `file:line`)

- soft-delete via `discarded_at` / `deleted_at`
- `paper_trail` version written on mutation
- idempotency of a job (no duplicate side effects on retry)
- uniqueness scope held (`validates :email, uniqueness: { scope: :account_id }`)
- audit trail written
- `touch`/counter cache consistency

## Flakiness isolations

- Time: `Timecop.freeze` / `travel_to` / `freeze_time`
- Randomness: stub `SecureRandom`, `rand`, `Array#sample`
- Network: WebMock / VCR
- Filesystem: `Dir.mktmpdir`, stub `File` writes
- External APIs: WebMock + recorded cassettes

## Test framework detection

- `spec/` dir + `Gemfile` → RSpec (propose `describe`/`it`/`expect`).
- `test/` dir + `Gemfile` → Minitest (propose `test "..." do ... assert`).
- Match the project's existing style; do not mix.

## Output example (fragment)

```markdown
## Change Inventory
| File | Change | Methods affected |
|------|--------|------------------|
| app/models/report.rb | modified | `Report#archive`, `Report.active` |
| app/services/reports/archiver.rb | new | `Reports::Archiver#call` |

## Dependency Map
### `Report#archive` (app/models/report.rb:42)
- Direct callers:
  - `app/services/reports/archiver.rb:18` — `Reports::Archiver#call`
- Transitive:
  - `app/jobs/archive_report_job.rb:7` — `ArchiveReportJob#perform`

## Entry Points
- `PATCH /reports/:id/archive` — `app/controllers/reports_controller.rb:24` — `archive`
- `ArchiveReportJob` — `app/jobs/archive_report_job.rb:5`
- `ReportMailer#archived` — `app/mailers/report_mailer.rb:10`

## Invariants at Risk
- Invariant: soft-delete via `discarded_at` — enforced at `app/models/report.rb:12` — change may [preserve|break] it
- Invariant: `paper_trail` version written on archive — implied at `app/models/report.rb:3` — change may [preserve|break] it

## Proposed Test Cases

### TC-01 — archives a persisted report
- **Layer**: model spec (unit)
- **Target**: `Report#archive` (`app/models/report.rb:42`)
- **Given**: a persisted `Report` with `discarded_at: nil`
- **When**: `report.archive`
- **Then**: `report.discarded_at` is set and `report.reload` persists the change
- **Covers**: Tier 0, invariant "soft-delete via discarded_at"
- **Priority**: critical
- **Type**: happy
```

## Handoff wording

"Test cases documented in `test-impact.md`. Next: implement the cases (model/request/system specs), or run `/qrspi-plan` to fold them into the plan."