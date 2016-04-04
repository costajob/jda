require 'zlib'
require 'rubygems/package'
require 'tmpdir'

class Stubs
  READ_WRITE = 0666
  FILES = %w[ebuseu ebuskr ebuswh ebuspf1]

  attr_reader :dir

  def initialize
    @dir = Dir.mktmpdir("/jda")
    @timestamp = Time::now.strftime("%Y%m%d%H%M%S")
  end

  FILES.each do |name|
    define_method(name) do
      path = tgz_path(name)
      return tgz_path(name) if File::exist?(path)
      create_tgz(name)
      path
    end
  end

  private

  def tgz_path(name)
    "#{dir}/#{name}-#{@timestamp}.tgz"
  end

  def create_tgz(name)
    data = send("#{name}_data")
    File::open(tgz_path(name), "wb") do |f|
      Zlib::GzipWriter::wrap(f) do |gz|
        Gem::Package::TarWriter::new(gz) do |tar|
          tar.add_file_simple("#{dir}/#{name}-#{@timestamp}-import.txt", READ_WRITE, data.length) { |txt| txt.write(data) }
        end
      end
    end
  end

  def ebuseu_data
    %Q{806932926  ,20102  ,"Milano Montenapoleone         ",0        ,39       ,0        ,100  ,"HANDBAGS                 ",1       ,"120134F40KG    ",9643  ,"0099","9643/ /CHAIN MED FLAP CHAIN OR",378.00         ,"Y",70107   ,0      ,8
       800968215  ,20102  ,"Milano Montenapoleone         ",0        ,14       ,0        ,100  ,"HANDBAGS                 ",1       ,"120134F40KR    ",1000  ,"0099","1000/ /CHAIN MED FLAP CHAIN OR",378.00         ,"Y",70107   ,0      ,6
       806822313  ,21901  ,"Dublin                        ",2        ,0        ,0        ,100  ,"HANDBAGS                 ",1       ,"409535KLQHG    ",8526  ,"0099","8526/ /BORSA LINEA A TESS.GG S",790.00         ," ",0       ,0      ,1
       807014019  ,28201  ,"Luxembourg                    ",1        ,0        ,0        ,920  ,"IN STORE PACKAGING       ",1       ,"422925JATA0    ",8300  ,"0099","8300/ /IRC7 50PCS             ",25.74          ," ",0       ,0      ,6
       806932926  ,28201  ,"Luxembourg                    ",2        ,0        ,0        ,920  ,"IN STORE PACKAGING       ",1       ,"425299JATA0    ",1000  ,"0099","1000/ /I PAG36 TROUSER      PO",35.10          ," ",0       ,0      ,5}.freeze
  end

  def ebuskr_data
    %Q{806932926  ,25005  ,"Shinsegae Main                ",1        ,0        ,0        ,200  ,"WOMENS SHOES             ",1       ,"387893A9L00    ",1000  ,"4004","1000/35+  /S.TTO PELLE S. GOMM",699000.00      ,"Y",151127  ,0      ,1
       806888537  ,25005  ,"Shinsegae Main                ",1        ,0        ,0        ,200  ,"WOMENS SHOES             ",1       ,"408205C9D00    ",1000  ,"4008","1000/36   /L GISELE 75 PMP MAL",760000.00      ," ",0       ,0      ,1
       806932926  ,25099  ,"Warehouse                     ",0        ,10       ,0        ,640  ,"CHILDREN SOFT ACCESSORIES",1       ,"4182214K646    ",4100  ,"0099","4100/ /SL OLINA 90X90  70%WO 3",260000.00      ," ",0       ,0      ,9
       807279919  ,25099  ,"Warehouse                     ",0        ,14       ,0        ,640  ,"CHILDREN SOFT ACCESSORIES",1       ,"4161814K200    ",9568  ,"0099","9568/ /SC MINI STEN 24X140 100",180000.00      ," ",0       ,0      ,5
       807279946  ,25099  ,"Warehouse                     ",0        ,12       ,0        ,640  ,"CHILDREN SOFT ACCESSORIES",1       ,"4182214K646    ",5800  ,"0099","5800/ /SL OLINA 90X90  70%WO 3",260000.00      ," ",0       ,0      ,2}.freeze
  end

  def ebuswh_data
    %Q{806932926  ,21400  ,"WH E-Commerce                 ",29       ,0        ,0        ,100  ,"HANDBAGS                 ",1       ,"308364A7M0G    ",1000  ,"0099","1000/ /SOHO DISCO CELLARIUS   ",.00            ," ",0       ,60     ,5
       805050823  ,21400  ,"WH E-Commerce                 ",7        ,3        ,0        ,100  ,"HANDBAGS                 ",1       ,"308982A7M0G    ",1000  ,"0099","1000/ /SOHO DOUBLE CHAIN CELLA",.00            ," ",0       ,11     ,5
       803089286  ,21425  ,"E-Com Dubai                   ",0        ,0        ,0        ,100  ,"HANDBAGS                 ",1       ,"203257FFPAG    ",9643  ,"0099","9643/ /D GOLD MESSENGER ORIG.G",1100.00        ,"Y",110628  ,0      ,1
       806932926  ,21425  ,"E-Com Dubai                   ",0        ,0        ,0        ,100  ,"HANDBAGS                 ",1       ,"203257FFPAG    ",1000  ,"0099","1000/ /D GOLD MESSENGER ORIG.G",1100.00        ,"Y",110628  ,0      ,2
       806815922  ,21403  ,"E-Com UK                      ",0        ,0        ,0        ,310  ,"MENS RTW                 ",1       ,"405928Z4039    ",4275  ,"8900","4275/44   /SPW ICONIC WINDBREA",680.00         ," ",0       ,0      ,0}.freeze
  end 

  def ebuspf1_data
    %Q{806932926  ,23002  ,"SAN JUAN ASHFORD              ",1        ,0        ,0        ,210  ,"MENS SHOES               ",1       ,"170618A0V10    ",2019  ,"5983","2019/M7G  /M SANMARINO DRVR GC",239.00     ,"Y",160324  ,0      ,0  ,"                    ",.000000      ,"   ","                                                                                                                                                                                                        ",.000       
       802616358  ,23002  ,"SAN JUAN ASHFORD              ",-1       ,0        ,0        ,210  ,"MENS SHOES               ",1       ,"170618A0V10    ",2019  ,"5985","2019/M8G  /M SANMARINO DRVR GC",239.00     ,"Y",160324  ,0      ,0  ,"                    ",.000000      ,"   ","                                                                                                                                                                                                        ",.000
       807369049  ,23277  ,"E-Commerce                    ",0        ,1        ,0        ,200  ,"                         ",1       ,"431943C9D00    ",5628  ,"3996","5628/34   /SAND. PELLE S. CUOI",950.00     ," ",0       ,0      ,0  ,"64035911            ",.250000      ,"IT ","                                                                                                                                                                                                        ",332.500    
       807369050  ,23277  ,"E-Commerce                    ",0        ,1        ,0        ,200  ,"                         ",1       ,"431943C9D00    ",5628  ,"3998","5628/34+  /SAND. PELLE S. CUOI",950.00     ," ",0       ,0      ,0  ,"64035911            ",.250000      ,"IT ","                                                                                                                                                                                                        ",332.500    
       806932926  ,23277  ,"E-Commerce                    ",0        ,1        ,0        ,200  ,"                         ",1       ,"431943C9D00    ",5628  ,"4066","5628/41+  /SAND. PELLE S. CUOI",950.00     ," ",0       ,0      ,0  ,"64035911            ",.250000      ,"IT ","                                                                                                                                                                                                        ",332.500}.freeze
  end
end
