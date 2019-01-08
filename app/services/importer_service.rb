require 'csv'

class ImporterService

  def initialize file_name, model
    @file = [Rails.root, "csv", "#{file_name}.csv"].join("/")
    @model = model
    @valid_records = Array.new
    @invalid_records = Array.new
  end

  def call
    return unless valid_file?
    
    process_data
    display_errors
  end

  private

  def valid_file?
    return true if File.exist?(@file)
    Rails.logger.debug "Non existing file: #{File.basename(@file, ".*")}"
    false
  end

  def process_data
    CSV.foreach(@file, headers: true) do |row|
      new_record = @model.new(row.to_h)

      #Autogenerate password for devise models
      if new_record.respond_to? :password
        new_record.password = Devise.friendly_token.first(8)
      end

      if new_record.valid?
        @valid_records << new_record
      else
        @invalid_records << new_record
      end
    end
    
    @model.import @valid_records, on_duplicate_key_ignore: true
  end

  def display_errors
    @invalid_records.each do |record|
      Rails.logger.debug "#Import fail for: #{record.id}"
    end
  end
end