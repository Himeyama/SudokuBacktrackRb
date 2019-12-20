class SudokuTable < Array
    # 特異メソッド
    def self.[] *table
        s = SudokuTable.new
        s.table = table
        s.existNumber
        s
    end

    def self.str str
        s = SudokuTable.new
        s.table = str.each_line.to_a.map{|e| e.chomp.split("").map(&:to_i)}
        s.existNumber
        s
    end

    # インスタンスメソッド
    def initialize
        @list = {}
        @anime = false
        super Array.new(9){Array.new(9){0}}
        existNumber
    end

    def table= ary
        9.times do |i|
            9.times do |j|
                self[i][j] = ary[i][j]
            end
        end
    end

    def existNumber
        @existNum = Array.new(9){Array.new(9){0}}
        9.times do |i|
            9.times do |j|
                @existNum[i][j] = (self[i][j] == 0 ? false : true)
            end
        end
    end

    def print
        9.times do |i|
            9.times do |j|
                if @existNum[i][j]
                    Kernel.print "#{"%2d" % self[i][j]}"
                else
                    Kernel.print "\e[7m#{self[i][j] == 0 ? "  " : ("%2d" % self[i][j])}\e[0m"
                end
            end
            puts
        end
        Kernel.print "\e[9A\e[9D"
    end
    
    def play
        9.times do |i|
            9.times do |j|
                if self[i][j] == 0
                    search i, j
                end
            end
        end
    end

    def search i, j
        ary = (1..9).to_a
        b = i / 3 * 3, j / 3 * 3
        e = b[0] + 2, b[1] + 2
        (b[0]..e[0]).each do |x|
            (b[1]..e[1]).each do |y|
                ary.delete self[x][y]
            end
        end
        9.times do |n|
            ary.delete self[i][n]
            ary.delete self[n][j]
        end
        @list[[i, j]] = ary
    end

    def check? x, y, num
        b = x / 3 * 3, y / 3 * 3
        e = b[0] + 2, b[1] + 2
        (b[0]..e[0]).each do |i|
            (b[1]..e[1]).each do |j|
                if num == self[i][j]
                    return false
                end
            end
        end
        9.times do |n|
            if num == self[x][n] || num == self[n][y]
                return false
            end
        end
        true
    end

    def opt
        @list.each do |k, v|
            if v.size == 1
                self[k[0]][k[1]] = v[0]
                @list.delete k
            end
        end
    end

    def run
        @old_list = nil
        while @old_list != @list
            f = false
            @old_list = @list.clone
            play
            opt
        end
        @lpos = Array.new(@list.size){0}
        @lary = @list.to_a
        @lidx = 0

        while @lidx < @list.size do
            print if @anime
            if check? @lary[@lidx][0][0], @lary[@lidx][0][1], @lary[@lidx][1][@lpos[@lidx]]
                self[@lary[@lidx][0][0]][@lary[@lidx][0][1]] = @lary[@lidx][1][@lpos[@lidx]]
                @lidx += 1
            else
                if (@lary[@lidx][1].size - 1) <= @lpos[@lidx]
                    backtrack
                else
                    @lpos[@lidx] += 1
                end
            end
        end
        print
        Kernel.print "\e[9B"
    end

    def backtrack
        @lpos[@lidx] = 0
        @lidx -= 1
        self[@lary[@lidx][0][0]][@lary[@lidx][0][1]] = 0
        if (@lary[@lidx][1].size - 1) <= @lpos[@lidx]
            backtrack
        else
            @lpos[@lidx] += 1
        end
    end

    def func1 xg, yg
        b = xg * 3, yg * 3
        e = xg * 3 + 2, yg * 3 + 2
        ary = []
        play
        (b[0]..e[0]).each do |i|
            (b[1]..e[1]).each do |j|
                ary << @list[[i, j]] if @list[[i, j]]
            end
        end
        ary_h = ary.flatten.uniq.map{|e| [e, ary.flatten.count(e)]}.to_h
        ary_k = ary_h.keys
        ary_v = ary_h.values
        ary_v.each.with_index do |v, i|
            if v == 1
                num = ary_k[i] # 5
                (b[0]..e[0]).each do |i|
                    (b[1]..e[1]).each do |j|
                        if @list[[i, j]]&.include? num
                            puts "(#{i}, #{j}) = #{num}"
                            @list.delete([i, j])
                            self[i][j] = num
                            old_list = nil
                            while old_list != @list
                                f = false
                                old_list = @list.clone
                                play
                                opt
                            end
                        end
                    end
                end
            end
        end
    end

    def func2 x
        ary = []
        play
        (0..9).each do |j|
            ary << @list[[x, j]] if @list[[x, j]]
        end
        ary_h = ary.flatten.uniq.map{|e| [e, ary.flatten.count(e)]}.to_h
        ary_k = ary_h.keys
        ary_v = ary_h.values
        ary_v.each.with_index do |v, i|
            if v == 1
                num = ary_k[i] # 5
                (b[0]..e[0]).each do |i|
                    (b[1]..e[1]).each do |j|
                        if @list[[i, j]]&.include? num
                            puts "(#{i}, #{j}) = #{num}"
                            @list.delete([i, j])
                            self[i][j] = num
                            old_list = nil
                            while old_list != @list
                                f = false
                                old_list = @list.clone
                                play
                                opt
                            end
                        end
                    end
                end
            end
        end
    end

    def func3 y
        ary = []
        play
        (0..9).each do |i|
            ary << @list[[i, y]] if @list[[i, y]]
        end
        ary_h = ary.flatten.uniq.map{|e| [e, ary.flatten.count(e)]}.to_h
        ary_k = ary_h.keys
        ary_v = ary_h.values
        ary_v.each.with_index do |v, i|
            if v == 1
                num = ary_k[i] # 5
                (b[0]..e[0]).each do |i|
                    (b[1]..e[1]).each do |j|
                        if @list[[i, j]]&.include? num
                            puts "(#{i}, #{j}) = #{num}"
                            @list.delete([i, j])
                            self[i][j] = num
                            old_list = nil
                            while old_list != @list
                                f = false
                                old_list = @list.clone
                                play
                                opt
                            end
                        end
                    end
                end
            end
        end
    end

    attr_writer :anime
    attr_accessor :list
end

s = SudokuTable.str "\
000020900
028100000
000500024
360000100
700001345
840000200
000300061
036800000
000010500"

s.anime = true
s.run
