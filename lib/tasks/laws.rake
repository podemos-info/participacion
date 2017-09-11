namespace :laws do
  desc "Updates all laws by recalculating their hot_score"
  task hot_score: :environment do
    Law.find_in_batches do |laws|
      laws.each(&:save)
    end
  end

end
