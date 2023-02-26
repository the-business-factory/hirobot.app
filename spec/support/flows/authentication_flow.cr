class AuthenticationFlow < BaseFlow
  private getter email

  def initialize(@email : String)
  end

  def sign_up(password)
    visit SignUps::New
    fill_form SignUpUser,
      email: email,
      password: password,
      password_confirmation: password
    click "@sign-up-button"
  end

  def sign_out
    visit Me::Show
    sign_out_button.click
  end

  def sign_in(password)
    visit SignIns::New
    fill_form SignInUser,
      email: email,
      password: password
    click "@sign-in-button"
  end

  def should_be_signed_in
    self.should have_element("@nav-sign-out-button")
  end

  def should_have_password_error
    self.should have_element("body", text: "Password is wrong")
  end

  private def sign_out_button
    el("@nav-sign-out-button")
  end
end
