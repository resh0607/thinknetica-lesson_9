# frozen_string_literal: true

class Station
  include InstanceCounter
  include Validation
  @@stations = []
  NAME_FORMAT = /^[а-яa-z]+\s?[а-яa-z]*$/i.freeze
  attr_reader :name, :trains

  validate :name, presence: true, format: NAME_FORMAT

  def initialize(name)
    @name = name
    validate!
    validate_station_presence
    @trains = []
    @@stations << self
    register_instance
  end

  def self.all
    @@stations
  end

  def map_trains
    @trains.each do |train|
      yield(train)
    end
  end

  def show_trains_with_type(type)
    @trains.select { |train| train.type == type }
  end

  def receive_train(train)
    @trains << train
  end

  def depart_train(train)
    @trains.delete(train)
  end

  protected

  def validate_station_presence
    raise 'Станция с таким названием уже существует' if @@stations.map(&:name).include?(@name)
  end
end
