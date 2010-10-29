require 'digest/sha2'
class Query < ActiveRecord::Base
  MAX_HASH_LENGTH = 10
  has_friendly_id  :query, :use_slug => true, :strip_non_ascii => true, :max_length => MAX_HASH_LENGTH

  validates_presence_of :source
  validates_presence_of :query
  def normalize_friendly_id(text)
    hash = Digest::SHA2.new << text
    hash.to_s[0..MAX_HASH_LENGTH]
  end
end
