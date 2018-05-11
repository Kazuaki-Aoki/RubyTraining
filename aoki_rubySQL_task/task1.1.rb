require 'sqlite3'
require "csv"
class Book
  CSV_COLUMN = {Name: 0, Price: 1}
  
  def initialize(dbfile)
    @dbfile = dbfile
  end
  
  
  def create(zipfile)
    puts "テーブルを作ります"
    if File.exist?(@dbfile)
      puts '"book.db"は既に存在します。'
      puts
      return
    end
    
    SQLite3::Database.open(@dbfile) do |db|
      db.execute(<<-SQL)
        CREATE TABLE IF NOT EXISTS book
        (Name TEXT, Price Integer)
      SQL
      db.execute("BEGIN TRANSACTION")
      CSV.open(zipfile, "r:Shift_JIS:UTF-8") do |csv|
        csv.each do |rec|
          data = Hash.new #新しい空のハッシュ
          CSV_COLUMN.each{|key, index| data[key] = rec[index]}
          db.execute(<<-SQL, data)
            INSERT INTO book VALUES (:Name, :Price)
          SQL
        end
      end
      db.execute("COMMIT TRANSACTION")
    end
    puts "テーブルを作成しました"
    puts
  end
  
  
  def find
    ret = []
    SQLite3::Database.open(@dbfile) do |db|
      db.execute(<<-SQL){|row| ret << row.join(" ") }
      SELECT * FROM book WHERE Price >= 10000
      SQL
    end
    puts "bookテーブルのPrice >= 10000のデータです"
    puts ret.map{|line| line + "\n"}.join
    puts

    ret2 = []
    SQLite3::Database.open(@dbfile) do |db|
      db.execute(<<-SQL){|row| ret2 << row.join(" ") }
      SELECT * FROM book WHERE Name LIKE "%楽しい%";
      SQL
    end
    puts "bookテーブルの 楽しい をNameに含むデータです"
    puts ret2.map{|line| line + "\n"}.join
    puts
  end
  
  
  def sort
    sort = []
    SQLite3::Database.open(@dbfile) do |db|
      db.execute(<<-SQL){|row| sort << row.join(" ") }
      SELECT * FROM book ORDER BY Name ASC;
      SQL
    end
    puts "Nameを基準に昇順です"
    puts sort.map{|line| line + "\n"}.join
    puts

    sort2 = []
    SQLite3::Database.open(@dbfile) do |db|
      db.execute(<<-SQL){|row| sort2 << row.join(" ") }
      SELECT * FROM book ORDER BY Price DESC;
      SQL
    end
    puts "Priceを基準に降順です"
    puts sort2.map{|line| line + "\n"}.join
    puts
  end
  
  
  def update
    before_update = []
    SQLite3::Database.open(@dbfile) do |db|
      db.execute(<<-SQL){|row| before_update << row.join(" ") }
      SELECT * FROM book WHERE Name = '楽しいRuby';
      SQL
    end
    puts "変更対象は次の通りです"
    puts before_update.map{|line| line + "\n"}.join
    puts

    update = []
    SQLite3::Database.open(@dbfile) do |db|
      db.execute(<<-SQL){|row| update << row.join(" ") }
      UPDATE book SET Price = 2500 WHERE Name = '楽しいRuby';
      SQL
    end
    
    after_update = []
    SQLite3::Database.open(@dbfile) do |db|
      db.execute(<<-SQL){|row| after_update << row.join(" ") }
      SELECT * FROM book WHERE Name = '楽しいRuby';
      SQL
    end
    puts "以下の通り変更しました"
    puts after_update.map{|line| line + "\n"}.join
    puts
  end
  
end

task = Book.new("book.db")
task.create("book.CSV")
task.find
task.sort
task.update