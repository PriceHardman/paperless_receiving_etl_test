=begin

  This file defines an abstract class that serves to override the application's default database (MySQL) and
  ORM (ActiveRecord), allowing the application to seamlessly use data from two different databases. The reason
  for the use of two ORMs -- Sequel and ActiveRecord -- is because no adequate Informix adapter exists for
  ActiveRecord. We are forced to use Sequel. This file intends to abstract these differences away, so that
  at the controller and view level, the databases will appear to be one and the same.

  First, we define a new class InformixBackedModel using the nonstandard Class.new(parent) syntax,
  as this is the only supported way for creating an abstract (tableless) model that inherits from Sequel::Model.
  Read about it here: http://groups.google.com/forum/#!topic/sequel-talk/OG5ti9JAJIE

  In class InformixBackedModel, we then include ActiveModel::Naming to make Rails play nicer with the models
  that will inherit from this one. Lastly, we define a class variable @@connection that contains a connection
  to Informix using Sequel's Sequel.connect() method, drawing the connection parameters from the development_sequel
  section of database.yml. Since this class (and all children classes that inherit from it) does not inherit from
  ActiveRecord::Base and instead inherits from Sequel::Model, the ORM for all the child classes is Sequel instead of
  ActiveRecord. This is how we override both the default database connection and the default ORM.

=end

InformixBackedModel = Class.new(Sequel::Model)

class InformixBackedModel
  extend ActiveModel::Naming
  @@connection = Sequel.connect(
			YAML.load(
				ERB.new(
					File.read(
						"#{Rails.root}/config/database.yml"
					)
				).result
			)["#{Rails.env}_sequel"]
  )
end
