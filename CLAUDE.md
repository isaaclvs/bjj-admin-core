# CLAUDE.md — BJJ Admin Core

Este arquivo define as diretrizes, convenções e contexto do projeto para o Claude Code.
Leia este arquivo antes de qualquer tarefa.

---

## O que é este projeto

SaaS para gestão administrativa de academias de jiu-jitsu brasileiro.
Foco exclusivo no backoffice da academia — sem app do aluno, sem presença, sem agendamento.

Funcionalidades do MVP:
- Cadastro de alunos com ficha de saúde digital (LGPD + termo de responsabilidade)
- Gestão financeira (planos, matrículas, pagamentos, inadimplência)
- Alertas automáticos de cobrança
- Multi-usuário com roles (dono vs professor)

---

## Stack

| Camada | Tecnologia |
|--------|-----------|
| Framework | Ruby on Rails 8.0 |
| Banco (dev) | SQLite 3 |
| Banco (prod) | PostgreSQL |
| Auth | Devise |
| Autorização | Pundit |
| Frontend | Hotwire (Turbo + Stimulus) |
| CSS | Tailwind CSS via tailwindcss-rails |
| Jobs | Solid Queue (sem Redis) |
| Assets | Propshaft |
| Uploads | Active Storage |
| PDF | Prawn + prawn-table |
| Paginação | Pagy |
| Testes | RSpec + FactoryBot |

---

## Princípios — não negocie estes

### Rails Way
- Siga as convenções do Rails. Nunca crie abstrações para substituir o que o framework já faz.
- Controllers são RESTful. Se precisar de uma ação além das 7 padrão, provavelmente é um novo resource.
- Responda com `turbo_stream` em `create`, `update` e `destroy` além do `html`.
- Rotas resourceful. Evite rotas customizadas sem justificativa clara.

### Sandi Metz
- **100 linhas** por classe. Se passar, divida.
- **5 linhas** por método. Se passar, extraia.
- **4 parâmetros** por método. Se passar, use um objeto.
- Query objects em `app/queries/` para qualquer query com mais de um escopo encadeado.
- Concerns em `app/models/concerns/` para comportamentos compartilhados entre models.
- `tell don't ask`: prefira mandar mensagens a checar estado externamente.

### Chris Oliver / Hotwire
- Turbo Frames para escopo de formulários e listas parciais.
- Turbo Streams para atualizações cirúrgicas: `prepend`, `replace`, `remove`.
- Stimulus apenas quando JavaScript é estritamente necessário no cliente.
- Um comportamento por Stimulus controller.
- O servidor envia HTML. Evite endpoints JSON e fetch manual.

---

## Estrutura de pastas

```
app/
├── models/
│   ├── concerns/          # RiskAssessable, AcademyScoped
│   └── *.rb
├── controllers/
│   ├── concerns/          # AcademyContext
│   └── public/            # rotas sem autenticação (/form/:slug)
├── policies/              # Pundit — um arquivo por model
├── queries/               # query objects — um arquivo por query
├── jobs/                  # Solid Queue jobs
└── javascript/
    └── controllers/       # Stimulus — um comportamento por arquivo
```

---

## Convenções de código

### Models

```ruby
# Ordem dentro de um model:
# 1. includes de concerns
# 2. associations
# 3. enums
# 4. validations
# 5. scopes
# 6. callbacks
# 7. métodos públicos
# 8. métodos privados

class Student < ApplicationRecord
  include AcademyScoped

  belongs_to :academy
  has_one :health_record, dependent: :destroy
  has_many :enrollments, dependent: :destroy

  enum :belt, { white: 0, blue: 1, purple: 2, brown: 3, black: 4 }
  enum :status, { active: 0, inactive: 1, suspended: 2 }

  validates :name, presence: true

  scope :at_risk, -> { joins(:health_record).where(health_records: { risk_flag: true }) }

  # métodos públicos antes dos privados
end
```

### Controllers

