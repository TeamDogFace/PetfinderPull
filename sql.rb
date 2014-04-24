require 'sqlite3'

module SQL
  attr_accessor :conn
  def self.connect
    conn = SQLite3::Database.new "zips.db"
  end

  # Yeah this is super basic
  def self.query(query, params=[])
    conn.execute(query)
  end
end
