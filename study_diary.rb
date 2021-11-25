require 'sqlite3'
require_relative 'study-classes/study_category.rb'
require_relative 'study-classes/study_item.rb'

def get_category_by_id(category_id)
  db = SQLite3::Database.open "db/database.db"
  db.results_as_hash = true

  study_category = db.execute "SELECT category FROM Subjects WHERE id_category=#{category_id}"

  db.close
  study_category.map {|study_category| { category: study_category['category'] } }
end

def show_categorias()
  categories = []
  db = SQLite3::Database.open "db/database.db"
  db.results_as_hash = true

  study_subjects = db.execute "SELECT id_category, category FROM Subjects"

  db.close
  study_subjects.map {|study_subject| categories << StudyCategory.new(study_subject['id_category'], study_subject['category']) }
  categories
end

def show_items_of_study()
  items_of_study = []

  db = SQLite3::Database.open "db/database.db"
  db.results_as_hash = true

  study_itens = db.execute "SELECT id_item, id_category, item_description FROM Item_to_study"

  db.close
  study_itens.map {|study_item| items_of_study << StudyItem.new(study_item['id_item'], study_item['id_category'], study_item['item_description'])}
  items_of_study
end

def register_item_of_study(category, item_description)
  db = SQLite3::Database.open "db/database.db"

  db.execute "INSERT INTO Item_to_study (id_category, item_description) VALUES (#{category}, '#{item_description}');"

  db.close
end

def search_for_study_item(search_word)
  result_itens = []

  db = SQLite3::Database.open "db/database.db"
  db.results_as_hash = true

  study_itens = db.execute "SELECT id_item, id_category, item_description FROM Item_to_study WHERE item_description LIKE '%#{search_word}%'"

  db.close
  study_itens.map {|study_item| result_itens << StudyItem.new(study_item['id_item'], study_item['id_category'], study_item['item_description'])}

  result_itens
end

def clear_and_wait
  system("clear")
end

def menu
  <<~HEREDOC
    [1] Cadastrar um item para estudar
    [2] Ver todos os itens cadastrados
    [3] Buscar um item de estudo
    [4] Marcar como feito
    [5] Sair
    Escolha uma opção:
  HEREDOC
end

opc = 1

while opc != 5
  puts menu
  opc = gets().to_i
  if opc == 1
    print("Digite o titulo do item de estudo: ")
    study_item = gets().chomp.to_s
    puts show_categorias()
    print("Escolha a categoria do item de estudo: ")
    category_to_register = gets().to_i

    register_item_of_study(category_to_register, study_item)
  elsif opc == 2
    puts show_items_of_study()
  elsif opc == 3
    print("Digite a palavra para procurar: ")
    search_word = gets().chomp.to_s
    puts search_for_study_item(search_word)
  end
end
