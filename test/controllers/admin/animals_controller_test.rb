require "test_helper"

class Admin::AnimalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(
      name: "Admin User",
      email: "admin@example.com",
      password: "password123",
      password_confirmation: "password123",
      phone: "11999999999",
      role: 1
    )

    @rescuer = User.create!(
      name: "Rescuer User",
      email: "rescuer@example.com",
      password: "password123",
      password_confirmation: "password123",
      phone: "11888888888",
      role: 0
    )

    @animal_admin = Animal.create!(
      name: "Rex",
      species: :dog,
      age: "2 anos",
      sex: :male,
      size: :medium,
      status: :available,
      description: "Cão resgatado",
      city: "São Paulo",
      state: "SP",
      user: @admin
    )

    @animal_rescuer = Animal.create!(
      name: "Mimi",
      species: :cat,
      age: "1 ano",
      sex: :female,
      size: :small,
      status: :available,
      description: "Gata resgatada",
      city: "Rio de Janeiro",
      state: "RJ",
      user: @rescuer
    )
  end

  def log_in_as(user)
    post login_url, params: { email: user.email, password: "password123" }
  end

  test "redirects unauthenticated users" do
    get admin_animals_url
    assert_redirected_to login_url
  end

  test "admin sees all animals" do
    log_in_as(@admin)
    get admin_animals_url
    assert_response :success
    assert_select "td", text: "Rex"
    assert_select "td", text: "Mimi"
  end

  test "rescuer sees only their own animals" do
    log_in_as(@rescuer)
    get admin_animals_url
    assert_response :success
    assert_select "td", text: "Mimi"
    assert_select "td", text: "Rex", count: 0
  end

  test "should create animal" do
    log_in_as(@rescuer)
    assert_difference("Animal.count") do
      post admin_animals_url, params: {
        animal: {
          name: "Thor",
          species: "dog",
          age: "3 meses",
          sex: "male",
          size: "small",
          status: "available",
          description: "Filhote carinhoso",
          city: "Santos",
          state: "SP"
        }
      }
    end
    assert_redirected_to admin_animals_url
  end

  test "should update animal" do
    log_in_as(@rescuer)
    patch admin_animal_url(@animal_rescuer), params: {
      animal: { status: "adopted" }
    }
    assert_redirected_to admin_animals_url
    assert_equal "adopted", @animal_rescuer.reload.status
  end

  test "should destroy animal" do
    log_in_as(@rescuer)
    assert_difference("Animal.count", -1) do
      delete admin_animal_url(@animal_rescuer)
    end
    assert_redirected_to admin_animals_url
  end
end
