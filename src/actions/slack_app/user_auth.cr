class SlackAuth < BrowserAction
  include Auth::AllowGuests

  get "/slack/user_auth" do
    auth_response = Slack::SignInWithSlack.run(request)
    email = auth_response.email
    current_user = UserQuery.new.email(email).first?
    current_user ||= SaveUser.upsert!(
      email: email,
      encrypted_password: Authentic.generate_encrypted_password(
        Random::Secure.hex(12)
      )
    )

    sign_in(current_user)
    redirect to: Home::Index
  end
end
