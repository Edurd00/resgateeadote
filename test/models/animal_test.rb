require "test_helper"

class AnimalTest < ActiveSupport::TestCase
  test "valid photos format and size" do
    animal = Animal.new
    animal.photos.attach(
      io: StringIO.new("fake image content"),
      filename: "test.png",
      content_type: "image/png"
    )
    assert animal.valid?
  end

  test "invalid photo content type" do
    animal = Animal.new
    animal.photos.attach(
      io: StringIO.new("fake pdf content"),
      filename: "test.pdf",
      content_type: "application/pdf"
    )
    assert_not animal.valid?
    assert_includes animal.errors[:photos], "deve ser do formato PNG, JPG, JPEG ou WEBP"
  end

  test "invalid photo size over 5MB" do
    animal = Animal.new
    large_content = "a" * (5.megabytes + 1)
    animal.photos.attach(
      io: StringIO.new(large_content),
      filename: "large.jpg",
      content_type: "image/jpeg"
    )
    assert_not animal.valid?
    assert_includes animal.errors[:photos], "deve ter no máximo 5MB por foto"
  end
end
