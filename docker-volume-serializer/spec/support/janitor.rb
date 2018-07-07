class Janitor
  def initialize
    @blocks = []
  end

  def sweep(block)
    @blocks << block
  end

  def <<(block)
    sweep(block)
  end

  def run!
    @blocks.each { |x| x[] }
    @blocks.clear
  end
end