class FileTree
  attr_reader :root

  def self.create!(spec)
    new(Dir.mktmpdir, spec).create
  end

  def initialize(root, spec)
    @root = root
    @tree = spec.lines.map(&:strip).reduce([]) do |tree, line|
      if line.end_with?('/')
        tree << { type: 'd', path: line.sub(/^-/, '').strip }
      else
        tree << { type: 'f', path: line.sub(/^-/, '').strip }
      end
    end
  end

  def inspect
    Dir.glob("#{@root}/**/*")
  end

  def create
    @tree.each do |type:, path:|
      case type
      when 'd'
        FileUtils.mkdir_p("#{root}/#{path}")
      when 'f'
        FileUtils.touch("#{root}/#{path}")
      end
    end

    self
  end
end