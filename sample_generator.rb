#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require "rubygems"
require "wasko"

# Quick and simple class to see output of a generated
# color scheme.
class WaskoGenerator
  # Initialize with a color (color can be any css-valid color)
  def initialize(color_string = nil)
    @palette = Wasko::Palette.new(color_string) if color_string
  end

  def to_html!
    File.open("samples.html", 'w') do |f|
      if @palette
        f.write self.class.wrap_in_html{ html_palette}
      else
        f.write self.class.wrap_in_html{ rainbow_palette}
      end
    end
  end

  def html_palette
    html = ""
    @palette.colors.each do |color_name, color|
      html << "<div class=\"color\" style=\"background-color: #{color.html}\">"
      html << "\t <p>#{color_name} #{color.html}</p>"
      html << "</div>"
    end
    html
  end

  def rainbow_palette
    html = ""
    %w(black red green yellow blue white).each do |color_string|
      palette = Wasko::Palette.new(color_string)
      html << "<div class=\"colorblock\">"
      html << "<h3>#{color_string}</h3>"
      palette.colors.each do |color_name, color|
        html << "<div class=\"color\" style=\"background-color: #{color.html}\">"
        html << "\t <p>#{color_name} #{color.html}</p>"
        html << "</div>"
      end
      html << "</div>"
    end
    html
  end

  def self.wrap_in_html
  <<HEADER
<html>
  <head>
    <style type="text/css" media="screen">
      .colorblock {
float:left;
width: 300px;
padding-left:10px;
}
      .color {
       display: block;
       width: 300px;
       height: 30px;
       background-color: yellow;
      padding: 10px;
      }
      .color p {
       margin: 10px;
       background: white ; opacity: 0.2;
      }
    </style>
  </head>
  <body>
    #{yield}
  </body>
</html>
HEADER
  end
end

WaskoGenerator.new(ARGV.first).to_html!





