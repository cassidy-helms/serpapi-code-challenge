# frozen_string_literal: true

# Album represents a book search result.  Child of MediaType
#
# Usage:
#   book = Book.new(name, extensions, link, image, image_id)
#   heading = Book.heading
class Book
  @@heading = 'Books'

  def self.heading
    @@heading
  end
end
