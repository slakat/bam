usr_admin = User.create!(
    email: 'admin@test.com',
    password: '12345678'
)

acnt_admin = Account.create!(
    name: 'Jeronimo',
    lastname: 'Alvear',
    rut: '10696737-7',
    role: 'admin',
    user_id: usr_admin.id
)
acnt_admin.save

usr_kathy = User.create!(
    email: 'slakat@gmail.com',
    password: '12345678'
)

acnt_kathy = Account.create!(
    name: 'Katherine',
    lastname: 'Páez Ramos',
    rut: '17765340-3',
    role: 'admin',
    user_id: usr_kathy.id
)
acnt_kathy.save

usr_tom = User.create!(
    email: 'tpgunther@uc.cl',
    password: '12345678'
)

acnt_tom = Account.create!(
    name: 'Tomás',
    lastname: 'Gunther Huerta',
    rut: '18020311-7',
    role: 'admin',
    user_id: usr_tom.id
)
acnt_tom.save