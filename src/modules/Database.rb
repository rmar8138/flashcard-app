require "json"
require "tty-prompt"

module Database
  @path_to_database = "./database/database.json"

  def self.get
    return File.exist?(@path_to_database) ? JSON.parse(File.read(@path_to_database), symbolize_names: true) : []
  end

  def self.save(updated_database)
    File.open(@path_to_database, "w") { |file| file.write(JSON.generate(updated_database))}
  end

  def self.update_database(updated_database)
    self.save(updated_database)
    return self.get
  end

  def self.select_deck(message)
    prompt = TTY::Prompt.new

    deck = prompt.select(message, per_page: 8, cycle: true, echo: false) do |menu|
      menu.enum "."
      count = 0
      for deck in self.get
        menu.choice({deck[:title] => count})
        count += 1
      end
      menu.choice("Exit")
    end
  end
end