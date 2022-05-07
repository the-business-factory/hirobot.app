class Shared::Footer < BaseComponent
  needs user : User?

  def render
    footer class: "footer bg-neutral text-neutral-content" do
      div do
        span "My Account", class: "footer-title"
        footer_link "Home", Home::Index
        user_links
      end
    end
  end

  private def user_links
    if user
      footer_anchor "Build a Collection"
      link "Sign Out",
        SignIns::Delete,
        class: "link link-hover",
        flow_id: "nav-sign-out-button"
    else
      footer_link "Sign In", SignIns::New
    end
  end

  private def footer_anchor(text)
    a text, class: "link link-hover"
  end

  private def footer_link(text, path)
    link text, path, class: "link link-hover"
  end
end
