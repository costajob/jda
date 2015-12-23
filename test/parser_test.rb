require "test_helper"
require "jda/parser"

describe Jda::Parser do
  let(:ebuseu) { Tempfile.new('ebuseu.txt') << %Q{800907712  ,20102  ,"Milano Montenapoleone         ",0        ,4        ,0        ,100  ,"HANDBAGS                 ",1       ,"115003F40IR    ",1000  ,"0099","1000/ /AUSTIN MED BINOCHE ORIG",329.00         ,"Y",60701   ,0      ,1
800907768  ,20102  ,"Milano Montenapoleone         ",0        ,6        ,0        ,100  ,"HANDBAGS                 ",1       ,"114923F40KG    ",9643  ,"0099","9643/ /CHAIN MINI FLAP ORIG GG",301.00         ,"",70107   ,0      ,6
800968214  ,21400  ,"WH E-Commerce                 ",0        ,39       ,0        ,100  ,"HANDBAGS                 ",1       ,"120134F40KG    ",9643  ,"0099","9643/ /CHAIN MED FLAP CHAIN OR",378.00         ,"Y",70107   ,0      ,8
800968215  ,20102  ,"Milano Montenapoleone         ",0        ,14       ,0        ,100  ,"HANDBAGS                 ",1       ,"120134F40KR    ",1000  ,"0099","1000/ /CHAIN MED FLAP CHAIN OR",378.00         ,"",70107   ,0      ,6
801184592  ,20102  ,"Milano Montenapoleone         ",0        ,18       ,0        ,100  ,"HANDBAGS                 ",1       ,"120844F40IR    ",1000  ,"0099","1000/ /ECLIPSE SM TP HNDLE TOT",245.00         ,"",70707   ,0      ,5
801405297  ,20102  ,"Milano Montenapoleone         ",0        ,32       ,0        ,100  ,"HANDBAGS                 ",1       ,"130736B6R1G    ",1000  ,"0099","1000/ /ABBEY MED DBL SHLDR FLE",437.50         ,"Y",70107   ,0      ,7
801558381  ,20315  ,"Paris Print.Acc.              ",0        ,20       ,0        ,100  ,"HANDBAGS                 ",1       ,"137394F5Z3G    ",8470  ,"0099","8470/ /ANITA MED N/S TOTE FLOR",413.00         ,"",60701   ,0      ,0
801568417  ,20102  ,"Milano Montenapoleone         ",0        ,7        ,0        ,100  ,"HANDBAGS                 ",1       ,"140274F40IR    ",1000  ,"0099","1000/ /ECLIPSE MED ZIP TOP TOT",409.50         ,"",60701   ,0      ,9
801568418  ,20102  ,"Milano Montenapoleone         ",0        ,4        ,0        ,100  ,"HANDBAGS                 ",1       ,"140274F40IR    ",9643  ,"0099","9643/ /ECLIPSE MED ZIP TOP TOT",409.50         ,"Y",60701   ,0      ,7
801613068  ,20162  ,"Verona                        ",0        ,14       ,0        ,100  ,"HANDBAGS                 ",1       ,"141576F4FXG    ",1000  ,"0099","1000/ /JACKIE SM HOBO ORIG GG ",294.00         ,"Y",70707   ,0      ,1} }
  let(:parser) { Jda::Parser::new(files: [ebuseu.path]) }

  before { ebuseu.rewind }

  it "must call CSV to read file" do
    parser.files.size.times { mock(Thread).new }
    parser.read_all
  end

  it "must set cache for read data" do
    stub(Thread).new { [] }
    parser.read_all
    parser.cache.keys.must_equal parser.files
  end

  it "must filter nothing with default values" do
    parser.read_all
    parser.filter!
    parser.files.each do |file|
      parser.cache[file].value.size.must_equal 10
    end
  end
end
