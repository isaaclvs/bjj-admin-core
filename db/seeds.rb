# Seeds para desenvolvimento
# Execute: bin/rails db:seed

puts "Criando academia..."
academy = Academy.find_or_create_by!(slug: "academia-demo") do |a|
  a.name = "Academia Demo BJJ"
end

puts "Criando usuários..."
owner = User.find_or_create_by!(email: "dono@demo.com") do |u|
  u.password = "password123"
  u.role     = :owner
  u.academy  = academy
end

teacher = User.find_or_create_by!(email: "professor@demo.com") do |u|
  u.password = "password123"
  u.role     = :teacher
  u.academy  = academy
end

puts "Criando planos..."
plano_mensal = academy.plans.find_or_create_by!(name: "Plano Mensal") do |p|
  p.price_cents = 15000
  p.interval    = :monthly
  p.description = "Treinos ilimitados durante o mês"
  p.active      = true
end

plano_trimestral = academy.plans.find_or_create_by!(name: "Plano Trimestral") do |p|
  p.price_cents = 40000
  p.interval    = :quarterly
  p.description = "3 meses com desconto"
  p.active      = true
end

puts "Criando alunos..."
belts   = %w[white blue purple brown black]
statuses = %w[active active active inactive]

10.times do |i|
  student = academy.students.find_or_create_by!(name: "Aluno #{i + 1}") do |s|
    s.cpf    = "#{(10000000000 + i).to_s[0..2]}.#{(10000000000 + i).to_s[3..5]}.#{(10000000000 + i).to_s[6..8]}-#{(10000000000 + i).to_s[9..9]}#{i}"
    s.phone  = "(11) 9#{rand(1000..9999)}-#{rand(1000..9999)}"
    s.email  = "aluno#{i + 1}@demo.com"
    s.belt   = belts.sample
    s.status = statuses.sample
    s.enrolled_at = Date.today - rand(0..365).days
  end

  unless student.health_record
    student.create_health_record!(
      blood_type:    %w[A+ B+ O+ AB+].sample,
      comorbidities: i == 0 ? [ "hipertensão" ] : [],
      allergies:     [],
      injuries:      [],
      lgpd_consent:  true,
      lgpd_consent_at: Time.current
    )
  end

  if student.enrollments.none?
    enrollment = student.enrollments.create!(
      plan:       plano_mensal,
      started_at: student.enrolled_at || Date.today,
      status:     :active
    )
  end
end

puts ""
puts "✓ Seeds criados com sucesso!"
puts ""
puts "Acesso:"
puts "  Owner:    dono@demo.com / password123"
puts "  Teacher:  professor@demo.com / password123"
puts ""
puts "Form público: http://localhost:3000/public/academia-demo"
