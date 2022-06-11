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

  def insertion_candidate_of(entry)
    return self if @edges.empty?

    key = entry.key
    (0...@entries.size).each do |i|
      puts self, i
      return @edges[i].insertion_candidate_of(entry) if key < @entries[i].key
    end
    @edges.last.insertion_candidate_of(entry)
  end

  def insert(entry)
    key = entry.key
    pp @entries
    @entries.prepend(entry) if key < @entries[0].key
    (0...entries.size-1).each do
      if @entries[i].key < key && key < @entries[i+1].key
        @entries.insert(i+1, entry)
        return
      end
    end

    @entries.append(entry)
  end

  def print
    puts "{entries: #{@entries}"
    puts "edges ["
    @edges.each { _1.print }
    puts "]}"
  end
end

class BTree
  def initialize(root)
    @root = root
  end

  def find(key)
    @root.find(key)
  end

  def insert(entry)
    c = @root.insertion_candidate_of(entry)
    c.insert(entry)
  end

  def print
    @root.print
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
puts tree.insert(Entry.new(7, "x"))
puts tree.print
puts tree.find(7)

