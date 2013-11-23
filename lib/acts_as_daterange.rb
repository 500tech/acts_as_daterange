require "acts_as_daterange/version"
require 'active_record'
require 'active_support/concern'
require 'acts_as_daterange/daterange'

class ActiveRecord::Base
  extend ActsAsDaterange
end

module ActsAsDaterange
  #  acts_as_daterange
  #  acts_as_daterange :started_at, :ended_at
  #  acts_as_daterange start_date: :started_at, end_date: :ended_at
  def acts_as_expirable(*args, start_date: nil, end_date: nil)
    include Daterange

    if args.present?
      if start_date || end_date || args.count != 2
        raise ArgumentError.new("ActsAsDaterange: must have both start_date and end_date")  
      end
      start_column,expire_column = args
    elsif start_date || end_date
      if !start_date || !end_date
        raise ArgumentError.new("ActsAsDaterange: must have both start_date and end_date")
      end
      start_column,expire_column = start_date, end_date
    end
      
    self.daterange_config = {
      start_column: start_column || 'start_date',
      expire_column: expire_column || 'end_date'
    }
  end
end
