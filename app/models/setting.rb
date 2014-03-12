class Setting < ActiveRecord::Base

  attr_accessible :field_name, :field_type, :field_value

  validates :field_name, presence: true, uniqueness: true, length: {minimum: 3, maximum: 45}
  validates :field_type, presence: true, length: {minimum: 3, maximum: 45}
  validates :field_value, presence: true, length: {minimum: 3, maximum: 45}

  def self.get_val(name)
    self.where('field_name = :user_val', user_val: name)
  end

  def self.set_val(name, value, type)
    self.create(field_name: name, field_value: value, field_type: type)
  end

  def update_val(name, value, type)
    self.update_attributes(field_value: value, field_type: type)
  end

  def cached_setting(name)
    Rails.cache.fetch("cached_setting_#{name}") do
      Setting.where('field_name = :term', term: name)
    end
  end

end