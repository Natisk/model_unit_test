require 'test_helper'

class SettingTest < ActiveSupport::TestCase

  test 'should not save setting without name' do
    setting = Setting.new(field_type: 'bool', field_value: 'true')
    assert !setting.save
  end

  test 'should not save setting without type' do
    setting = Setting.new(field_name: 'registered', field_value: 'true')
    assert !setting.save
  end

  test 'should not save setting without value' do
    setting = Setting.new(field_name: 'registered', field_type: 'bool')
    assert !setting.save
  end

  test 'should not save setting where name is not uniq' do
    setting = Setting.new(field_name: 'registered', field_type: 'bool', field_value: 'true')
    assert setting.save
    setting2 = Setting.new(field_name: 'registered', field_type: 'bool', field_value: 'true')
    assert !setting2.save
  end

  test 'should not save setting with name shorter than 3 symbols' do
    setting = Setting.new(field_name: 're', field_type: 'bool', field_value: 'true')
    assert !setting.save
  end

  test 'should not save setting with type shorter than 3 symbols' do
    setting = Setting.new(field_name: 'registered', field_type: 'bo', field_value: 'true')
    assert !setting.save
  end

  test 'should not save setting with name greater than 45 symbols' do
    setting = Setting.new(field_name: "#{'a'*46}", field_type: 'bool', field_value: 'true')
    assert !setting.save
  end

  test 'should not save setting with value greater than 45 symbols' do
    setting = Setting.new(field_name: 'registered', field_type: 'bool', field_value: "#{'a'*46}")
    assert !setting.save
  end

  test 'should not save setting with type greater than 45 symbols' do
    setting = Setting.new(field_name: 'registered', field_type: "#{'a'*46}", field_value: 'true')
    assert !setting.save
  end

  test 'should get the correct value' do
    Setting.create(field_name: 'registered', field_type: 'bool', field_value: 'true')
    test1 = Setting.where(field_name: 'registered').first
    test2 = Setting.get('registered')
    assert_equal test1.id, test2.id
  end

  test 'should create a setting' do
    Setting.destroy_all
    Setting.create(field_name: 'registered', field_type: 'Fixnum', field_value: 10)
    test1 = Setting.set('user', 10)
    test2 = Setting.all
    assert_equal test1.field_type, 'Fixnum'
    assert_equal test2.length, 2
  end

  test 'should remove all settings' do
    Setting.destroy_all
    Setting.create(field_name: 'registered', field_type: 'Fixnum', field_value: 10)
    Setting.create(field_name: 'email', field_type: 'String', field_value: 'my_email')
    Setting.unset('email', 'registered')
    total = Setting.all
    assert_equal total.length, 0
  end

end