# BJJ Admin

Back-office management system for Brazilian jiu-jitsu academies. Handles students, health records, plans, enrollments, payments, and overdue billing — without the fluff.

## Features

- **Student management** — register students with belt, status, emergency contacts, and a digital health record (LGPD-compliant with consent signature)
- **Plans & enrollments** — define recurring plans and enroll students; expired enrollments are cancelled automatically
- **Payments** — track manual payments, mark overdue, and send reminder emails via background jobs
- **Multi-user with roles** — `owner` (full access) and `teacher` (students + health records only)
- **Self-registration** — public form at `/public/:academy_slug` so students can sign up on their own
- **PWA-ready** — installable on mobile (manifest, service worker, offline page, all icon sizes)

## Tech stack

| Layer | Technology |
|---|---|
| Framework | Ruby on Rails 8.1 |
| Database (dev) | SQLite 3 |
| Database (prod) | PostgreSQL |
| Auth | Devise |
| Authorization | Pundit |
| Frontend | Hotwire (Turbo + Stimulus) |
| CSS | Tailwind CSS |
| Background jobs | Solid Queue |
| Assets | Propshaft |
| File uploads | Active Storage |
| PDF | Prawn + prawn-table |
| Pagination | Pagy |
| Tests | RSpec + FactoryBot |

## Getting started

**Requirements:** Ruby 3.3+, Bundler

```bash
git clone https://github.com/isaaclvs/bjj-admin-core.git
cd bjj-admin-core

bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000) and sign in with the seeded credentials.

To also run background jobs:

```bash
bin/rails solid_queue:start
```

Or with Foreman (runs both in one terminal):

```bash
foreman start
```

## Running with Docker

**Requirements:** Docker + Docker Compose

```bash
cp .env.example .env
# Fill in POSTGRES_PASSWORD and RAILS_MASTER_KEY (content of config/master.key)

docker compose up --build
```

The stack starts three services:

| Service | Description |
|---|---|
| `db` | PostgreSQL 16 |
| `web` | Rails app + Thruster (HTTP/2 proxy) on port 80 |
| `worker` | Solid Queue background job processor |

On first boot, `web` runs `db:prepare` automatically (creates schema and runs migrations).

To seed initial data:

```bash
docker compose exec web bin/rails db:seed
```

## Environment variables

| Variable | Default | Description |
|---|---|---|
| `RAILS_MASTER_KEY` | — | **Required.** Contents of `config/master.key` |
| `POSTGRES_PASSWORD` | — | **Required.** Password for the `bjj_admin` DB user |
| `DATABASE_URL` | set by compose | PostgreSQL connection string (override if using external DB) |
| `MAILER_FROM` | `no-reply@bjjadmin.com.br` | Sender address for outgoing emails |
| `PORT` | `80` | Host port mapped to the web container |

## Role permissions

| Resource | owner | teacher |
|---|---|---|
| Student — index, show | ✓ | ✓ |
| Student — create, update, destroy | ✓ | ✗ |
| Health record — show | ✓ | ✓ |
| Health record — create, update | ✓ | ✗ |
| Plans, Enrollments, Payments | ✓ | ✗ |
| Users, Academy settings | ✓ | ✗ |

## CI pipeline

Every push to `main` and every pull request runs:

- **RSpec** — model, policy, query, and request specs
- **Brakeman** — static security analysis
- **bundler-audit** — known CVEs in gems
- **importmap audit** — known CVEs in JS packages
- **RuboCop** — code style

## Project structure

```
app/
├── models/
│   └── concerns/        # AcademyScoped, RiskAssessable
├── controllers/
│   ├── concerns/        # AcademyContext
│   └── public/          # unauthenticated self-registration
├── policies/            # Pundit — one file per model
├── queries/             # query objects
├── jobs/                # PaymentReminderJob, ExpiredEnrollmentsJob
└── javascript/
    └── controllers/     # Stimulus — one behaviour per file
```

## License

MIT
