module AnsiColors
  # Since the Terminal in Lion doesn't support setting the
  # ansi-colors via regular applescript. I need to use GUI
  # scripting. Since I don't want to open the Sys Prefs screen
  # on each color switch, combining them all here.

  def set_ansi_black_color(color);set_ansi_colors(:black => color);end
  def set_ansi_red_color(color);set_ansi_color(:red => color);end
  def set_ansi_green_color(color);set_ansi_colors(:green => color);end
  def set_ansi_yellow_color(color);set_ansi_colors(:yellow => color);end
  def set_ansi_blue_color(color);set_ansi_colors(:blue => color);end
  def set_ansi_magenta_color(color);set_ansi_colors(:magenta => color);end
  def set_ansi_cyan_color(color);set_ansi_colors(:cyan => color);end
  def set_ansi_white_color(color);set_ansi_colors(:white => color);end



  #      set_ansi_colors(:red => aColor, :black => aColor)
  def set_ansi_colors(options = {})
    set_gui_colors = ""
    options.each do |color, value|
      wasko_color = (value.respond_to?(:html) ? value : Wasko::Color.color_from_string(value))
      puts wasko_color.inspect
      set_gui_colors << <<SCRIPT
 click color well #{color_well_index_for_color(color)} of tab group 1 of group 1 of window "Settings"

			tell window "Colors"
				tell tool bar 1
					click (every button whose description is "Color Sliders")
				end tell

				# Selecting RGB
				keystroke "2" using command down

				tell list 1 of group 1 of group 1 of group 1 of group 1 of group 1 of group 1
					# The color field doesn't play nice when it's not selected
					# using a workaround, which I found [here](http://lists.apple.com/archives/applescript-users/2009/Jun/msg00108.html)
					tell text field 1
						set focused to true
						set value to "#{wasko_color.red}"
						keystroke " "
delay 1
					end tell

					tell text field 2
						set focused to true
						set value to "#{wasko_color.green}"
						keystroke " "
delay 1
					end tell

					tell text field 3
						set focused to true
						set value to "#{wasko_color.blue}"
						keystroke " "
delay 1
					end tell
				end tell

				click button 1
			end tell
SCRIPT
    end

    self.set_selected_theme("wasko")
    iets = Wasko::Applescript.run do
      <<SCRIPT
tell application "Terminal"
  activate
  tell application "System Events"
    # Open Preferences
    keystroke "," using command down
    tell process "Terminal"
       click button 2 of tool bar 1 of front window
      # Make sure wasko is selected
      set srows to every row of table 1 of scroll area 1 of group 1 of window 1
      repeat with a_row in srows
        if value of text field 1 of a_row contains "wasko" then
          set selected of a_row to true
          exit repeat
        end if
      end repeat
#{set_gui_colors}
delay 2
      # Close prefs
      click button 1 of front window
    end tell
  end tell
end tell
SCRIPT
    end
    puts iets
  end

  def ansi_colors
    {
      :black => 5,
      :red => 7,
      :green => 9,
      :yellow => 11,
      :blue => 13,
      :magenta => 15,
      :cyan => 17,
      :white => 19
    }
  end

  def color_well_index_for_color(color_name)
    ansi_colors.fetch(color_name.to_sym){ -1 }
  end

end

# tell window "Colors"
# 	#activate
# end tell
# tell window "Colors"
# 	tell tool bar 1
# 		click (every button whose description is "Color Sliders")
# 	end tell

# 	# Selecting RGB
# 	keystroke "2" using command down
# 	tell list 1 of group 1 of group 1 of group 1 of group 1 of group 1 of group 1
# 		set value of text field 1 to "1"
# 		set value of text field 2 to "1"
# 		set value of text field 3 to "1"

# 		click (every text field whose value is "255")
# 		key code 36
# 	end tell
# end tell
