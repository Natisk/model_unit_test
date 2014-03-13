class Setting < ActiveRecord::Base

  attr_accessible :field_name, :field_type, :field_value

  validates :field_name, presence: true, uniqueness: true, length: {minimum: 3, maximum: 45}
  validates :field_type, presence: true, length: {minimum: 3, maximum: 45}
  validates :field_value, presence: true, length: {minimum: 1, maximum: 45}

  def self.get(name)
    Rails.cache.fetch("cached_#{name}") do
      Setting.where('field_name = :term', term: name).first
    end
  end

  def self.set(name, value)
    obj = Setting.where('field_name = :term', term: name).first
    type = value.class.to_s
    if obj.blank?
      Setting.create(field_name: name, field_value: value, field_type: type)
    else
      obj.update_attributes(field_name: name, field_value: value, field_type: type)
    end
  end

  def self.unset(*args)
    args.each do |arg|
      to_del = Setting.get(arg)
      to_del.destroy
    end
  end

end