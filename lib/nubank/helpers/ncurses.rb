require 'curses'

include Curses

module NubankCli
  class NCurses
    
    def self.fatura_formatada
      init_screen
      begin
        crmode
      #  show_message("Hit any key")
        setpos((lines - 5) / 2, (cols - 10) / 2)
        addstr("Hit any key")
        refresh
        getch
        # show_message("Hello, World!")
        refresh
      ensure
        close_screen
      end
    end
    
  end
end