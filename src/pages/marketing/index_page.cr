class Marketing::IndexPage < GuestLayout
  def content
    div class: "hero" do
      div class: "hero-content text-center justify-center" do
        div class: "max-w-md" do
          img src: asset("images/hiro.svg"), width: 128, height: 128
          para class: "py-6" do
            text <<-TEXT
            Coming soon: Hiro is a bot for technical Slack communities bot
            written in
          TEXT

            a href: "https://crystal-lang.org/", class: "showcase" do
              text "Crystal"
            end

            text <<-TEXT
            -- a lightning-fast, readable, and strongly typed language
            originally inspired by ruby.
            TEXT
          end

          url = Slack::SignInWithSlack.new.redirect_url
          a "Sign In With Slack", href: url, class: "btn inactive-button"
        end
      end
    end
  end
end
