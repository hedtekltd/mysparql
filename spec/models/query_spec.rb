require 'spec_helper'

describe Query do
  it {should validate_presence_of :source}
  it {should validate_presence_of :query}
end
