class StudentDatabase

  def deleteDatabase
  # StudentDatabase.drop_database
    File.delete('scraper.db')
  end

  def createDatabase
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
  end 
end
