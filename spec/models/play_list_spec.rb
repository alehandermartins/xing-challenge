require 'rails_helper'

RSpec.describe PlayList, type: :model do
  let(:play_list) { build(:play_list) }

  it 'has a valid factory' do
    expect(play_list).to be_valid
  end

  context "validations" do
    it "is not valid without name" do
      play_list.name = nil
      expect(play_list).not_to be_valid
    end
  end

  context "associations" do
    it "belongs to user" do
      assc = described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end

    it "has and belongs to many mp3" do
      assc = described_class.reflect_on_association(:mp3s)
      expect(assc.macro).to eq :has_and_belongs_to_many
    end
  end
end