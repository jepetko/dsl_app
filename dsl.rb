class Someone
  def greet
    "hello"
  end

  def young?
    true
  end
end

#####################################

@things = {}

def specify(thing, *args, &block)
  if( defined? thing != nil && thing.class == Class )
    @things[thing] = Proc.new(&block)
    inject_sugar thing
  else
    raise "#{thing} isn't suitable for 'specify'"
  end
end

def he(desc, *args, &block)
  person(desc, *args, &block);
end

def she(desc, *args, &block)
  person(desc, *args, &block);
end

def person(desc, *args, &block)
   class << self
    attr_accessor :descs
  end
  self.descs = {} if self.descs.nil?
  self.descs[desc] = Proc.new(&block)
end

def inject_sugar(clazz)

  def clazz.method_missing method_name, *args, &block
    method_name if method_name.match(/^be/)
    super
  end

  clazz.send(:define_method, 'should') do |*args|

    target_method = args[0]
    puts "..target_method: #{target_method}"
    puts ".." + defined? target_method
    puts self
    puts clazz
    puts !clazz.singleton_methods.include?(target_method)
    target_method_s = target_method.to_s

    if( !clazz.singleton_methods.include?(target_method) )
      puts "HAAAAALOOO"

      clazz.define_singleton_method target_method_s do |target_method|
        target_method
      end
      puts clazz.singleton_methods
    end

    if( defined?(target_method) == 'method')
      underline_pos = target_method.to_s.index('_')
      raise "call #{target_method.to_s.inspect} not supported" if underline_pos.nil?
      underline_pos += 1
      real_instance_method_name = target_method.to_s[underline_pos..-1]
      real_instance_method = self.method real_instance_method_name
      real_instance_method.call
    else
      raise "#{target_method} isn't a method"
    end
  end


  #clazz.send(:define_method, 'should_not') { false }

  clazz.instance_methods.each do |m|
    if m.match(/^([^_]+)\?$/)      #matches methods like blank?, equal?,...
      sugar_method_name = "be_" + m.to_s.gsub('?','')
      puts sugar_method_name
    end
  end
end

#####################################


specify Someone do

  she "should be able to clean"  do
    puts "--START"
    @s = Someone.new
    @s.should be_young
    puts "--END"
  end

end

@things.each do |k,v|

  k.instance_eval &v
  k.descs.each do |key,val|
    k.instance_eval &val
  end
end

#####################

=begin
Step 1: define your own DSL.
following keywords are used here
  *specify => specify the THING you want to tell about
  *he or she => someone whos action is specified and tested for suitability

Step 2: store the configuration of "specify" and "he" and "she"

=end