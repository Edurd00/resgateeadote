# Cria ou promove a conta principal de acesso administrativo.
superadmin_email = ENV.fetch("SUPERADMIN_EMAIL", "admin@resgateeadote.com.br")
superadmin = User.find_or_initialize_by(email: superadmin_email)

if superadmin.new_record?
  superadmin_password = ENV.fetch("SUPERADMIN_PASSWORD", "Mudar123!")

  superadmin.name = "Superadmin"
  superadmin.password = superadmin_password
  superadmin.role = :superadmin
  superadmin.save!
  puts "Conta Superadmin criada para #{superadmin_email}."
elsif superadmin.superadmin?
  puts "A conta Superadmin #{superadmin_email} já existe."
else
  superadmin.update!(role: :superadmin)
  puts "A conta #{superadmin_email} foi promovida a Superadmin."
end
