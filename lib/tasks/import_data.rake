namespace :import_data do
  desc 'Import user data from csv'
  task :user, [:file] => :environment do |t, args|
    ImporterService.new(args[:file], User).call
  end

  desc 'Import mp3 data from csv'
  task :mp3, [:file] => :environment do |t, args|
    ImporterService.new(args[:file], Mp3).call
  end

  desc 'Import Play list data from csv'
  task :play_list, [:file] => :environment do |t, args|
    ImporterService.new(args[:file], PlayList).call
  end
end