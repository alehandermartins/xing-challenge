require "rails_helper"
require 'csv'

describe ImporterHelper, type: :helper do

  let(:users) {[
    ["1", "Susan", "Gomez", "sgomez0@cpanel.net", "sgomez0"],
    ["2", "Betty", "Crawford", "bcrawford1@google.com.au", "bcrawford1"],
    ["3", "Carlos", "Wilson", "cwilson2@wikia.com", "cwilson2"]
  ]}

  def create_csv data
    CSV.open(@test_file_path, "w") do |csv|
      csv << ["id", "first_name", "last_name", "email", "user_name"]
      data.each { |item| csv << item }
    end
  end

  before(:all) do
    @test_file = "user_data_test"
    @test_file_path = [Rails.root, "csv", "#{@test_file}.csv"].join("/")
  end

  after(:all) do
    File.delete(@test_file_path)
  end

  it "runs gracefully" do
    create_csv(users)
    expect { import @test_file, User }.not_to raise_error
  end

  it "imports users data" do
    create_csv(users)
    expect { import @test_file, User }.to change(User, :count).by(3)
  end

  it "does not import missing files" do
    expect { import nil, User }.not_to change(User, :count)
  end

  it "does not import corrupted data" do
    users[2] = ["3"]
    create_csv(users)
    expect { import @test_file, User }.to change(User, :count).by(2)
  end

  it "does not import duplicated ids" do
    users[2][0] = "2"
    create_csv(users)
    expect { import @test_file, User }.to change(User, :count).by(2)
  end

  it "adds passwords to devise models" do
    create_csv(users)
    import @test_file, User
    expect(User.last.encrypted_password.present?).to eq true
  end
end