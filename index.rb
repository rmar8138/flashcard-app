

welcome_menu_open = true

while welcome_menu_open
  # WELCOME SCREEN
  puts "\n\n\n"
  puts "Welcome to the terminal flash card app!"
  puts "\n"
  puts "Please select an option by typing in the number to the left:"
  puts "\n\n"
  puts "(1) Review\n(2) Add deck\n(3) Edit deck\n(4) Settings\n(5) Exit"
  puts "\n\n\n"

  option = gets.chomp

  case option
  when "1"
    system "clear"
    puts "Review!"

    welcome_menu_open = false
  when "2"
    system "clear"
    puts "Add!"

    welcome_menu_open = false
  when "3"
    system "clear"
    puts "Edit!"

    welcome_menu_open = false
  when "4"
    system "clear"
    puts "Settings!"

    welcome_menu_open = false
  when "5"
    system "clear"
    puts "Cya!"

    welcome_menu_open = false
  else
    system "clear"
    puts "Invalid input, please try again"
    next
  end
end
