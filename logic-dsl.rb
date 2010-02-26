class Command
  def initialize(name)
    @name = name
  end
  
  def is(value)
    Command.new "#{self} is #{value}"
  end
  
  def is_not(value)
    Command.new "#{self} is #{value}"
  end
  
  def group(command)
    Command.new "#{self.to_s} (#{command.to_s})"
  end
  
  def and(command=nil,&block)
    if block
      o = '('
      cmd = yield block
      e = ')'
    else
      cmd = command
    end
    Command.new "#{self.to_s} and #{o}#{cmd.to_s}#{e}"
  end
  
  def or(command=nil,&block)
    if block
      o = '('
      cmd = yield block
      e = ')'
    else
      cmd = command
    end
    Command.new "#{self.to_s} or #{o}#{cmd.to_s}#{e}"
  end
  
  def to_s
    x=@name
    x="#{x} #{@match} #{@value}" if @match && @value
    x
  end
end
class Group < Command
  def to_s
    "(#{super.to_s})"
  end
end

this = Command.new 'this'
that = Command.new 'that'

puts this.is('blue').and {that.is('blue').or that.is('green')}.and this.is('yellow')
puts this.is('blue').and Group.new(that.is('blue').or that.is('green')).and this.is('yellow')

puts this.is('blue').or {that.is('blue').and that.is('green').and that.is('yellow')}
puts this.is('blue').or Group.new(that.is('blue').and that.is('green').and that.is('yellow'))