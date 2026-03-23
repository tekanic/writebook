class User < ApplicationRecord
  include AccountScoped, Role, Transferable

  has_many :sessions, dependent: :destroy
  has_secure_password validations: false

  has_many :accesses, dependent: :destroy
  has_many :books, through: :accesses
  has_many :leaves, through: :books
  has_many :ad_creatives, foreign_key: :advertiser_id, dependent: :destroy

  after_create :grant_access_to_everyone_books

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }

  def current?
    self == Current.user
  end

  def deactivate
    transaction do
      sessions.delete_all
      update! active: false, email_address: deactived_email_address
    end
  end

  private
    def deactived_email_address
      email_address&.gsub(/@/, "-deactivated-#{SecureRandom.uuid}@")
    end

    def grant_access_to_everyone_books
      all_accesses = Book.for_account(account).with_everyone_access.ids.collect { |id| { book_id: id, level: :reader } }
      accesses.insert_all(all_accesses) if all_accesses.any?
    end
end
