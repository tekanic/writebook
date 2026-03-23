class Account < ApplicationRecord
  include Joinable, PlanEnforceable

  has_many :users, dependent: :destroy
  has_many :books, dependent: :destroy
  has_many :sending_domains, dependent: :destroy
  has_many :article_sources, dependent: :destroy
  has_many :generated_articles, dependent: :destroy
end
