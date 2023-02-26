class Me::ShowPage < UserLayout
  def content
    h1 "This is your profile"
    h3 "Email:  #{@current_user.email}"
    helpful_tips
  end

  private def helpful_tips
    br
    h3 "More coming soon..."
  end
end
