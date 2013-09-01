
## NB: do NOT require sportdb (avoid circular loading)
#### require 'sportdb'

require 'sportdb/market/version'

require 'sportdb/market/schema'
require 'sportdb/market/models/service'
require 'sportdb/market/models/group_quote'
require 'sportdb/market/models/event_quote'
require 'sportdb/market/models/quote'
require 'sportdb/market/models/game'
require 'sportdb/market/loader'
require 'sportdb/market/reader'


module SportDb::Market

  def self.banner
    "sportdb-market #{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  ##  cut off folders lib(#1)/sportdb(#2) to get to root
  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )}"
  end
  
  ## builtin path to fixture data
  def self.data_path
    "#{root}/data"
  end
  
  def self.create
    CreateDb.up
  end

  def self.fixtures_rb  # all builtin ruby fixtures; helper for covenience
    ['services',
     'at/2012_13/bl',
     'at/2012_13/cup',
     'cl/2012_13/cl',
    ## 'euro/2012'
    ]
  end

  def self.load_all( include_path )
    load( fixtures_rb, include_path )
  end

  def self.fixtures_txt
    [['betathome', 'at.2012/13',       'at/2012_13/bl_betathome'],
     ['tipp3',     'at.2012/13',       'at/2012_13/bl_tipp3'],
     ['betathome', 'at.cup.2012/13',   'at/2012_13/cup_betathome'],
     ['tipp3',     'at.cup.2012/13',   'at/2012_13/cup_tipp3'],
     ['betathome', 'cl.2012/13',       'cl/2012_13/cl_betathome'],
     ['tipp3',     'cl.2012/13',       'cl/2012_13/cl_tipp3'],
  ##   ['tipico',    'euro.2012',        'euro/2012_tipico'],
  ##   ['tipp3',     'euro.2012',        'euro/2012_tipp3' ],
     ['tipp3',     'world.quali.europe.2014', 'world/quali_tipp3']]
  end

  def self.read_all( include_path )
    read( fixtures_txt, include_path )
  end


  # load built-in (that is, bundled within the gem) named seeds
  # - pass in an array of seed names e.g. [ 'cl/teams', 'cl/2012_13/cl' ] etc.

  def self.load( ary, include_path )
    loader = Loader.new( include_path )
    ary.each do |name|
      loader.load( name )
    end
  end

  # load built-in (that is, bundled within the gem) named plain text seeds
  # - pass in an array of pairs of event/seed names e.g. [['at.2012/13', 'at/2012_13/bl'], ['cl.2012/13', 'cl/2012_13/cl']] etc.

  def self.read( ary, include_path )
    reader = Reader.new( include_path )
    ary.each do |rec|
      reader.load( rec[0], rec[1], rec[2] ) # service_key, event_key, name
    end
  end

  class Deleter
    ## todo: move into its own file???    
    
    ## make models available in sportdb module by default with namespace
    #  e.g. lets you use Team instead of Models::Team 
    include SportDb::Models

    def run( args=[] )
      # for now delete all tables

      Service.delete_all
      Quote.delete_all
      GroupQuote.delete_all
      EventQuote.delete_all
    end
    
  end
  
  # delete ALL records (use with care!)
  def self.delete!
    puts '*** deleting sport market table records/data...'
    Deleter.new.run
  end # method delete!

end  # module SportDb::Market


## say hello
puts SportDb::Market.banner
