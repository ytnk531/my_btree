class Entry
  attr_reader :key, :value

  def initialize(key, value)
    @key = key
    @value = value
  end

  def to_s
    "#{super} #{@key}, #{@value}"
  end
end

class Node
  attr_reader :entries, :edges

  def initialize(entries, edges: [])
    @entries = entries
    @edges = edges
  end

  def find(key)
    (0...@entries.size).each do |i|
      if @entries[i].key == key
        return @entries[i]
      elsif key < @entries[i].key
        return @edges[i].find(key)
      end
    end
    @edges.last.find(key)
  end
end

class BTree
  def initialize(root)
    @root = root
  end

  def find(key)
    @root.find(key)
  end
end

tree = BTree.new(
           Node.new(
             [Entry.new(3, "C")],
           edges: [
               Node.new([
                 Entry.new(1, "A"),
                 Entry.new(2, "B")
               ]),
               Node.new([
                 Entry.new(4, "D"),
               ], edges: [
                 Node.new([Entry.new(2, "D")]),
                 Node.new([Entry.new(5, "E")])
               ]
                       )
             ]
          )
)

puts tree.find(5)

