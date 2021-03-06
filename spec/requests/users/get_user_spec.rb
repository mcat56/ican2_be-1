describe 'get user endpoint' do
  before(:each) do
    @mentor = User.create!({id: 1, name: 'Mary', email: 'ml@email.com',  password_digest: 'password', mentor: true})

    Profile.create({ user_id: 1, field_of_interest: 'Software Development', about_me: 'I want to learn more about software development.',  gender: 'She/Her',
      image: 'https://ca.slack-edge.com/T029P2S9M-UKFAC39T8-a2bcff612d11-72' })


    MentorProfile.create({ user_id: 1, field_of_knowledge: 'Software Development',  experience_level: 'Advanced',
      work_day_question: 'My typical day is awesome!', enjoyment_question: 'I enjoy teaching and sharing my knowledge!',
      teaching_points_question: 'I want to teach Ruby on Rails!', advice_question: 'Just keep swimming!' })

    Location.create( {user_id: 1, city: 'Boulder',  state: 'CO', zip_code: '80202',  meetup_radius: '20' })

    @mentor2 = User.create!({id: 2, name: 'Kayla', email: 'kw@email.com', password_digest: 'password', mentor: true })

    Profile.create({ user_id: 2,field_of_interest: 'Software Development', about_me: 'I want to learn more about software development.',
      gender: 'She/Her', image: 'https://ca.slack-edge.com/T029P2S9M-UKDBXCVSR-c9dfc59451e1-72' })

    MentorProfile.create({ user_id: 2,   field_of_knowledge: 'Software Development', experience_level: 'Intermediate',
      work_day_question: 'My typical day is awesome!', enjoyment_question: 'I enjoy teaching and sharing my knowledge!',
      teaching_points_question: 'I want to teach React Native!', advice_question: 'Just keep swimming!'} )

    Location.create({user_id: 2,   city: 'Denver', state: 'CO', zip_code: '90210', meetup_radius: '15' })


    @mentor3 = User.create!({id: 3, name: 'Ben', email: 'bf@email.com', password_digest: 'password',  mentor: true })

    Profile.create({ user_id: 3, field_of_interest: 'Software Development', about_me: 'I want to learn more about software development.',
                    gender: 'He/Him', image: 'https://ca.slack-edge.com/T029P2S9M-UK28AK7FD-4caa1e486b61-72' })

    MentorProfile.create({user_id: 3, field_of_knowledge: 'Software Development', experience_level: 'Beginner',
    work_day_question: 'My typical day is awesome!', enjoyment_question: 'I enjoy teaching and sharing my knowledge!',
    teaching_points_question: 'I want to teach Javascript!', advice_question: 'Just keep swimming!' })

    Location.create({user_id: 3,   city: 'Golden', state: 'CO', zip_code: '90302', meetup_radius: '10' })
  end

  it 'sends user info' do
    query_string = <<-GRAPHQL
    query($email: String!) {
       users(email: $email) {
        name
        email
        mentor
       profile {
            gender
            aboutMe
            image
            fieldOfInterest
        }
        mentorProfile {
          fieldOfKnowledge
          experienceLevel
          workDayQuestion
          enjoymentQuestion
          teachingPointsQuestion
          adviceQuestion
        }
        location {
          city
          state
        }
      }
    }
    GRAPHQL

    post '/api/v1/graphql', params: { query: query_string, variables: { email: 'kw@email.com' }}

    result = JSON.parse(response.body)
    expect(result["data"]["users"]["location"]["city"]).to eq('Denver')
    expect(result["data"]["users"]["mentorProfile"]["fieldOfKnowledge"]).to eq('Software Development')
    expect(result["data"]["users"]["profile"]["aboutMe"]).to eq('I want to learn more about software development.')
    expect(result["data"]["users"]["name"]).to eq('Kayla')
    expect(result["data"]["users"]).to be_instance_of(Hash)
  end

  it 'sends user info' do
    query_string = <<-GRAPHQL
    query($id: String!) {
       users(id: $id) {
        name
      }
    }

    GRAPHQL

    post '/api/v1/graphql', params: { query: query_string, variables: { id: @mentor2.id }}

    result = JSON.parse(response.body)
    expect(result["data"]["users"]["name"]).to eq('Kayla')
  end

  it 'returns nil for a user query with invalid email' do
    query_string = <<-GRAPHQL
      query($email: String!) {
        users(email: $email) {
          name
          email
        }
      }
    GRAPHQL

    post '/api/v1/graphql', params: { query: query_string, variables: { email: 'foofoo@gmail.com' }}

    result = JSON.parse(response.body)
    expect(result["data"]).to be_nil
  end
end
