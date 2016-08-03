class CatRentalRequest < ActiveRecord::Base
  validates :status, :cat_id, :start_date, :end_date, presence: true
  validate :no_two_requests_for_same_cat
  validate :start_before_end

  belongs_to :cat

  def no_two_requests_for_same_cat
    return if self.status == "DENIED"
    if overlapping_approved_requests
      self.errors[:overlap] << "no two approved cat requests for same cat can overlap"
    end
  end

  def overlapping_requests
    where_request =<<-SQL
      cat_id = ?
      AND id #{self.id == nil ? 'IS NOT' : '!='} ?
      AND (start_date BETWEEN ? AND ?
      OR end_date BETWEEN ? AND ?)
      SQL
    CatRentalRequest.where(where_request, self.cat_id, self.id, self.start_date, self.end_date, self.start_date, self.end_date)
  end

  def overlapping_approved_requests
    overlapping_cat_requests = overlapping_requests
    overlapping_cat_requests.any? do |overlapping_cat_request|
      overlapping_cat_request.status == "APPROVED"
    end
  end

  def start_before_end
    if self.start_date > self.end_date
      self.errors[:start_date] << "cannot come after end date"
    end
  end

  def approve!
    self.status = "APPROVED"
    self.save
    other_requests = self.overlapping_requests.to_a
    other_requests.each do |request|
      request.deny!
    end
  end

  def deny!
    self.status = "DENIED"
    self.save
  end

  def pending?
    self.status == "PENDING"
  end
end