```ruby
# Ordem dentro de um controller:
# 1. before_action
# 2. actions públicas (index, show, new, create, edit, update, destroy)
# 3. private
# 4. set_* (finders)
# 5. *_params (strong parameters)
# 6. outros métodos privados

class StudentsController < ApplicationController
  before_action :set_student, only: %i[show edit update destroy]

  def create
    @student = current_academy.students.new(student_params)

    if @student.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @student, notice: "Aluno cadastrado." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_student
    @student = current_academy.students.find(params[:id])
    authorize @student
  end

  def student_params
    params.require(:student).permit(:name, :cpf, :phone, :email, :belt)
  end
end
```

### Query Objects

```ruby
# Interface sempre: .new(academy, relation = Model.all).call
class OverduePaymentsQuery
  def initialize(academy, relation = Payment.all)
    @academy  = academy
    @relation = relation
  end

  def call
    @relation
      .joins(student: :academy)
      .where(academies: { id: @academy.id })
      .overdue
      .includes(:student)
      .order(:due_date)
  end
end
```

### Turbo Stream views

```erb
<%# app/views/students/create.turbo_stream.erb %>
<%= turbo_stream.prepend "students-list", partial: "students/student",
                                          locals: { student: @student } %>
<%= turbo_stream.update "students-count", @academy.students.active.count %>
```

### Stimulus controllers

```javascript
// Um comportamento por arquivo
// Nomes descritivos: filter_controller.js, signature_controller.js
// Sem lógica de negócio no JS — só comportamento de UI
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  static values  = { url: String }

  // métodos públicos primeiro
  // métodos privados com # no final
}
```

---

## Multi-tenant

Toda query deve ser escopada pela academia do usuário logado.

```ruby
# Nunca faça:
Student.find(params[:id])

# Sempre faça:
current_academy.students.find(params[:id])
```

O concern `AcademyContext` no `ApplicationController` define `current_academy` via `current_user.academy`.

---

## Autorização (Pundit)

Roles: `owner` (acesso total) e `teacher` (vê alunos e fichas de saúde, não acessa finanças).

| Resource | owner | teacher |
|----------|-------|---------|
| Student (index, show) | ✓ | ✓ |
| Student (create, update, destroy) | ✓ | ✗ |
| HealthRecord (show) | ✓ | ✓ |
| HealthRecord (create, update) | ✓ | ✗ |
| Payment (todos) | ✓ | ✗ |
| Plan (todos) | ✓ | ✗ |
| Enrollment (todos) | ✓ | ✗ |

Sempre chame `authorize @resource` nos controllers antes de operar.

---

## Banco de dados

### SQLite (dev) vs PostgreSQL (prod)

Arrays não existem no SQLite. Use `t.text` com `serialize :field, coder: JSON` nos models.

```ruby
# Migration:
t.text :comorbidities

# Model:
serialize :comorbidities, coder: JSON
```

### Valores monetários

Sempre armazene valores em centavos como `integer`. Nunca use `float` ou `decimal` para dinheiro.

```ruby
# Banco: amount_cents integer
# Model: expõe amount como helper
def amount
  amount_cents / 100.0
end
```

---

## Testes

Use RSpec com FactoryBot. Priorize testes de:
1. Models (validations, callbacks, scopes)
2. Query objects
3. Policies (Pundit)
4. System tests para fluxos críticos (cadastro de aluno, registro de pagamento)

```ruby
# Estrutura de factories
FactoryBot.define do
  factory :student do
    association :academy
    name  { Faker::Name.full_name }
    belt  { :white }
    status { :active }
  end
end
```

---

## O que NÃO construir no MVP

- App mobile ou PWA para o aluno
- Sistema de presença / check-in
- Controle de faixas e técnicas
- Agendamento de aulas
- Chat ou mensagens internas
- Integração com gateway de pagamento (PIX via QR code)
- Multi-tenancy por subdomínio (usar slug por enquanto)

---

## Comandos úteis

```bash
# Setup inicial
bin/rails db:create db:migrate db:seed

# Rodar servidor com jobs
bin/rails server
bin/rails solid_queue:start  # em outra aba, ou usar Foreman

# Testes
bundle exec rspec
bundle exec rspec spec/models/
bundle exec rspec spec/policies/

# Gerar migration
bin/rails generate migration AddRiskFlagToHealthRecords risk_flag:boolean

# Rodar jobs manualmente no console
PaymentReminderJob.perform_now
```
