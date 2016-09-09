namespace :tags do
  desc "Recalculates the debate, measure, enquiries and proposals counters"
  task custom_count: :environment do
    ActsAsTaggableOn::Tag.find_in_batches do |tasks|
      tasks.each do |task|
        task.recalculate_custom_counter_for('Debate')
        task.recalculate_custom_counter_for('Medida')
        task.recalculate_custom_counter_for('Proposal')
        task.recalculate_custom_counter_for('Enquiry')
      end
    end
  end
end
