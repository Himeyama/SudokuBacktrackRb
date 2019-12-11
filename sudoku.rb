class SudokuTable < Array
    # 特異メソッド
    def self.[] *table
        s = SudokuTable.new
        s.table = table
        s
    end

    def self.str str
        s = SudokuTable.new
        s.table = str.each_line.to_a.map{|e| e.chomp.split("").map(&:to_i)}
        s
    end

    # インスタンスメソッド
    def initialize
        @list = {}
        super Array.new(9){Array.new(9){0}}
    end

    def table= ary
        9.times do |i|
            9.times do |j|
                self[i][j] = ary[i][j]
            end
        end
    end

    def print
        self.map do |rows|
            rows.map do |e|
                Kernel.print "#{"%2d" % e}"
            end
            puts
        end
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
            # print
            # p @list
        end
        @lpos = Array.new(@list.size){0}
        @lary = @list.to_a
        @lidx = 0

        while @lidx < @list.size do
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

    attr_accessor :list, :lpos, :lidx
end

# table = [
#     [1, 0, 0, 0, 0, 3, 0, 0, 0],
#     [0, 4, 0, 9, 6, 0, 0, 0, 0],
#     [6, 0, 0, 0, 0, 0, 8, 0, 0],
#     [0, 0, 0, 8, 0, 6, 0, 0, 4],
#     [0, 0, 2, 0, 0, 0, 0, 1, 0],
#     [0, 0, 5, 0, 0, 7, 0, 3, 0],
#     [0, 5, 0, 1, 7, 0, 0, 0, 0],
#     [0, 0, 9, 0, 0, 0, 0, 7, 0],
#     [0, 0, 0, 0, 0, 0, 3, 0, 2]
# ]
# s = SudokuTable[*table]

s = SudokuTable.str "\
100003000
040960000
600000800
000806004
002000010
005007030
050170000
009000070
000000302"

s.run
s.print
