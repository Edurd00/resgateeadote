require "test_helper"

class AnimalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rescuer = User.create!(
      name: "Rescuer",
      email: "rescuer_public@example.com",
      password: "password123",
      password_confirmation: "password123",
      phone: "11999998888",
      role: :rescuer
    )

    @available_dog = Animal.create!(
      name: "Rex",
      species: :dog,
      age: "2 anos",
      sex: :male,
      size: :medium,
      status: :available,
      description: "Amigável",
      city: "São Paulo",
      state: "SP",
      user: @rescuer
    )

    @available_cat = Animal.create!(
      name: "Mimi",
      species: :cat,
      age: "1 ano",
      sex: :female,
      size: :small,
      status: :available,
      description: "Fofa",
      city: "Rio de Janeiro",
      state: "RJ",
      user: @rescuer
    )

    @adopted_dog = Animal.create!(
      name: "Bob",
      species: :dog,
      age: "3 anos",
      sex: :male,
      size: :large,
      status: :adopted,
      description: "Já adotado",
      city: "Santos",
      state: "SP",
      user: @rescuer
    )
  end

  test "index lists available animals" do
    get animals_url
    assert_response :success
    assert_select "h3", text: "Rex"
    assert_select "h3", text: "Mimi"
    assert_select "h3", text: "Bob", count: 0
  end

  test "index filters by species" do
    get animals_url, params: { species: "cat" }
    assert_response :success
    assert_select "h3", text: "Mimi"
    assert_select "h3", text: "Rex", count: 0
  end

  test "show displays animal details and whatsapp button" do
    get animal_url(@available_dog)
    assert_response :success
    assert_select "h1", text: "Rex"
    assert_select "a[href*='wa.me/11999998888']"
  end
end
