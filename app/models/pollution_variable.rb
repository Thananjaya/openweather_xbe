class PollutionVariable < ApplicationRecord
  belongs_to :location

  AQI_STATUS = {
    1 => 'good',
    2 => 'fair',
    3 => 'moderate',
    4 => 'poor',
    5 => 'very poor'
  }
end
