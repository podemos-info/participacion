namespace :comments do

  desc "Recalculates all the comment counters for debates,ccas, measures, enquiries and proposals"
  task count: :environment do
    Debate.all.pluck(:id).each{ |id| Debate.reset_counters(id, :comments) }
    Cca.all.pluck(:id).each{ |id| Cca.reset_counters(id, :comments) }
    Medida.all.pluck(:id).each{ |id| Medida.reset_counters(id, :comments) }
    Law.all.pluck(:id).each{ |id| Law.reset_counters(id, :comments) }
    Proposal.all.pluck(:id).each{ |id| Proposal.reset_counters(id, :comments) }
    Enquiry.all.pluck(:id).each{ |id| Enquiry.reset_counters(id, :comments) }
  end

end
