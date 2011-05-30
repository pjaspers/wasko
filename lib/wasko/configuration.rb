require "fileutils"

module Wasko
  # This class will handle all things considering
  # loading and saving configuration. It should work
  # like this.
  #
  #  * User sets all things to his liking
  #  * User writes to a `.color` file in `~/.wasko`
  #  * User can share/edit this `.color` file
  #  * User can load `.color` file to restore settings
  #
  class Configuration
    class << self

      # All config files are stored in `~/.wasko/`
      def wasko_directory
        wasko_path = File.join(ENV['HOME'], ".wasko")
        unless File.exists?(wasko_path) && File.directory?(wasko_path)
          FileUtils.mkdir_p File.join(ENV['HOME'], ".wasko")
        end
        wasko_path
      end

      # All possible `.color` themes
      def all_themes
        Dir.chdir(wasko_directory) do |path|
          Dir["*.color"].map do |filename|
            filename.gsub(/\.color$/, "")
          end
        end
      end

      # Blatantly stolen from [here](http://stackoverflow.com/questions/1032104/regex-for-finding-valid-filename)
      # Spots all obvious bad filenames
      def valid_name?(name)
        name =~ /^[^\/?*:;{}\\]+$/
      end

      # File path of the color theme file
      def config_file_with_name(name)
        File.join(wasko_directory, "#{name}.color")
      end

      # Setup the color theme with the hash.
      def color_theme_from_hash(name)
        return {} unless all_themes.include?(name)
        return {} unless Hash === YAML::load(File.open(config_file_with_name(name)))
        YAML::load(File.open(config_file_with_name(name)))
      end

      # Transform a color theme to a hash
      def color_theme_to_hash
        %w(background_color foreground_color bold_color cursor_color font_size font_name).inject({}) do |hash, value|
          hash[value] = Wasko.send(value)
          hash
        end
      end

      # ## Loading and saving colors

      # Draw the saved colors
      def load_colors!(name)
        color_theme_from_hash(name).each do |object, color|
          Wasko.send("set_#{object}", color)
        end
      end

      # Write out the colors
      def save_colors!(name)
        File.open(config_file_with_name(name), 'w') do |out|
          out.write(configuration_help)
          out.write(color_theme_to_hash.to_yaml)
        end
      end

      def configuration_help
        <<HELP
# This is a theme used by the wasko gem, it's nothing
# more than regular yaml. So (ab)use as you would normally
# do. The only thing to note is, colors take only valid
# css colors and this comment can be deleted.
HELP
      end
    end
  end
end
