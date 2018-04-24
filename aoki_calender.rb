class Calender
  def initialize(year,month)
    @year = year
    @month = month
     if @year < 1873 || @month < 1 || @month > 12 #ツェラーの公式を含め、処理できない入力は受け付けない
       p "正しい数字を入れてね"
       exit!
     end
  end
  
  def month_day #あり得る配列をすべて用意しておく
    @nuru_how = 0
    @week = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    @month_al = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    @nuru_30 = [*'   1'..'   30']
    @nuru_31 = [*'   1'..'   31']
    
    @nuru_feb = [*'   1'..'   28']
    @uru_feb = [*'  1'..'  29'] #うるう年2月用
  end

  def uru? #うるう年判定、専用の配列を使うためここで判定
    @uru = 0
    if @year % 400 ==0 || @year % 4 == 0 && @year % 100 != 0
      @uru += 1
      p "uru"
    end
  end
  
  def howmany_days? #うるう年2月以外のパターン
    if @month == 1|| @month ==3 || @month == 5|| @month == 7|| @month ==8|| @month ==10|| @month==12
      @nuru_how += 1
      
    elsif  @month == 4 || @month == 6|| @month == 9 ||@month ==11
      @nuru_how += 2
      
    else @nuru_how += 3
    end
  end
  
  def zeller #ツェラーの公式メソッド
    year_temp = 0

    if @month == 1 || @month == 2
      month_temp = @month + 12
      year_temp = @year - 1
   
    else
      year_temp = @year
      month_temp = @month
    end
    
    @year_z = (year_temp + year_temp / 4) + (year_temp / 400) - (year_temp / 100)
    p @year_z
    
    @month_z = (month_temp * 13 + 8) / 5
    p @month_z
    
    @zeller_day = @year_z + @month_z + 1.00
    p @zeller_day
    
    @zeller_day = (@zeller_day % 7).ceil
    p @zeller_day #日曜=0、月曜=1...とした時の、月初めの曜日がわかる
  end

  def puts_calender_days #カレンダーの日付欄より上はここで出力
    puts "------------------------------------"
    print format("#{@month_al[@month - 1]}, #{@year}").center(27)
    print "\n"
    @week.each do |days|
      print "#{days} "
    end
    
    print "\n"
  end
  
  
  def puts_calender #日付欄以下はここで出力
    counter = 0 #7日ごとに改行するためのカウンタ
    counter = counter + @zeller_day #1週目の改行は7回繰り返し=>改行では対応できないので、
                                    #ツェラーで使った変数を使って改行までの回数を調整する

    counter.times do #1日より前の空白を埋める、ツェラーで使った変数を代入済み
      print ("    ") #始まりの曜日のナンバー(例:日曜=0)＝埋めるマス数
    end
    
    if @uru == 1 && @month == 2 #うるう年の2月の場合は、29日まである配列を出す
      @uru_feb.each do |day|    #うるう年でない2月のパターンを忘れていたため、この式になった
        print format("%3d ",day)
        counter = counter + 1
      
        if counter == 7
          print "\n"
          counter = 0
        end
      end
    
    elsif @nuru_how == 1
      @nuru_31.each do |day|
        print format("%3d ",day)
        counter = counter + 1
      
        if counter == 7
          print "\n"
          counter = 0
        end
      end
      
    elsif @nuru_how == 2
      @nuru_30.each do |day|
        print format("%3d ",day)
        counter = counter + 1
      
        if counter == 7
          print "\n"
          counter = 0
        end
      end
      
    elsif @nuru_how == 3
      @nuru_feb.each do |day|
        print format("%3d ",day)
        counter = counter + 1
      
        if counter == 7
          print "\n"
          counter = 0
        end
      end
    end
    
    print "\n"
    puts "------------------------------------"
  end
end

#----------
p " 西暦1873年以降の年を入力して、そのあと月を入れてね"
calender = Calender.new(gets.to_i , gets.to_i)
calender.month_day
calender.uru?
calender.howmany_days?
calender.zeller

calender.puts_calender_days
calender.puts_calender