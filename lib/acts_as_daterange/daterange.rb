module Daterange
  extend ActiveSupport::Concern
  included do
    class_attribute :daterange_config
    validate :daterange_period
  end

  module ClassMethods
    def expire_column
      daterange_config[:expire_column]
    end

    def start_column
      daterange_config[:start_column]
    end

    def active
      where("(#{start_column} IS NULL OR #{start_column} <= :now) AND 
            (#{expire_column} IS NULL OR #{expire_column} > :now)",
            now: Time.now)
    end

    def inactive
      where("#{start_column} > :now OR #{expire_column} < :now",
            now: Time.now)
    end
  end

  def expire_column
    self.class.expire_column
  end

  def start_column
    self.class.start_column
  end

  def expire
    write_attribute(start_column, nil)
    write_attribute(expire_column, Time.now)
  end

  def expire!
    update_attribute(start_column, nil)
    update_attribute(expire_column, Time.now)
  end

  def active?
    started? and not ended?
  end

  private

    def daterange_period
      errors[start_column] << "must be present" if !self[start_column]
      errors[expire_column] << "be present" if !self[expire_column]
      if self[expire_column] < self[start_column]
        errors[expire_column] << "must be after #{start_column}"
      end
    end

    def started?
      start_col = read_attribute(start_column)
      start_col.nil? || start_col < Time.now
    end

    def ended?
      expire_col = read_attribute(expire_column)
      expire_col && expire_col < Time.now
    end
end
