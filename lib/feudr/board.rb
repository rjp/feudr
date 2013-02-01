require 'feudr/client'

$has_rmagick = true

begin
    require 'RMagick'
rescue LoadError
    $stderr.puts "Cannot draw graphical boards without RMagick"
    $has_rmagick = false
end

module Feudr
    class Client
        def board_graphic(board_id)
            unless $has_rmagick then
                return nil
            end
            board_layout = self.board(board_id)['content']['board']
            board = Magick::Image.new(76, 76) { self.background_color = 'black' }
            board.format = 'PNG'
            gc = Magick::Draw.new
            colors = ['333333','448844', '4444CC', 'CC8822', 'AA2222']
            board_layout.each_with_index do |row, y|
                row.each_with_index do |cell, x|
                    color = '#' + colors[cell]
                    gc.fill(color)
                    gc.stroke(color)
                    gc.rectangle(1+5*x, 1+5*y, 4+5*x, 4+5*y)
                end
            end
            gc.draw(board)
            return board.to_blob()
        end
    end
end
