require "rails_helper"
require 'csv'

describe "rake import_data", type: :task do

  let(:test_file) { "data_test" }

  context "user" do

    it "preloads the Rails environment" do
      expect(Rake::Task["import_data:user"].prerequisites).to include "environment"
    end

    it "runs gracefully with no subscribers" do
      expect(ImporterHelper).to receive(:import).with(test_file, User)
      Rake::Task["import_data:user"].invoke(test_file)
    end
  end

  context "mp3" do

    it "preloads the Rails environment" do
      expect(Rake::Task["import_data:mp3"].prerequisites).to include "environment"
    end

    it "runs gracefully with no subscribers" do
      expect(ImporterHelper).to receive(:import).with(test_file, Mp3)
      Rake::Task["import_data:mp3"].invoke(test_file)
    end
  end

  context "play_list" do

    it "preloads the Rails environment" do
      expect(Rake::Task["import_data:play_list"].prerequisites).to include "environment"
    end

    it "runs gracefully with no subscribers" do
      expect(ImporterHelper).to receive(:import).with(test_file, PlayList)
      Rake::Task["import_data:play_list"].invoke(test_file)
    end
  end
end