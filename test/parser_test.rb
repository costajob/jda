require "test_helper"
require "jda/parser"

describe Jda do
  let(:ebuseu) { Tempfile.new(["ebuseu", ".txt"]) << %Q{800907712  ,20102  ,"Milano Montenapoleone         ",0        ,4        ,0        ,100  ,"HANDBAGS                 ",1       ,"115003F40IR    ",1000  ,"0099","1000/ /AUSTIN MED BINOCHE ORIG",329.00         ,"Y",60701   ,0      ,1
800907768  ,20102  ,"Milano Montenapoleone         ",0        ,6        ,0        ,100  ,"HANDBAGS                 ",1       ,"114923F40KG    ",9643  ,"0099","9643/ /CHAIN MINI FLAP ORIG GG",301.00         ,"",70107   ,0      ,6
800968214  ,21400  ,"WH E-Commerce                 ",0        ,39       ,0        ,100  ,"HANDBAGS                 ",1       ,"120134F40KG    ",9643  ,"0099","9643/ /CHAIN MED FLAP CHAIN OR",378.00         ,"Y",70107   ,0      ,8
800968215  ,20102  ,"Milano Montenapoleone         ",0        ,14       ,0        ,100  ,"HANDBAGS                 ",1       ,"120134F40KR    ",1000  ,"0099","1000/ /CHAIN MED FLAP CHAIN OR",378.00         ,"",70107   ,0      ,6
801184592  ,20102  ,"Milano Montenapoleone         ",0        ,18       ,0        ,100  ,"HANDBAGS                 ",1       ,"120844F40IR    ",1000  ,"0099","1000/ /ECLIPSE SM TP HNDLE TOT",245.00         ,"",70707   ,0      ,5
801405297  ,20102  ,"Milano Montenapoleone         ",0        ,32       ,0        ,100  ,"HANDBAGS                 ",1       ,"130736B6R1G    ",1000  ,"0099","1000/ /ABBEY MED DBL SHLDR FLE",437.50         ,"Y",70107   ,0      ,7
801558381  ,20315  ,"Paris Print.Acc.              ",0        ,20       ,0        ,100  ,"HANDBAGS                 ",1       ,"137394F5Z3G    ",8470  ,"0099","8470/ /ANITA MED N/S TOTE FLOR",413.00         ,"",60701   ,0      ,0
801568417  ,20102  ,"Milano Montenapoleone         ",0        ,7        ,0        ,100  ,"HANDBAGS                 ",1       ,"140274F40IR    ",1000  ,"0099","1000/ /ECLIPSE MED ZIP TOP TOT",409.50         ,"",60701   ,0      ,9
800907768  ,20315  ,"Milano Montenapoleone         ",0        ,4        ,0        ,100  ,"HANDBAGS                 ",1       ,"140274F40IR    ",9643  ,"0099","9643/ /ECLIPSE MED ZIP TOP TOT",409.50         ,"Y",60701   ,0      ,7
801613068  ,20162  ,"Verona                        ",0        ,14       ,0        ,100  ,"HANDBAGS                 ",1       ,"141576F4FXG    ",1000  ,"0099","1000/ /JACKIE SM HOBO ORIG GG ",294.00         ,"Y",70707   ,0      ,1} }

  describe Jda::Feed do
    let(:gz) { Jda::Feed::new("/jda/ebuscz-20160112083201.tgz") }
    let(:txt) { Jda::Feed::new("/jda/ebuscz-import.txt") }

    it "must detect extension" do
      gz.ext.must_equal ".tgz"
      txt.ext.must_equal ".txt"
    end

    it "must detect tar gz files" do
      assert gz.tar_gz?
      refute txt.tar_gz?
    end

    it "must get the basename" do
      gz.basename.must_equal "ebuscz-20160112083201"
      txt.basename.must_equal "ebuscz-import"
    end
  end

  describe Jda::Parser do
    it "must set cache for read data" do
      stub(Thread).new { [] }
      parser = Jda::Parser::new(files: [ebuseu.path])
      parser.cache.keys.must_equal parser.feeds
    end

    describe "#filter!" do
      let(:parser) { Jda::Parser::new(files: [ebuseu.path]) }
      before { ebuseu.rewind }

      it "must filter nothing with default values" do
        parser.filter!
        parser.feeds.each do |feed|
          parser.cache[feed].value.size.must_equal 10
        end
      end

      it "must filter by skus" do
        parser.filter!(skus: %w[800907768 801613068])
        parser.feeds.each do |feed|
          parser.cache[feed].value.size.must_equal 3
        end
      end

      it "must filter by store codes" do
        parser.filter!(stores: %w[21400 20162 20315])
        parser.feeds.each do |feed|
          parser.cache[feed].value.size.must_equal 4
        end
      end

      it "must filter by markdown flag" do
        parser.filter!(md_flag: true)
        parser.feeds.each do |feed|
          parser.cache[feed].value.size.must_equal 5
        end
      end

      it "must combine filters" do
        parser.filter!(skus: %w[800907768], stores: %w[20102 20315], md_flag: true)
        parser.feeds.each do |feed|
          parser.cache[feed].value.size.must_equal 1
        end
      end
    end
  end
end
