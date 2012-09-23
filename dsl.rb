@things = {}

def specify(thing, *args, &block)
  if( defined? thing != nil && thing.class == Class )
    @things[thing] = Proc.new(&block)
    inject_sugar thing
  else
    raise "#{thing} isn't suitable for 'specify'"
  end

  @things.each do |k,v|
    k.instance_eval &v
    k.descs.each do |key,val|
      ret = k.instance_eval &val
      puts "#{key} \n \t *#{ret}"
    end
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
    if method_name.to_s.match(/be_.*/)
      method_name
    else
      super
    end
  end

  def validate(*args)
    target_method, val = *args
    underline_pos = target_method.to_s.index('_')
    raise "call #{target_method.to_s.inspect} not supported" if underline_pos.nil?
    underline_pos += 1
    real_instance_method_name = target_method.to_s[underline_pos..-1]
    real_instance_method = self.method "#{real_instance_method_name}?"

    msg = "#{real_instance_method_name} SHOULD BE #{val}"
    if real_instance_method.call == val
      "SUITABLE   : " + msg
    else
      "NO SUITABLE: " + msg
    end
  end

  clazz.send(:define_method, 'should') do |*args|
    args << true
    self.validate(*args)
  end

  clazz.send(:define_method, 'should_not') do |*args|
    args << false
    self.validate(*args)
  end
end

#####################################

=begin
Step 1: define your own DSL.
following keywords are used here
  *specify => specify the THING you want to tell about
  *he or she => someone whos action is specified and tested for suitability

Step 2: store the configuration of "specify" and "he" and "she"

Limitations:
one he/she description per validation. otherwise the former validation will be overruled
can be applied for methods returning boolean values (also known as )
=end