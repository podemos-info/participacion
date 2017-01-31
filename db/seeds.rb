# Default admin user (change password after first deploy to a server!)
if Administrator.count == 0
  admin = User.create!(username: 'admin', email: 'admin@madrid.es', password: '12345678', password_confirmation: '12345678', confirmed_at: Time.now, terms_of_service: "1")
  admin.create_administrator
end

# Names for the moderation console, as a hint for moderators
# to know better how to assign users with official positions
Setting.create(key: 'official_level_1_name', value: 'Portavoces')
Setting.create(key: 'official_level_2_name', value: 'Consejos Ciudadanos')
Setting.create(key: 'official_level_3_name', value: 'Círculos')
Setting.create(key: 'official_level_4_name', value: 'Moderadores')
Setting.create(key: 'official_level_5_name', value: 'Entrevistados')

# Max percentage of allowed anonymous votes on a debate
Setting.create(key: 'max_ratio_anon_votes_on_debates', value: '50')

# Max percentage of allowed anonymous votes on a cca
Setting.create(key: 'max_ratio_anon_votes_on_ccas', value: '50')

# Max votes where a debate is still editable
Setting.create(key: 'max_votes_for_debate_edit', value: '1000')

# Max percentage of allowed anonymous votes on a measure
Setting.create(key: 'max_ratio_anon_votes_on_measures', value: '50')

# Max votes where a measure is still editable
Setting.create(key: 'max_votes_for_measure_edit', value: '1000')

# Max votes where a proposal is still editable
Setting.create(key: 'max_votes_for_proposal_edit', value: '1000')

# Prefix for the Proposal codes
Setting.create(key: 'proposal_code_prefix', value: 'MAD')

# Number of votes needed for proposal success
Setting.create(key: 'votes_for_proposal_success', value: '53726')

# Max votes where a enquiry is still editable
Setting.create(key: 'max_votes_for_enquiry_edit', value: '1000')

# Prefix for the Enquiry codes
Setting.create(key: 'enquiry_code_prefix', value: 'MAD')

# Number of votes needed for enquiry success
Setting.create(key: 'votes_for_enquiry_success', value: '53726')
