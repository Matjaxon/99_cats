# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date
#  color       :string
#  name        :string
#  sex         :string(1)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cat < ActiveRecord::Base
  COLORS = ['brown', 'black', 'white', 'orange', 'gray']

  validates :birth_date, :color, :name, :sex, :description, presence: true
  validate :correct_sex_tag
  validate :correct_color

  has_many :cat_rental_requests, dependent: :destroy

  def correct_sex_tag
    unless ['M','F'].include?(self.sex)
      self.errors[:sex] << "must be equal to 'M' or 'F'"
    end
  end

  def correct_color
    unless COLORS.include?(self.color)
      self.errors[:color] << "must be a valid color!"
    end
  end

  def age
    now = Time.now.to_date
    now.year - self.birth_date.year - ((now.month > self.birth_date.month ||
      (now.month == self.birth_date.month && now.day >= self.birth_date.day)) ? 0 : 1)
  end

end
