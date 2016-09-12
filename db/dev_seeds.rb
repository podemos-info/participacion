require 'database_cleaner'

DatabaseCleaner.clean_with :truncation

puts "Creating Settings"
Setting.create(key: 'official_level_1_name', value: 'Portavoces')
Setting.create(key: 'official_level_2_name', value: 'Consejos Ciudadanos')
Setting.create(key: 'official_level_3_name', value: 'Círculos')
Setting.create(key: 'official_level_4_name', value: 'Moderadores')
Setting.create(key: 'official_level_5_name', value: 'Entrevistados')
Setting.create(key: 'max_ratio_anon_votes_on_debates', value: '50')
Setting.create(key: 'max_ratio_anon_votes_on_medidas', value: '50')
Setting.create(key: 'max_ratio_anon_votes_on_laws', value: '50')
Setting.create(key: 'max_votes_for_debate_edit', value: '1000')
Setting.create(key: 'max_votes_for_proposal_edit', value: '1000')
Setting.create(key: 'proposal_code_prefix', value: 'MAD')
Setting.create(key: 'votes_for_proposal_success', value: '100')
Setting.create(key: 'max_votes_for_enquiry_edit', value: '1000')
Setting.create(key: 'enquiry_code_prefix', value: 'MAD')
Setting.create(key: 'votes_for_enquiry_success', value: '100')

puts "Creating Users"

def create_user(email, username = Faker::Name.name)
  pwd = '12345678'
  puts "    #{username}"
  User.create!(username: username, email: email, password: pwd, password_confirmation: pwd, confirmed_at: Time.now, terms_of_service: "1")
end

#admin = create_user('admin@madrid.es', 'admin')
#admin.create_administrator

#moderator = create_user('mod@madrid.es', 'mod')
#moderator.create_moderator

(1..10).each do |i|
  org_name = Faker::Company.name
  org_user = create_user("org#{i}@madrid.es", org_name)
  org_responsible_name = Faker::Name.name
  org = org_user.create_organization(name: org_name, responsible_name: org_responsible_name)

  verified = [true, false].sample
  if verified then
    org.verify
  else
    org.reject
  end
end

(1..5).each do |i|
  official = create_user("official#{i}@madrid.es")
  official.update(official_level: i, official_position: "Official position #{i}")
end

(1..40).each do |i|
  user = create_user("user#{i}@madrid.es")
  level = [1,2,3].sample
  if level > 1 then
    user.update(residence_verified_at: Time.now, confirmed_phone: Faker::PhoneNumber.phone_number, document_number: Faker::Number.number(10) )
  end
  if level == 3 then
    user.update(verified_at: Time.now, document_number: Faker::Number.number(10) )
  end
end

org_user_ids = User.organizations.pluck(:id)
not_org_users = User.where(['users.id NOT IN(?)', org_user_ids])


puts "Creating Debates"

tags = Faker::Lorem.words(25)

(1..30).each do |i|
  author = User.reorder("RANDOM()").first
  description = "<p>#{Faker::Lorem.paragraphs.join('</p><p>')}</p>"
  debate = Debate.create!(author: author,
                          title: Faker::Lorem.sentence(3).truncate(60),
                          created_at: rand((Time.now - 1.week) .. Time.now),
                          description: description,
                          tag_list: tags.sample(3).join(','),
                          terms_of_service: "1")
  puts "    #{debate.title}"
end

puts "Creating Medidas"

tags = Faker::Lorem.words(25)

(1..30).each do |i|
  author = User.reorder("RANDOM()").first
  description = "<p>#{Faker::Lorem.paragraphs.join('</p><p>')}</p>"
medida = Medida.create!(author: author,
                          title: Faker::Lorem.sentence(3).truncate(60),
                          created_at: rand((Time.now - 1.week) .. Time.now),
                          description: description,
                          tag_list: tags.sample(3).join(','),
                          terms_of_service: "1")
puts "    #{medida.title}"
end

puts "Creating Hilos"

tags = Faker::Lorem.words(25)

(1..30).each do |i|
  author = User.reorder("RANDOM()").first
  description = "<p>#{Faker::Lorem.paragraphs.join('</p><p>')}</p>"
law = Law.create!(author: author,
                          title: Faker::Lorem.sentence(3).truncate(60),
                          created_at: rand((Time.now - 1.week) .. Time.now),
                          description: description,
                          tag_list: tags.sample(3).join(','),
                          terms_of_service: "1")
