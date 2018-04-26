class Calender
  #カレンダー出力に必要な要素をすべて配列で用意
  Week = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
  Month_al = ["January","February","March","April","May","June","July","August",
              "September","October","November","December"]
  Month_30 = [4,6,9,11] #30日の月と31日までの月をそれぞれ配列に入れた
  Month_31 = [1,3,5,7,8,10,12]
  Month_days = [*'   1'..'   31'] #最長で1~31日までしかないので定数化、さらに配列を1つに集約
  
    
  def initialize(year,month)
    @year = year
    @month = month
     if @year < 1873 || @month < 1 || @month > 12 
       #年月に対応しないものと、ツェラーの公式に対応しない年は受け付けない
       p "正しい数字を入れてね"
       exit!
     end
  end
  
  def uru_year? #うるう年判定の判定。現時点では同じ処理のまま
    @year % 400 ==0 || @year % 4 == 0 && @year % 100 != 0
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
    #p @year_z
    @month_z = (month_temp * 13 + 8) / 5
    #p @month_z
    @zeller_day = @year_z + @month_z + 1.00
    #p @zeller_day
    @zeller_day = (@zeller_day % 7).floor
    #p @zeller_day #日曜=0、月曜=1...とした時の、月初めの曜日がわかる
  end
  
  def puts_calender_1 #カレンダーはここで出力
    uru_year?
    zeller
    
    puts "------------------------------------"
    print format("#{Month_al[@month - 1]}, #{@year}").center(27)
    print "\n"
    
    Week.each do |days|
      print "#{days} "
    end
    
    print "\n"
  end

=begin
  def howmany_days 
    #2月なのか30日までの月なのか、31日までかここで判定
    #うるう年かどうかは判定済み
    @month_28or30or31 = 0
    
    if Month_30.include?(@month) #30日の月の配列に入力した@monthがあるか判定、あれば@monthは1～30日まで
      @month_28or30or31 += 1
      
    elsif Month_31.include?(@month) #31日版
      @month_28or30or31 += 2
      
    end #どちらにも該当しなければ2月
  end
=end
  
  def puts_calender_2
    counter = 0 #7日ごとに改行するためのカウンタ
    counter = counter + @zeller_day #1週目の改行は7回繰り返し=>改行では対応できないので、
                                    #ツェラーで使った変数を使って改行までの回数を調整する
                                    
    counter.times do #1日より前の空白を埋める、ツェラーで使った変数を代入済み
      print ("    ") #始まりの曜日のナンバー(例:日曜=0)＝埋めるマス数
    end
    
    Month_days.each do |print_day|
      print format("%3d ",print_day)
      counter = counter + 1
      
      if counter % 7 ==  0
        print "\n"
      end
      
      if counter == 28 + @zeller_day && !uru_year? && @month == 2
        break
      elsif counter == 29 + @zeller_day && uru_year? && @month == 2
        break
      elsif Month_30.include?(@month) && counter == 30 + @zeller_day
        break
      elsif Month_31.include?(@month) && counter == 31 + @zeller_day
        break
      end
    end

    if counter >= 28 + @zeller_day && counter % 7 != 0 
      print "\n"
    end

    puts "------------------------------------"
  end
  
end

#----------
p " 西暦1873年以降の年を入力して、そのあと月を入れてね"
calender = Calender.new(gets.to_i , gets.to_i)
calender.puts_calender_1 #カレンダーの日付欄より上はここで出力
calender.puts_calender_2 #カレンダーの日付欄より下上はここで出力

