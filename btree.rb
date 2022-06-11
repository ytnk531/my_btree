# frozen_string_literal: true

class Entry
  attr_reader :key, :value

  def initialize(key, value)
    @key = key
    @value = value
  end
end

class Node
  attr_reader :entries, :edges
  attr_accessor :parent

  def initialize(entries, edges: [])
    @entries = entries
    @edges = edges
    @max_entries = 4

    @edges.each do
      _1&.parent=self
    end
  end

  def leaf_node?
    @edges.empty?
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
    return self if leaf_node?

    key = entry.key
    edge_index = (0...@entries.size).find(-> { @entries.size }) do |i|
      key < @entries[i].key
    end
    @edges[edge_index].insertion_candidate_of(entry)
  end

  def insert(entry)
    entries.insert(insert_position(entries, entry.key), entry)

    if should_split?
      left, center, right = split(@entries)
      parent.insert_with_node(center, Node.new(left))
      @entries = right
    end
  end

  def insert_with_node(entry, left)
    i = insert_position(entries, entry.key)

    @entries.insert(i, entry)
    @edges.insert(i, left)
  end

  private

  def center_index
    @max_entries / 2
  end

  def insert_position(entries, key)
    (0...entries.size).find(-> { entries.size }) { |i| key < entries[i].key }
  end

  def should_split?
    entries.size > @max_entries
  end

  def split(entries)
    [entries[0...center_index], entries[center_index], entries[center_index + 1..-1]]
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
    pp @root
  end
end

def e(key, value)
  Entry.new(key, value)
end

tree = BTree.new(
  Node.new(
    [e(66, nil), e(78, nil)],
    edges: [
      nil,
      Node.new(
        [
          e(68, nil),
          e(69, nil),
          e(71, nil),
          e(76, nil)
        ]
      ),
      nil
    ]
  )
)
tree.print
tree.insert(e(72, nil))
tree.print

tree = BTree.new(
  Node.new(
    [Entry.new(3, 'C')],
    edges: [
      Node.new([
                 Entry.new(1, 'A'),
                 Entry.new(2, 'B')
               ]),
      Node.new([
                 Entry.new(4, 'D')
               ], edges: [
                 Node.new([Entry.new(2, 'D')]),
                 Node.new([
                            Entry.new(5, 'E'),
                            Entry.new(6, 'E'),
                            Entry.new(7, 'E'),
                            Entry.new(8, 'E')
                          ])
               ])
    ]
  )
)

tree.insert(Entry.new(9, 'x'))
tree.find(9)
tree.print