puts "    #{law.title}"
end

puts "Creating Proposals"

tags = Faker::Lorem.words(25)

(1..30).each do |i|
  author = User.reorder("RANDOM()").first
  description = "<p>#{Faker::Lorem.paragraphs.join('</p><p>')}</p>"
  proposal = Proposal.create!(author: author,
                              title: Faker::Lorem.sentence(3).truncate(60),
                              question: Faker::Lorem.sentence(3),
                              summary: Faker::Lorem.sentence(3),
                              responsible_name: Faker::Name.name,
                              external_url: Faker::Internet.url,
                              description: description,
                              created_at: rand((Time.now - 1.week) .. Time.now),
                              tag_list: tags.sample(3).join(','),
                              terms_of_service: "1")
  puts "    #{proposal.title}"
end

puts "Creating Enquiries"

tags = Faker::Lorem.words(25)

(1..30).each do |i|
  author = User.reorder("RANDOM()").first
  description = "<p>#{Faker::Lorem.paragraphs.join('</p><p>')}</p>"
  enquiry = Enquiry.create!(author: author,
                              title: Faker::Lorem.sentence(3).truncate(60),
                              question: Faker::Lorem.sentence(3),
                              summary: Faker::Lorem.sentence(3),
                              responsible_name: Faker::Name.name,
                              external_url: Faker::Internet.url,
                              description: description,
                              created_at: rand((Time.now - 1.week) .. Time.now),
                              tag_list: tags.sample(3).join(','),
                              terms_of_service: "1")
  puts "    #{enquiry.title}"
end


puts "Commenting Debates"

(1..100).each do |i|
  author = User.reorder("RANDOM()").first
  debate = Debate.reorder("RANDOM()").first
  Comment.create!(user: author,
                  created_at: rand(debate.created_at .. Time.now),
                  commentable: debate,
                  body: Faker::Lorem.sentence)
end

puts "Commenting Medidas"

(1..100).each do |i|
  author = User.reorder("RANDOM()").first
  medida = Medida.reorder("RANDOM()").first
  Comment.create!(user: author,
    created_at: rand(medida.created_at .. Time.now),
    commentable: medida,
                  body: Faker::Lorem.sentence)
end

puts "Commenting Hilos"

(1..100).each do |i|
  author = User.reorder("RANDOM()").first
  law = Law.reorder("RANDOM()").first
  Comment.create!(user: author,
    created_at: rand(law.created_at .. Time.now),
    commentable: law,
                  body: Faker::Lorem.sentence)
end

puts "Commenting Proposals"

(1..100).each do |i|
  author = User.reorder("RANDOM()").first
  proposal = Proposal.reorder("RANDOM()").first
  Comment.create!(user: author,
                  created_at: rand(proposal.created_at .. Time.now),
                  commentable: proposal,
                  body: Faker::Lorem.sentence)
end

puts "Commenting Enquiries"

(1..100).each do |i|
  author = User.reorder("RANDOM()").first
  enquiry = Enquiry.reorder("RANDOM()").first
  Comment.create!(user: author,
    created_at: rand(enquiry.created_at .. Time.now),
    commentable: enquiry,
    body: Faker::Lorem.sentence)
end


puts "Commenting Comments"

(1..200).each do |i|
  author = User.reorder("RANDOM()").first
  parent = Comment.reorder("RANDOM()").first
  Comment.create!(user: author,
                  created_at: rand(parent.created_at .. Time.now),
                  commentable_id: parent.commentable_id,
                  commentable_type: parent.commentable_type,
                  body: Faker::Lorem.sentence,
                  parent: parent)
end


puts "Voting Debates, Medidas, Hilos, Proposals, Enquiries & Comments"

(1..100).each do |i|
  voter  = not_org_users.reorder("RANDOM()").first
  vote   = [true, false].sample
  debate = Debate.reorder("RANDOM()").first
  debate.vote_by(voter: voter, vote: vote)
end

(1..100).each do |i|
  voter  = not_org_users.reorder("RANDOM()").first
  vote   = [true, false].sample
  medida = Medida.reorder("RANDOM()").first
  medida.vote_by(voter: voter, vote: vote)
end

