class Calender
  #カレンダー出力に必要な要素をすべて配列で用意、定数に変更
  Week = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
  Month_al = ["January","February","March","April","May","June","July","August",
              "September","October","November","December"]
  Month_30 = [4,6,9,11] #30日の月と31日までの月をそれぞれ配列に入れた
  Month_31 = [1,3,5,7,8,10,12] #1～12しか入力を受け付けないので不要になったが
                               #Dateを使わない都合上、月のデータとして一応残した
    
  def initialize(year,month)
    @year = year
    @month = month
    begin
      p "正しい数字を入れてね"
      exit!
    end if @year < 1583 || @month < 1 || @month > 12
    # 処理できない入力は受け付けないよう処理を終了、1583年に変更
  end
  
  
  def uru_year? #うるう年判定の判定。true/falseに変更した。
    @year % 400 ==0 || @year % 4 == 0 && @year % 100 != 0
  end
  
  
  def zeller #ツェラーの公式メソッド、内容を若干短縮

    if @month == 1 || @month == 2 #変数準備
      month_temp = @month + 12
      year_temp = @year - 1
    else
      year_temp = @year
      month_temp = @month
    end
    
    zeller_temp = ((year_temp + year_temp / 4) + (year_temp / 400) - #ツェラー
                  (year_temp / 100)) + (month_temp * 13 + 8) / 5
    @zeller_day = ((zeller_temp + 1.00) % 7).floor
  end
  
  
  def puts_calender #カレンダー出力はすべてひとまとめにした
    uru_year? #必要なメソッドをここで呼び出しておく
    zeller
    
    puts "------------------------------------"
    print format("#{Month_al[@month - 1]}, #{@year}").center(27)
    print "\n" #入力された月の英単語と西暦を表示
    
    Week.each do |days| #曜日の行の出力
      print "#{days} "
    end
    
    print "\n"

    counter = 0 #空白の入力と、カレンダーの形にするために使用する
    counter = counter + @zeller_day 
    counter.times do    #1日より前の空白を埋める
      print ("    ")    #始まりの曜日のナンバー(例:日曜=0)＝埋めるマス数
    end
    
    31.times do |print_day| #月の日数の最大値＝31回繰り返しに変更
      print format("%3d ",print_day + 1)
      counter = counter + 1
      
      print "\n" if counter % 7 ==  0 #カレンダー端の改行
        
      break if !uru_year? && @month == 2 && counter == 28 + @zeller_day 
      break if uru_year? && @month == 2 && counter == 29 + @zeller_day 
      break if Month_30.include?(@month) && counter == 30 + @zeller_day
      #break if Month_31.include?(@month) && counter == 31 + @zeller_day
      #月・入力回数の場合分けと出力を合体させた
      #最大31回繰り返しに変えたため、･･･31.include?が不要になった。コメントアウト
      #｢入力された月の最終日はx日」という判定の変数も配列もなくなった
    end

    print "\n" if counter >= 28 + @zeller_day && counter % 7 != 0 
    #月の最終日が土曜だった場合、空白の列が入るのでその防止策

    puts "------------------------------------"
  end
end

#----------
p " 西暦1583年以降の年を入力して、そのあと月を入れてね"
calender = Calender.new(gets.to_i , gets.to_i)
calender.puts_calender 