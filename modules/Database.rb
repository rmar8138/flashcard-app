require "json"

module Database
  @path_to_database = "./database/database.json"

  def self.get
    return File.exist?(@path_to_database) ? JSON.parse(File.read(@path_to_database), symbolize_names: true) : {}
  end

  def self.save(updated_database)
    File.open(@path_to_database, "w") { |file| file.write(JSON.generate(updated_database))}
  end
end