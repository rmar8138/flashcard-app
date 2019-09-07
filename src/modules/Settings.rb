require "json"
require "tty-prompt"

module Settings
  @path_to_settings = "./settings/settings.json"

  def self.get
    if File.exist?(@path_to_settings)
      return JSON.parse(
        File.read(@path_to_settings), 
        symbolize_names: true
      )
    else  
      return {
        shuffled_reviews: true,
        timed_reviews: false,
      }
    end
  end

  def self.save(updated_settings)
    File.open(@path_to_settings, "w") do |file| 
      file.write(JSON.generate(updated_settings))
    end
  end

  def self.update_settings(updated_settings)
    self.save(updated_settings)
    return self.get
  end

end
