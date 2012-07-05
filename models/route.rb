class Route < ActiveRecord::Base
  belongs_to :category
  before_save :generate_regexp
  validates_presence_of :name, :method # FIXME: use path instead of name

  def self.match(str)
    for route in all
      regexp = Regexp.new(route.regexp)
      if regexp.match str
        return route
      end
    end
    nil
  end

  private

  def generate_regexp
    regexp = name.gsub /:(\w+)/ do |_|
      case $1
      when 'id', 'number', 'issue_number', 'gist_id'
        '[0-9]+'
      when 'user', 'repo', 'org'
        '[0-9a-zA-Z-]+'
      when 'sha'
        '[0-9a-f]'
      when 'ref'
        '\w+(\/\w+){2}'
      end
    end
    self.regexp = "\\A#{regexp}\\Z"
  end
end