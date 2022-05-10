require "json"
require "colorize"
require "option_parser"

require "./login"
require "./split"

module Cvtxt
  cvuser = Login.read_cvuser

  login_user = false
  check_login = false

  split_text = false
  files_to_split = [] of String

  SPLITTER = Split.new

  OptionParser.parse(ARGV) do |parser|
    parser.on("login", "Đăng nhập") do
      login_user = true
      parser.banner = "Usage: cvtxt login"
    end

    parser.on("check", "Kiểm tra thông tin đăng nhập") do
      check_login = true
      parser.banner = "Usage: cvtxt check"
    end

    parser.on("split", "Phân tách chương tiết") do
      split_text = true

      parser.on("-e ENCODING", "Thông tin mã hoá ký tự") do |e|
        SPLITTER.set_encoding(e)
      end

      parser.on("-m SPLIT_MODE", "Phương thức phân tách chương") do |m|
        SPLITTER.split_mode = m.to_i
      end

      parser.on("--re REGEX", "Phân tách chương thông qua regular expression") do |re|
        SPLITTER.split_re_x = Regex.new(re)
      end

      parser.unknown_args do |args|
        files_to_split = args
      end
    end
  end

  if login_user
    cvuser = Login.login_user
    puts "Xin chào, #{cvuser} :)".colorize.yellow
  end

  if check_login
    Login.check_login(cvuser)
    puts "Thông tin đăng nhập chính xác!".colorize.yellow
  end

  if split_text
    files_to_split.each { |file| SPLITTER.split(file) }
  end
end
