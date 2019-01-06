require 'rails_helper'

RSpec.describe Mp3, type: :model do
  let(:mp3) { build(:mp3) }

  it 'has a valid factory' do
    expect(mp3).to be_valid
  end

  context "validations" do
    it "is not valid without title" do
      mp3.title = nil
      expect(mp3).not_to be_valid
    end

    it "is not valid without interpret" do
      mp3.interpret = nil
      expect(mp3).not_to be_valid
    end

    it "is not valid without album" do
      mp3.album = nil
      expect(mp3).not_to be_valid
    end

    it "is not valid without track" do
      mp3.track = nil
      expect(mp3).not_to be_valid
    end
  end

  context "associations" do
    it "has and belongs to many play_lists" do
      assc = described_class.reflect_on_association(:play_lists)
      expect(assc.macro).to eq :has_and_belongs_to_many
    end
  end
end
