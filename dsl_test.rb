require_relative "dsl.rb"

class Candidate

  attr_accessor :age
  attr_accessor :name
  attr_accessor :foreign_languages

  def greet
    "hello"
  end

  def young?
    if self.age.nil?
      false
    else
      self.age < 25
    end
  end

  def old?
    !self.young
  end
end

class Secretary < Candidate
  attr_accessor :signs_per_minute
  def fast_writing?
    self.signs_per_minute > 300
  end
end

class Developer < Candidate
  attr_accessor :programming_languages
  def clever?
      self.programming_languages.include?('Ruby') && (!self.programming_languages.include?('Visual Basic'))
  end
end

#####################################

specify Candidate do

  she "should be young and motivated"  do
    @c = Candidate.new
    @c.age = 30
    @c.should be_young
  end

  she "should be able to write very fast" do
    @s = Secretary.new
    @s.age = 23
    @s.signs_per_minute = 320
    @s.should be_fast_writing
  end

  he "should be a clever developer" do
    @d = Developer.new
    @d.programming_languages = %w[VisualBasic DotNet]
    @d.should be_clever
  end

end