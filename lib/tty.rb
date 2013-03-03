def colorize(text, color_code)
  "\e[#{color_code}#{text}\e[0m"
end

# standard operating procedure
def grey(text)
  colorize(text, ENV["TTY_GREY"] || "37m")
end

# bad stuff
def red(text)
  colorize(text, ENV["TTY_RED"] || "31m")
end

# good stuff
def green(text)
  colorize(text, ENV["TTY_GREEN"] || "32m")
end

# staging color and for warnings
def yellow(text)
  colorize(text, ENV["TTY_YELLOW"] || "33m")
end

# for boot and important notes
def blue(text)
  colorize(text, ENV["TTY_BLUE"] || "34m")
end

def magenta(text)
  colorize(text, ENV["TTY_MAGENTA"] || "35m")
end

# not at all critical or unimplemented
def purple(text)
  colorize(text, ENV["TTY_PURPLE"] || "36m")
end