namespace :ccas do
  desc "Updates all ccas by recalculating their hot_score"
  task hot_score: :environment do
    Cca.find_in_batches do |ccas|
      ccas.each(&:save)
    end
  end

end
