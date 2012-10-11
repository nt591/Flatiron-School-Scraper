require 'sqlite3'
require 'nokogiri'
require 'open-uri'
# require_relative 'student_database'

# StudentDatabase.drop_database
File.delete('scraper.db')

# StudentDatabase.create_database
db = SQLite3::Database.new "scraper.db"
  rows = db.execute <<-SQL
    create table students (
      id integer,
      name varchar(255),
      tagline varchar(140),
      image_url varchar(255),
      bio text,
      email varchar(255),
      blog varchar(255),
      linkedin varchar(255),
      twitter varchar(255),
      fav_apps_one text,
      fav_apps_two text,
      fav_apps_three text,
      codeschool varchar(255),
      github varchar(255),
      coderwall varchar(255),
      stack varchar(255),
      treehouse varchar(255)
    );
  SQL

index_url = 'http://students.flatironschool.com/index.html'
index_doc = Nokogiri::HTML(open(index_url))

profile_urls = index_doc.css('div.one_third a').map {|link| "http://students.flatironschool.com/#{link['href']}" }


profile_urls.each_with_index do |profile_url, index|
  id = index + 1
  profile_doc = Nokogiri::HTML(open(profile_url))

  def escape(text)
    text = "text" if text.nil?
    text.gsub!('"', '""')
    text.gsub!("'", "''")
    text.strip!
    text
  end

  @id = id
  @name = "#{profile_doc.css('div.two_third h1').text}"
  @tagline = "#{profile_doc.css('div.two_third h2:first').text}"
  @image_url =  "image should go here"
  @bio = "#{profile_doc.css('.two_third p').text}"
  @email = "#{profile_doc.xpath("//li[@class='mail']//a/@href")}"
  @blog = "#{profile_doc.xpath("//li[@class='blog']//a/@href")}"
  @linkedin = "#{profile_doc.xpath("//li[@class='linkedin']//a/@href")}"
  @twitter = "#{profile_doc.xpath("//li[@class='twitter']//a/@href")}"
  @fav_apps_one = "#{profile_doc.css('div.two_third div.one_third:nth-of-type(1)').text}"
  @fav_apps_two   = "#{profile_doc.css('div.two_third div.one_third:nth-of-type(2)').text}"
  @fav_apps_three = "#{profile_doc.css('div.two_third div.one_third:nth-of-type(3)').text}"
  @codeschool = "#{profile_doc.xpath("//div[@class='one_fifth'][2]//a/@href")}"
  @github = "#{profile_doc.xpath("//div[@class='one_fifth'][1]//a/@href")}"
  @coderwall = "#{profile_doc.xpath("//div[@class='one_fifth'][3]//a/@href")}"
  @stack = "#{profile_doc.xpath("//div[@class='one_fifth'][4]//a/@href")}"
  @treehouse = "#{profile_doc.xpath("//div[@class='one_fifth last']//a/@href")}"

  @email = escape(@email)
  @bio = escape(@bio)
  @tagline = escape(@tagline)
  @blog = escape(@blog)
  @linkedin = escape(@linkedin)
  @twitter = escape(@twitter)
  @codeschool = escape(@codeschool)
  @github = escape(@github)
  @coderwall = escape(@coderwall)
  @stack = escape(@stack)
  @treehouse = escape(@treehouse)
  @fav_apps_one = escape(@fav_apps_one)
  @fav_apps_two = escape(@fav_apps_two)
  @fav_apps_three = escape(@fav_apps_three)

  sql = "INSERT INTO students(id, name, tagline, image_url, bio, email, blog, linkedin, twitter, fav_apps_one, fav_apps_two, fav_apps_three, codeschool, github, coderwall, stack, treehouse) 
            VALUES(#{@id}, \"#{@name}\",\"#{@tagline}\",\"#{@image_url}\",\"#{@bio}\",\"#{@email}\",\"#{@blog}\",\"#{@linkedin}\",\"#{@twitter}\",\"#{@fav_apps_one}\",
                            \"#{@fav_apps_two}\",\"#{@fav_apps_three}\",\"#{@codeschool}\",\"#{@github}\",\"#{@coderwall}\",\"#{@stack}\",\"#{@treehouse}\");"

  puts sql
  db.execute(sql)
end