(1..100).each do |i|
  voter  = not_org_users.reorder("RANDOM()").first
  vote   = [true, false].sample
  law = Law.reorder("RANDOM()").first
  law.vote_by(voter: voter, vote: vote)
end

(1..100).each do |i|
  voter  = not_org_users.reorder("RANDOM()").first
  vote   = [true, false].sample
  comment = Comment.reorder("RANDOM()").first
  comment.vote_by(voter: voter, vote: vote)
end

(1..100).each do |i|
  voter  = User.level_two_or_three_verified.reorder("RANDOM()").first
  proposal = Proposal.reorder("RANDOM()").first
  proposal.vote_by(voter: voter, vote: true)
end

(1..100).each do |i|
  voter  = User.level_two_or_three_verified.reorder("RANDOM()").first
  enquiry = Enquiry.reorder("RANDOM()").first
  enquiry.vote_by(voter: voter, vote: true)
end

puts "Flagging Debates, Medidas, Hilos & Comments"

(1..40).each do |i|
  debate = Debate.reorder("RANDOM()").first
  flagger = User.where(["users.id <> ?", debate.author_id]).reorder("RANDOM()").first
  Flag.flag(flagger, debate)
end

(1..40).each do |i|
  medida = Medida.reorder("RANDOM()").first
  flagger = User.where(["users.id <> ?", medida.author_id]).reorder("RANDOM()").first
  Flag.flag(flagger, medida)
end

(1..40).each do |i|
  law = Law.reorder("RANDOM()").first
  flagger = User.where(["users.id <> ?", law.author_id]).reorder("RANDOM()").first
  Flag.flag(flagger, law)
end

(1..40).each do |i|
  comment = Comment.reorder("RANDOM()").first
  flagger = User.where(["users.id <> ?", comment.user_id]).reorder("RANDOM()").first
  Flag.flag(flagger, comment)
end

(1..40).each do |i|
  proposal = Proposal.reorder("RANDOM()").first
  flagger = User.where(["users.id <> ?", proposal.author_id]).reorder("RANDOM()").first
  Flag.flag(flagger, proposal)
end

(1..40).each do |i|
  enquiry = Enquiry.reorder("RANDOM()").first
  flagger = User.where(["users.id <> ?", enquiry.author_id]).reorder("RANDOM()").first
  Flag.flag(flagger, enquiry)
end

puts "Ignoring flags in Debates, Medidas, Hilos,Enquiries, comments & proposals"

Debate.flagged.reorder("RANDOM()").limit(10).each(&:ignore_flag)
Medida.flagged.reorder("RANDOM()").limit(10).each(&:ignore_flag)
Law.flagged.reorder("RANDOM()").limit(10).each(&:ignore_flag)
Comment.flagged.reorder("RANDOM()").limit(30).each(&:ignore_flag)
Proposal.flagged.reorder("RANDOM()").limit(10).each(&:ignore_flag)
Enquiry.flagged.reorder("RANDOM()").limit(10).each(&:ignore_flag)

puts "Hiding debates, medidas, hilos, enquiries, comments & proposals"

Comment.with_hidden.flagged.reorder("RANDOM()").limit(30).each(&:hide)
Debate.with_hidden.flagged.reorder("RANDOM()").limit(5).each(&:hide)
Medida.with_hidden.flagged.reorder("RANDOM()").limit(5).each(&:hide)
Law.with_hidden.flagged.reorder("RANDOM()").limit(5).each(&:hide)
Proposal.with_hidden.flagged.reorder("RANDOM()").limit(10).each(&:hide)
Enquiry.with_hidden.flagged.reorder("RANDOM()").limit(10).each(&:hide)

puts "Confirming hiding in debates, medidas, hilos, enquiries, comments & proposals"

Comment.only_hidden.flagged.reorder("RANDOM()").limit(10).each(&:confirm_hide)
Debate.only_hidden.flagged.reorder("RANDOM()").limit(5).each(&:confirm_hide)
Medida.only_hidden.flagged.reorder("RANDOM()").limit(5).each(&:confirm_hide)
Law.only_hidden.flagged.reorder("RANDOM()").limit(5).each(&:confirm_hide)
Proposal.only_hidden.flagged.reorder("RANDOM()").limit(5).each(&:confirm_hide)
Enquiry.only_hidden.flagged.reorder("RANDOM()").limit(5).each(&:confirm_hide)
