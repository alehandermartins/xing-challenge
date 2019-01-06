require 'csv'
module ImporterHelper
  extend self
  def import file_name, model
    puts "*****#{model} import process starts ...at #{Time.now.strftime('%d-%b-%Y %H:%M:%S')}"

    file = [Rails.root, "csv", "#{file_name}.csv"].join("/")
    return unless valid_file?(file)
    
    valid_records, invalid_records = process_data(model, file)
    display_errors(invalid_records)

    puts "*****#{model} import process completed ...at #{Time.now.strftime('%d-%b-%Y %H:%M:%S')}."
  end

  private

  def valid_file? file
    return true if File.exist?(file)
    puts "Non existing file: #{File.basename(file, ".*")}"
    false
  end

  def process_data model, file
    valid_records  = []
    invalid_records = []

    CSV.foreach(file, headers: true) do |row|
      new_record = model.new(row.to_h)

      #Autogenerate password for devise models
      if new_record.respond_to? :password
        new_record.password = Devise.friendly_token.first(8)
      end

      if new_record.valid?
        valid_records << new_record
      else
        invalid_records << new_record
      end
    end
    
    model.import valid_records, on_duplicate_key_ignore: true
    return valid_records, invalid_records
  end


  def display_errors invalid_records
    if invalid_records.present?
      puts '#Import fail for:'
      invalid_records.each do |record|
        puts "=== #{record.id}"
      end
    end
  end
end