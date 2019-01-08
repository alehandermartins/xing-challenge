require "rails_helper"
require 'csv'

describe ImporterService, type: :service do

  let(:users) {[
    ["1", "Susan", "Gomez", "sgomez0@cpanel.net", "sgomez0"],
    ["2", "Betty", "Crawford", "bcrawford1@google.com.au", "bcrawford1"],
    ["3", "Carlos", "Wilson", "cwilson2@wikia.com", "cwilson2"]
  ]}

  let(:test_file) { "user_data_test" }
  let(:test_file_path) { [Rails.root, "csv", "#{test_file}.csv"].join("/") }
  let(:importer) { ImporterService.new(test_file, User) }

  def create_csv data
    CSV.open(test_file_path, "w") do |csv|
      csv << ["id", "first_name", "last_name", "email", "user_name"]
      data.each { |item| csv << item }
    end
  end

  after(:each) do
    File.delete(test_file_path) if File.exist?(test_file_path)
  end

  it "runs gracefully" do
    create_csv(users)
    expect { importer.call }.not_to raise_error
  end

  it "imports users data" do
    create_csv(users)
    expect { importer.call }.to change(User, :count).by(3)
  end

  it "does not import missing files" do
    importer = ImporterService.new(nil, User) 
    expect { importer.call }.not_to change(User, :count)
  end

  it "does not import corrupted data" do
    users[2] = ["3"]
    create_csv(users)
    expect { importer.call }.to change(User, :count).by(2)
  end

  it "does not import duplicated ids" do
    users[2][0] = "2"
    create_csv(users)
    expect { importer.call }.to change(User, :count).by(2)
  end

  it "adds passwords to devise models" do
    create_csv(users)
    importer.call
    expect(User.last.encrypted_password.present?).to eq true
  end
end