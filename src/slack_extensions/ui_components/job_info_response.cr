class SlackComponents::JobInfoResponse < Slack::UI::CustomComponent
  property username

  def initialize(@username : String)
  end

  def self.render(username : String)
    new(username).render
  end

  def render
    [p1, p2, p3, p4]
  end

  private def p1
    TextSection.render markdown: true, text: <<-MD
    Hi <@#{username}>, thanks for posting!
    MD
  end

  private def p2
    TextSection.render text: <<-TEXT
    Reminder: It would be helpful if posts noted, without having to click a
    link, as much of the following info as possible:
    TEXT
  end

  private def p3
    TextSection.render markdown: true, text: <<-MD
    • Company Name & Description
    • Full Time / Part Time / Contract
    • Job Title & Description
    • Compensation (Base / Bonus / Equity / Benefits)
    • Location (Remote / Hybrid / On-Site)
    • Timezone/Location Requirements
    • Visa Sponsorship
    • Your Relationship to the Role
    • Link to Apply
    MD
  end

  private def p4
    TextSection.render markdown: true, text: <<-MD
    thanks for keeping this channel useful to all of our members,
    :heart: Rails Slack Team
    MD
  end
end
