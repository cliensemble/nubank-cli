require 'curses'
require_relative 'parse'

include Curses

module NubankCli
  class NCurses
    
    def self.fatura_formatada(json)
      init_screen
      begin
        crmode
      #  show_message("Hit any key")
        setpos((lines - 5) / 2, (cols - 10) / 2)
        # addstr("Hit any key")
        Parse.fatura_formatada(json)
        refresh
        getch
        refresh
      ensure
        close_screen
      end
    end
    
  end
end