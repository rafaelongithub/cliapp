#!/usr/bin/env ruby

Dir.mkdir("db")

require 'sqlite3'

puts "\n== Preparando banco de dados =="
begin
  db = SQLite3::Database.open "db/database.db"
  db.execute <<~SQL
    CREATE TABLE Subjects(
      id_category INTEGER PRIMARY KEY,
      category varchar(255)
    );
  SQL


  seed_data = [[1,"Ruby"], [2, "Rails"], [3,"HTML"]]

  seed_data.each do |data|
    db.execute "INSERT INTO Subjects VALUES ( ?, ? ) ", data
  end

  db.execute <<~SQL
    CREATE TABLE Item_to_study(
      id_item INTEGER PRIMARY KEY AUTOINCREMENT,
      id_category INTEGER,
      item_description varchar(255)
    );
  SQL

rescue SQLite3::Exception => e
  puts e
ensure
  db.close if db
end
