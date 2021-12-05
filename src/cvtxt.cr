require "json"
require "colorize"
require "option_parser"

module Cvtxt
  extend self

  CVUSER_FILE = "cvuser.txt"
  COOKIE_FILE = "cookie.txt"

  def extract_uname(json : String)
    NamedTuple(props: NamedTuple(uname: String)).from_json(json)[:props][:uname]
  end

  def login_user(email = nil, upass = nil) : String
    puts "Đăng nhập Chivi".colorize.cyan

    while !email
      print "Email: "
      email = gets.try(&.strip)
    end

    while !upass
      print "Password: "
      upass = gets.try(&.strip)
    end

    url = "https://chivi.app/api/user/login"
    json = `curl -s #{url} -c #{COOKIE_FILE} -F "email=#{email}" -F "upass=#{upass}"`

    extract_uname(json).tap do |cvuser|
      File.write(CVUSER_FILE, cvuser)
    end
  rescue err
    puts "Thông tin đăng nhập không chính xác!".colorize.red
    exit 1
  end

  def check_login(cvuser : String)
    if cvuser.empty? || !File.exists?(COOKIE_FILE)
      puts "Bạn chưa đăng nhập!".colorize.red
      exit 1
    end

    json = `curl -s https://chivi.app/api/_self -b #{COOKIE_FILE}`
    return unless extract_uname(json) != cvuser

    puts "Thông tin đăng nhập không chính xác!".colorize.red
    exit 1
  end

  def read_cvuser(file = "cvuser.txt")
    return "" unless File.exists?(file)
    File.read(file)
  end
end

cvuser = Cvtxt.read_cvuser

login_user = false
check_login = false

OptionParser.parse(ARGV) do |parser|
  parser.on("login", "Đăng nhập") do
    login_user = true
    parser.banner = "Usage: cvtxt login"
  end

  parser.on("check", "Kiểm tra thông tin đăng nhập") do
    check_login = true
    parser.banner = "Usage: cvtxt check"
  end
end

if login_user
  cvuser = Cvtxt.login_user
  puts "Xin chào, #{cvuser} :)".colorize.yellow
end

if check_login
  Cvtxt.check_login(cvuser)
  puts "Thông tin đăng nhập chính xác!".colorize.yellow
end
