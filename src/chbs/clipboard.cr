module Chbs
  class Clipboard
    def self.copy(text : String)
      {% if flag?(:win32) %}
        Process.run("clip.exe", input: IO::Memory.new(text), error: :inherit)
      {% elsif flag?(:darwin) %}
        Process.run("pbcopy", input: IO::Memory.new(text), error: :inherit)
      {% else %}
        clipboard_copied = false

        # Try wl-copy first (Wayland)
        if system("command -v wl-copy > /dev/null 2>&1")
          result = Process.run("wl-copy", input: IO::Memory.new(text), error: Process::Redirect::Close)
          clipboard_copied = result.success?
        end

        # Try xclip (X11)
        unless clipboard_copied
          if system("command -v xclip > /dev/null 2>&1")
            result = Process.run("xclip", ["-selection", "clipboard"], input: IO::Memory.new(text), error: Process::Redirect::Close)
            clipboard_copied = result.success?
          end
        end

        # Try xsel (X11)
        unless clipboard_copied
          if system("command -v xsel > /dev/null 2>&1")
            result = Process.run("xsel", ["--clipboard", "--input"], input: IO::Memory.new(text), error: Process::Redirect::Close)
            clipboard_copied = result.success?
          end
        end

        unless clipboard_copied
          raise "No clipboard tool found. Please install xclip, xsel, or wl-copy"
        end
      {% end %}
    end
  end
end
