module AccumuloVisibilityParser
  class Evaluator
    attr_reader :roles
    #@@debug = true

    def initialize *roles
      if roles.nil?
        @roles = []
      else
        @roles = roles.flatten
      end
    end

    # return true/false if initialized roles satisifies visibility
    def evaluate visibility=""
      return true if ["",nil].include? visibility
      evaluate_internal AccumuloVisibilityParser.parse(visibility)
    end

    private
    def evaluate_internal tree
      #puts "TREE: #{tree} : #{tree.class}" if @@debug
      #puts "ROLES: #{@roles}" if @@debug
      case tree
      when String
        evaluate_string tree
      when Hash
        evaluate_hash tree
      else
        raise RuntimeError.new("Unexpected parse tree")
      end
    end

    def evaluate_string str
      @roles.include?(str)
    end

    def evaluate_hash hash
      # only key per level
      if hash.keys.size != 1
        raise RuntimeError.new("Unexpected parse, should only be one per level")
      end

      case hash.keys[0].to_s
      when "or"
        evaluate_or hash[:or]
      when "and"
        evaluate_and hash[:and]
      else
        raise RuntimeError.new("Unexpected parse, what is key '#{hash.keys[0]}'?")
      end
    end

    def evaluate_or subtree_array
      if subtree_array.nil? || subtree_array.size == 0
        raise RuntimeError.new("Unexpected parse, subtree_array was empty")
      end
      subtree_array.collect!{ |v| evaluate_internal v }.include?(true)
    end

    def evaluate_and subtree_array
      if subtree_array.nil? || subtree_array.size == 0
        raise RuntimeError.new("Unexpected parse, subtree_array was empty")
      end
      ! subtree_array.collect!{ |v| evaluate_internal v }.include?(false)
    end
  end
end
