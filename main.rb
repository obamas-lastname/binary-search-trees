class Node
    attr_accessor :data, :left, :right

    def initialize(value)
        @data = value
        @left = nil
        @right = nil
    end
end


class Tree
    attr_accessor :root, :elements

    def build_tree(array)
        return nil if array.empty? 
        array = array.uniq
        array = array.sort
        @elements = array
        mid = (array.count)/2
        root = Node.new(array[mid])
        root.left = build_tree(array[0...mid])
        root.right = build_tree(array[mid+1..-1])
        @root = root
        return root
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        return if node.nil?
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end

    def insert(value)
        @elements << value
        @root = insert_recursive(@root, value)
    end
    
    def insert_recursive(node, value)
        if node.nil?
          return Node.new(value)
        end
    
        if value < node.data
          node.left = insert_recursive(node.left, value)
        elsif value > node.data
          node.right = insert_recursive(node.right, value)
        end
        
        return node
    end

    def delete(value)
        @root = delete_recursive(@root, value)
    end

    def delete_recursive(root, k)
        return if root.nil?
        if root.data > k
            root.left = delete_recursive(root.left, k)
            return root
        elsif root.data < k 
            root.right = delete_recursive(root.right, k)
            return root
        end

        if root.left.nil?
            temp = root.right
            root = nil
            return temp
        elsif root.right.nil?
            temp = root.left
            root = nil
            return temp

        else
            succParent = root
            succ = root.right
            while !succ.left.nil?
                succParent = succ
                succ = succ.left
            end

            if succParent != root
                succParent.left = succ.right
            else
                succParent.right = succ.right
            end

            root.data = succ.data
            succ = nil
            return root
        end
    end

    def level_order(node = @root)
        queue = Queue.new
        queue << node
        while !queue.empty?
            current = queue.pop
            puts current.data
            unless current.left.nil?
                queue << current.left
            end
            unless current.right.nil?
                queue << current.right
            end
        end
    end

    def inorder(node=@root)
        if !node.nil?
            inorder(node.left)
            yield node.data
            inorder(node.right)
        end
        
    end

    def preorder(node=@root)
        if !node.nil?
            yield node.data
            preorder(node.left)
            preorder(node.right)
        end
    end

    def postorder(node=@root)
        if !node.nil?
            postorder(node.left)
            postorder(node.right)
            yield node.data
        end
    end

    def height(node=@root)
        if node.nil?
            return 0
        else
            left_h = height(node.left)
            right_h = height(node.right)

            return [left_h, right_h].max + 1
        end
    end

    def depth(root=@root, node)
        if node.nil?
            return 0
        elsif node == root
            return -1
        end

        dist = depth(root.left, node)
        if dist >= 0
            return dist+1
        end
        dist = depth(root.right, node)
        if dist>=0
            return dist+1
        end
        return dist
    end

    def balanced?()
        if height(@root.left) - height(@root.right) > 1
            return false
        elsif height(@root.left) - height(@root.right) < -1
            return false
        end
        return true
    end
    
    
end

def rebalance(tree)
    newtree = Tree.new()
    tree.inorder()
    puts tree.elements
    newtree.build_tree(tree.elements)
    return newtree
end

arr = Array.new(15) { rand(1..100) }
tree = Tree.new()
tree.build_tree(arr)
tree.pretty_print()
puts tree.balanced?()
