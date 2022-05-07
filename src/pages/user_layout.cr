abstract class UserLayout
  include Lucky::HTMLPage

  # 'needs current_user : User' makes it so that the current_user
  # is always required for pages using UserLayout
  needs current_user : User

  abstract def content
  abstract def page_title

  # UserLayout defines a default 'page_title'.
  #
  # Add a 'page_title' method to your indivual pages to customize each page's
  # title.
  #
  # Or, if you want to require every page to set a title, change the
  # 'page_title' method in this layout to:
  #
  #    abstract def page_title : String
  #
  # This will force pages to define their own 'page_title' method.
  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title

      body do
        mount Shared::Navbar, user: current_user
        mount Shared::FlashMessages, context.flash

        main do
          content
        end

        mount Shared::Footer, user: current_user
      end
    end
  end
end
