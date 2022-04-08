abstract class GuestLayout
  include Lucky::HTMLPage

  abstract def content
  abstract def page_title

  needs current_user : User?

  # The default page title. It is passed to `Shared::LayoutHead`.
  #
  # Add a `page_title` method to pages to override it. You can also remove
  # This method so every page is required to have its own page title.
  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html lang: "en", data_theme: "night" do
      mount Shared::LayoutHead, page_title: page_title

      body class: "font-inter" do
        mount Shared::Navbar, simple: true
        mount Shared::FlashMessages, context.flash

        main do
          div class: "col-span-2 mx-auto prose" do
            content
          end
        end

        mount Shared::Footer, user: current_user
      end
    end
  end
end
