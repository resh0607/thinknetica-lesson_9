# frozen_string_literal: true

class Train
  attr_reader :current_speed, :wagons, :current_station, :number, :type
  include Manufacturer
  include InstanceCounter
  @@trains = {}

  NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/i.freeze

  def initialize(number)
    @number = number
    validate!
    @wagons = []
    @current_speed = 0
    @@trains[number] = self
    register_instance
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def map_wagons
    @wagons.each do |wagon|
      yield(wagon)
    end
  end

  def self.find(number)
    @@trains[number].nil? ? nil : @@trains[number]
  end

  def speed_up(num)
    @current_speed += num
  end

  def stop
    @current_speed = 0
  end

  def add_wagon(wagon)
    raise 'Поезд находится в движении или не совпадают типы поезд/вагон.' unless idle? && type == wagon.type

    @wagons << wagon
    wagon.train = self
  end

  def remove_wagon(wagon)
    raise 'Невозможно отцепить вагон, когда поезд движется' unless idle?

    @wagons.delete(wagon)
    wagon.train = nil
  end

  def set_route(route)
    @route = route
    @current_station = @route.stations.first
    @current_station.receive_train(self)
  end

  def previous_station
    raise 'Нет станции, текущая станция - начальная' if @current_station == @route.stations.first

    @route.stations[@route.stations.index(@current_station) - 1]
  end

  def next_station
    raise 'Нет станции, текущая станция - конечная' if @current_station == @route.stations.last

    @route.stations[@route.stations.index(@current_station) + 1]
  end

  def go_forward
    @current_station.depart_train(self)
    @current_station = next_station
    @current_station.receive_train(self)
  end

  def go_back
    @current_station.depart_train(self)
    @current_station = previous_station
    @current_station.receive_train(self)
  end

  protected

  def idle?
    return true if @current_speed.zero?
  end

  def validate!
    validate_train_number
    validate_train_presence
  end

  def validate_train_number
    raise 'Неверный формат номера поезда' if @number !~ NUMBER_FORMAT
  end

  def validate_train_presence
    raise 'Поезд с таким номером уже существует' unless @@trains[number].nil?
  end
end
