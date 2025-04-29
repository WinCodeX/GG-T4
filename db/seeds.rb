# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(email: "admin@test.com", password: "password123", password_confirmation: "password123")
User.create!(email: "glenwinterg970@gmail.com", password: "Leviathan@Xcode", password_confirmation: "Leviathan@Xcode")

# Create Locations
nairobi = Location.create!(name: "Nairobi", description: "Capital city of Kenya")
mombasa = Location.create!(name: "Mombasa", description: "Coastal city of Kenya")

# Create Areas under Locations
Area.create!(name: "CBD", location: nairobi, description: "Central Business District of Nairobi")
Area.create!(name: "Westlands", location: nairobi, description: "Commercial district")
Area.create!(name: "Nyali", location: mombasa, description: "Residential and commercial area in Mombasa")

CourierService.create!(name: "G4S", description: "G4S Courier Services across Kenya")
CourierService.create!(name: "Wells Fargo", description: "Secure and fast courier solutions")
CourierService.create!(name: "Fargo Courier", description: "Courier services nationwide")
CourierService.create!(name: "Other", description: "Manual input for preferred courier")


# ==== Create Locations ====

nairobi = Location.find_or_create_by!(name: "Nairobi") do |loc|
  loc.description = "Capital city of Kenya"
end

mombasa = Location.find_or_create_by!(name: "Mombasa") do |loc|
  loc.description = "Coastal city of Kenya"
end

# ==== Create Areas ====

cbd = Area.find_or_create_by!(name: "CBD", location: nairobi) do |area|
  area.description = "Central Business District of Nairobi"
end

westlands = Area.find_or_create_by!(name: "Westlands", location: nairobi) do |area|
  area.description = "Commercial district"
end

nyali = Area.find_or_create_by!(name: "Nyali", location: mombasa) do |area|
  area.description = "Residential and commercial area in Mombasa"
end

# ==== Create Dummy User (for Agents) ====

user = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
end

# ==== Create Agents ====

Agent.create!([
  {
    name: "Moonlit Agent",
    phone: "0712345678",
    email: "moonlit@example.com",
    location: "nairobi",
    area: "cbd",
    status: "active",
    user_id: "user.id"
  },
  {
    name: "Sunset Agent",
    phone: "0722333444",
    email: "sunset@example.com",
    location: "nairobi",
    area: "westlands",
    status: "active",
    user_id: "user.id"
  },
  {
    name: "Coastal Breeze Agent",
    phone: "0733444555",
    email: "coastal@example.com",
    location: "mombasa",
    area: "nyali",
    status: "active",
    user_id: "user.id"
  }
])