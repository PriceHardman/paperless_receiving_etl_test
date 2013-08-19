This app serves as a proof of concept, showing that Rails is capable to seamlessly use two databases -- each accessed using a different ORM -- concurrently.

This proof of concept arose out a need to access a legacy IBM Informix database from Rails. Unfortunately the only ActiveRecord adapter for Informix is no longer maintained, and it does not work with Rails 3+. Datamapper does not work either. This leaves us with [Sequel](http://sequel.rubyforge.org/). Since we do not want our application to be backed exclusively by a legacy system, we should use a standard production database such as MySQL, and access Informix only when we need to.

This is the crux of the issue: 
*How do we make an application backed primarily by MySQL (using ActiveRecord), but also needing to read and write data to and from Informix (using Sequel) in real time?*

At first, it seemed that any such solution would be a horrible mess, using wildly non-standard features of Rails all over the place, until the thing was practically unrecognizable as a Rails app.

It turns out that Rails and Sequel make this remarkably easy to do, with minimal deviation from standard Rails practices.

The first step is to include the mysql2, ruby-informix, and sequel gems in the gemfile:

`
gem 'rails', '3.2.13'
gem 'mysql2'
gem 'ruby-informix'
gem 'sequel'
`

Next, create two separate entries in database.yml. One for mysql -- under the heading 'development' -- and one for informix under the heading 'development_sequel'. Notice the use of environment variables in ERB tags, so as to not publish my database connection parameters to GitHub:
`
development:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: <%= ENV['MYSQLRAILSDBNAME'] %>
  pool: 5
  username: <%= ENV['MYSQLRAILSUSERNAME'] %>
  password: <%= ENV['MYSQLRAILSPASSWORD'] %>
  socket: /var/lib/mysql/mysql.sock

development_sequel:
  adapter: informix
  database: <%=ENV['INFORMIXRAILSDBNAME']%>
  username: <%=ENV['INFORMIXRAILSUSERNAME']%>
  password: <%=ENV['INFORMIXRAILSPASSWORD']%>
`

Next, we are going to create an abstract class inheriting from `Sequel::Model` (the Sequel equivalent of ActiveRecord::Base), which will serve as the parent class from which all of our Informix-backed models will inherit. This will vastly simplify and DRY things up, as we will override ActiveRecord (and thereby MySQL) with Sequel (and thereby Informix) in one -- and only one -- class, and then all child classes will inherit from the parent class.

To do this, create a file app/models/informix_backed_model.rb:

`InformixBackedModel = Class.new(Sequel::Model)

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
end`

Notice that all we need in order to override ActiveRecord with Sequel is:
1. Declare a class `Class.new(Sequel::Model)`, which is how to declare an abstract class in Sequel that inherits from Sequel::Model.
2. In the class definition, extend ActiveModel::Naming to ensure the child classes will play nice with Rails.
3. Define a class method @@connection, consisting of a Sequel connection, which passes the data from the development_sequel heading in database.yml, parsed through ERB and YAML.

To create MySQL-backed models, create a Rails model normally, using a generator or whatever preferred method.

To create an Informix-backed model, manually create a file under app/models/. For example, say we wish to create a model called "FreightReceipt". We would then create a file /app/models/freight_receipt.rb:

`class FreightReceipt < InformixBackedModel # => inherits from InformixBackedModel
  set_dataset @@connection[:warehouse_tran] # => model represents informix table warehouse_tran

  def pallets # => creates a method (similar to attr_accessor in ActiveRecord) pallets.
    Pallet.where(:fr_number => self.id) # => returns the records in MySQL table pallets with this fr_number
  end
end`

This looks a bit different from a normal Rails model, but it will behave in largely the same way as an ActiveRecord model. What we have done here is create a model FreightReceipt which inherits from InformixBackedModel, uses @@connection to define its source table as the Informix table warehouse_tran, and actually defines a method pallets, which will return all the records in the MySQL table pallets whose fr_number field contains the id of the given FreightReceipt object. In other words, we have manually defined a one-to-many association between this Informix-backed Sequel model and the MySQL-backed ActiveRecord model Pallet, effectively treating to tables in different databases as if they were in a single database.

