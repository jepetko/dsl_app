require_relative "dsl.rb"

####################################
#
# class to be tested
#
####################################
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
    !self.young?
  end
end

####################################
#
# class to be tested
#
####################################
class Secretary < Candidate
  attr_accessor :signs_per_minute
  def fast_writing?
    self.signs_per_minute > 300
  end
end

####################################
#
# class to be tested
#
####################################
class Developer < Candidate
  attr_accessor :programming_languages
  def clever?
      self.programming_languages.include?('Ruby') && (!self.programming_languages.include?('Visual Basic'))
  end
end

#####################################


######### RUNNING TESTS #############

specify Candidate do
  she "should be young and motivated"  do
    @c = Candidate.new
    @c.name = "Anonymous"
    @c.age = 30
    @c.should_not be_old
  end
end

specify Secretary do
  she "should be able to write very fast" do
    @s = Secretary.new
    @s.name = "Kelly"
    @s.age = 23
    @s.signs_per_minute = 320
    @s.should be_fast_writing
  end
end

specify Developer do
  he "should be a clever developer" do
    @d = Developer.new
    @d.name = "Arnie"
    @d.programming_languages = %w[VisualBasic C#]
    @d.should be_clever

    @d2 = Developer.new
    @d2.name = "LuckyLuke"
    @d2.programming_languages = %w[Ruby Javascript]
    @d2.should be_clever
  end
end
