# frozen_string_literal: true

class Wagon
  include Manufacturer
  include Validation
  @@wagons = {}
  ID_FORMAT = /^0[a-z]{1}\d{3}$/i.freeze
  attr_reader :id, :type
  attr_accessor :train

  validate :id, presence: true, format: ID_FORMAT

  def initialize(id)
    @id = id
    validate!
    validate_wagon_presence
    @@wagons[id] = self
  end

  protected

  def validate_wagon_presence
    raise 'Вагон с таким ID уже существует' unless @@wagons[id].nil?
  end
end
