# frozen_string_literal: true

class TrainPass < Train
  def initialize(number)
    super
    @type = 'Пассажирский'
  end
end
