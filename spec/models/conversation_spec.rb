require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'validations' do
    it { should validate_uniqueness_of(:sender_id).scoped_to(:recipient_id) }
  end

  describe 'relationships' do
    it { should belong_to :sender }
    it { should belong_to :recipient }
    
    it { should have_many :messages }
  end
end
