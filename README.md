# Rails Single Table Inheritance and Polymorphic Associations

## http://6ftdan.com/allyourdev/2015/02/10/rails-polymorphic-models/

What is a polymorphic association you might ask?  It’s where an ActiveRecord model can potentially belong to more than one other kind of model record.  So the single instance of your car belongs to you, a person, whereas other cars may individually belong to a car lot, or a business.

## Why do we need it?

In Rails, ActiveRecord has a default way for relations between your DB records.  A normal record referring to another will simply insert the name before _id (model_name_id).  Lets say a User can own a Profile.  So we’ll have both User and Profile models.  Profile will have a belongs_to field stating it belongs to User, and User will have only one Profile.

## Reference name

When picking a reference name it is standard practice to use the name of the object and add the word able to the end.  So Profile will become profileable.  The references to access the ownership on the Profile model will now be profileable_id and profileable_type.


## Setting it all up

- rails g model Profile name:string:index profileable:references{polymorphic}
- bundle exec rake db:migrate

### /app/models/user.rb
class User < ActiveRecord::Base
	has_one :profile, as: :profileable, dependent: :destroy
end

### /app/models/profile.rb
class Profile < ActiveRecord::Base
	belongs_to :profileable, polymorphic: true
end

When you use polymorphic associations you get some additional methods for creating records.  Since we’re using a has_one relationship the method made available to use is prefixed with build_ to our polymorphic class Profile name, so it’s build_profile

## In the console

User.create(user_name: 'First User', type: 'User', email: 'ruth@example.com', password: 'password', password_confirmation: 'password')
User.create(user_name: 'Second User', type: 'User', email: 'jo@example.com', password: 'password', password_confirmation: 'password')

user = User.first
user.build_profile(name: "I was in Spooks").save
user.profile.name

user = User.find(2)
user.build_profile(name: "I'm better than ruth").save
user.profile.name

## Adding the Business to the User model

(1) Add a column named type with string datatype to the user table in the database 
using a migration.

- rails generate migration AddTypeToUsers type:string

## Generate a migration for user and business names

- rails generate migration AddNamesToUsers user_name:string business_name:string

(2) Make an override controller for devise

### http://jacopretorius.net/2014/03/adding-custom-fields-to-your-devise-user-model-in-rails-4.html

- registrations_controller.rb 

(3) Update the devise views with the extra fields

(4) For each user type create a model, which for our example will be ...
	we dont need the migration because we inherit from User so everything being
	stored in the User table

- rails generate model Business --migration=false

(5) Make the Business class inherits from User model

class Business < User
end

## In the console
(6) To create a Business run the command

Business.create(business_name: 'Car Wash', type: 'Business', email: 'wash@example.com', password: 'password', password_confirmation: 'password')
Business.create(business_name: 'Food Shop', type: 'Business', email: 'food@example.com', password: 'password', password_confirmation: 'password')

business = Business.first
# This also works, not sure why
user = User.find(3)
business.build_profile(name: "We wash cars").save
business.profile.name

# This doesn't work!
business = Business.find(2)
# This works
business = Business.last
# This also works
user = User.find(4)
business.build_profile(name: "We love hot food").save
business.profile.name

## http://stackoverflow.com/questions/9472852/devise-and-multiple-user-models
## http://stackoverflow.com/questions/28686732/multiple-users-with-devise-in-the-same-model