describe 'Destroy Message Endpoint' do
  before(:each) do
    @mentee = User.create!({id: 1, name: 'Mary', email: 'ml@email.com',  password_digest: 'password', mentor: false })
    Profile.create({ user_id: 1, field_of_interest: 'Software Development', about_me: 'I want to learn more about software development.',  gender: 'She/Her',
      image: 'https://ca.slack-edge.com/T029P2S9M-UKFAC39T8-a2bcff612d11-72' })
    Location.create( {user_id: 1, city: 'Boulder',  state: 'CO', zip_code: '80202',  meetup_radius: '20' })

    @mentor = User.create!({id: 2, name: 'Kayla', email: 'kw@email.com', password_digest: 'password', mentor: true })
    Profile.create({ user_id: 2,field_of_interest: 'Software Development', about_me: 'I want to learn more about software development.',
      gender: 'She/Her', image: 'https://ca.slack-edge.com/T029P2S9M-UKDBXCVSR-c9dfc59451e1-72' })
    MentorProfile.create!({ user_id: 2,   field_of_knowledge: 'Software Development', experience_level: 'Intermediate',
      work_day_question: 'My typical day is awesome!', enjoyment_question: 'I enjoy teaching and sharing my knowledge!',
      teaching_points_question: 'I want to teach React Native!', advice_question: 'Just keep swimming!'} )
    Location.create!({user_id: 2,   city: 'Denver', state: 'CO', zip_code: '90210', meetup_radius: '15' })

    Connection.create!(mentee_id: @mentee.id, mentor_id: @mentor.id)

    @conversation = Conversation.create!(sender_id: @mentee.id, recipient_id: @mentor.id)

    @message = Message.create!(
      body: "Hello. I would like you to mentor me.",
      read: true,
      conversation_id: @conversation.id,
      user_id: @mentee.id
    )
  end

  it 'destroys a message' do
    query_string = <<-GRAPHQL
      mutation {
        destroyMessage(input: {
          id: "#{@message.id}"
        }) {
          message
        }
      }
    GRAPHQL

    post '/api/v1/graphql', params: { query: query_string }

    result = JSON.parse(response.body)
    expect(result["data"]["destroyMessage"]["message"]).to eq('Message has been successfully deleted')
    expect(Message.all.length).to eq(0)
  end

  it 'cannot delete message without valid id' do
    query_string = <<-GRAPHQL
      mutation {
        destroyMessage(input: {
          id: "99"
        }) {
          message
        }
      }
    GRAPHQL

    post '/api/v1/graphql', params: { query: query_string }

    result = JSON.parse(response.body)
    expect(Message.all.length).to eq(1)
    expect(result["errors"][0]["message"]).to eq("Cannot return null for non-nullable field DestroyMessage.message")
  end
end
