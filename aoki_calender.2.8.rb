class Calender
  Week = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
  Month_al = ["January","February","March","April","May","June","July","August",
              "September","October","November","December"]
  Month_30 = [4, 6, 9, 11] # 場合分けに使うので、月末が30日の月を配列にした

  def initialize(year,month)
    @year = year
    @month = month
    begin
      p "正しい数字を入れてね"
      exit!
    end if @year < 1583 || @month < 1 || @month > 12
    # 処理できない入力は受付後に処理を終了、1583年に変更
  end
  
  
  def leap_year? # うるう年判定の判定。true/falseに変更した。
    @year % 400 ==0 || @year % 4 == 0 && @year % 100 != 0
  end


  def zeller # ツェラーの公式メソッド、変更なし

      year_temp = @year
      month_temp = @month
      
      if @month == 1 || @month == 2
        month_temp = @month + 12
        year_temp = @year - 1
      end

    zeller_temp = ((year_temp + year_temp / 4) + (year_temp / 400) -
                  (year_temp / 100)) + (month_temp * 13 + 8) / 5
    @zeller_day = ((zeller_temp + 1.00) % 7).floor
  end


  def puts_calender # カレンダー出力はすべてひとまとめにした
    leap_year? # 必要なメソッドをここで呼び出しておく
    zeller
    
    puts "----------------------------"
    print format("#{Month_al[@month - 1]}, #{@year}").center(27)
    puts # 入力された月の英単語と西暦を表示
    
    Week.each do |days| # 曜日の行の出力
      print "#{days} "
    end
    puts

    @zeller_day.times do    
     # 1日より前の空白を埋める
     # 始まりの曜日のナンバー(例:日曜=0)＝必要な空白の数
      print ("    ")    
    end
    
    rayout_temp = 0 # 70行目のカレンダー最終行の改行調整に使う
    31.times do |print_day|  
     # 月末の日付の最大値＝31回繰り返し、28,29,30日の月はif式で分岐する
      
      print format("%3d ",print_day + 1) # print_dayは0始まりなので、1を足す
      rayout_temp += 1 # 何回繰り返されたかを記録する

      puts if (@zeller_day + print_day + 1) % 7 ==  0 
       # カレンダーの改行。空白記入回数+日付書込回数+1が7の倍数=土曜なので改行。
  
      break if !leap_year? && @month == 2 && print_day == 27
       # print_dayが27の時、出力された日付は62行で+1された28になっている
       # うるう年でない2月は28日までなので、この条件を満たしたら繰り返し終了
       # 出力回数を記録した変数ではなく、print_dayで分岐できるようにした
      break if leap_year? && @month == 2 && print_day == 28
      break if Month_30.include?(@month) && print_day == 29
       # 以下月末の日付が29日(うるう年2月)、30日のパターンを用意
    end
    
    puts if (@zeller_day + rayout_temp) % 7 != 0
    # ただの改行だと月末が土曜の時、余分な改行が入るのでそれを防ぐ処理。
    # 空白の数+日付の出力回数が7の倍数の時は月末が土曜なので改行不要
    # それ以外の場合のみ改行を入れる処理
    # print_dayで分岐させたかったが失敗したので、やむを得ず出力回数の変数を使う
    
    puts "----------------------------"
  end
end

#----------
p " 西暦1583年以降の年を入力して、そのあと月を入れてね"
calender = Calender.new(gets.to_i , gets.to_i)
calender.puts_calender 