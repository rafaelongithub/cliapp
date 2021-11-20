require 'sqlite3'

def get_category_by_id(category_id)
  db = SQLite3::Database.open "db/database.db"
  db.results_as_hash = true

  study_category = db.execute "SELECT category FROM Subjects WHERE id_category=#{category_id}"

  db.close
  study_category.map {|study_category| { category: study_category['category'] } }
end

def show_categorias()
  db = SQLite3::Database.open "db/database.db"
  db.results_as_hash = true

  study_subjects = db.execute "SELECT id_category, category FROM Subjects"

  db.close
  study_subjects.map {|study_subject| {id_category: study_subject['id_category'], category: study_subject['category']} }
end

def show_items_of_study()
  db = SQLite3::Database.open "db/database.db"
  db.results_as_hash = true

  study_itens = db.execute "SELECT id_item, id_category, item_description FROM Item_to_study"

  db.close
  study_itens.map {|study_item| {id_item: study_item['id_item'], id_category: study_item['id_category'], study_item_description: study_item['item_description']} }
end

def register_item_of_study(category, item_description)
  db = SQLite3::Database.open "db/database.db"

  db.execute "INSERT INTO Item_to_study (id_category, item_description) VALUES (#{category}, '#{item_description}');"

  db.close
end

def search_for_study_item(search_word)
  db = SQLite3::Database.open "db/database.db"
  db.results_as_hash = true

  study_itens = db.execute "SELECT id_item, id_category, item_description FROM Item_to_study WHERE item_description LIKE '%#{search_word}%'"

  db.close
  study_itens.map {|study_item| {id_item: study_item['id_item'], id_category: study_item['id_category'], study_item_description: study_item['item_description']} }
end

opc = 1

while opc != 4
  puts "[1] Cadastrar um item para estudar"
  puts "[2] Ver todos os itens cadastrados"
  puts "[3] Buscar um item de estudo"
  puts "[4] Sair"
  print("Escolha uma opção:")
  opc = gets().to_i
  if opc == 1
    print("Digite o titulo do item de estudo: ")
    study_item = gets().chomp.to_s
    show_categorias().each { |element|
      puts("# #{element[:id_category]} - #{element[:category]}");
    }
    print("Escolha a categoria do item de estudo: ")
    category_to_register = gets().chomp.to_i
    register_item_of_study(category_to_register, study_item)
  elsif opc == 2
    show_items_of_study().each { |element|
      puts("#{element[:study_item_description]} - #{get_category_by_id(element[:id_category])[0][:category]}");
    }
  elsif opc == 3
    print("Digite a palavra para procurar: ")
    search_word = gets().chomp.to_s
    search_for_study_item(search_word).each { |element|
      puts("# #{element[:id_item]} - #{element[:study_item_description]} -  #{get_category_by_id(element[:id_category])[0][:category]}");
    }
  end
end
