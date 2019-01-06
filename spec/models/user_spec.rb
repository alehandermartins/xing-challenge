require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  context "validations" do
    it "is not valid without first_name" do
      user.first_name = nil
      expect(user).not_to be_valid
    end

    it "is not valid without last_name" do
      user.last_name = nil
      expect(user).not_to be_valid
    end

    it "is not valid without user_name" do
      user.user_name = nil
      expect(user).not_to be_valid
    end

    it "is not valid without email" do
      user.email = nil
      expect(user).not_to be_valid
    end
  end

  context "associations" do
    it "has many play_lists" do
      assc = described_class.reflect_on_association(:play_lists)
      expect(assc.macro).to eq :has_many
    end
  end
end