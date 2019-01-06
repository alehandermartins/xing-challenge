namespace :import_data do
  desc 'Import user data from csv'
  task :user, [:file] => :environment do |t, args|
    ImporterHelper.import(args[:file], User)
  end

  desc 'Import mp3 data from csv'
  task :mp3, [:file] => :environment do |t, args|
    ImporterHelper.import(args[:file], Mp3)
  end

  desc 'Import Play list data from csv'
  task :play_list, [:file] => :environment do |t, args|
    ImporterHelper.import(args[:file], PlayList)
  end
end