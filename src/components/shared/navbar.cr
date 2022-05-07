class Shared::Navbar < BaseComponent
  needs user : User?

  def render
    nav class: "navbar bg-base-100" do
      div class: "flex-1" do
        a class: "btn btn-ghost normal-case text-xl" do
          img src: asset("images/hiro.svg"), width: 42, height: 42
        end
      end
      div class: "flex-none gap-2" do
        div class: "dropdown dropdown-end" do
          button class: "btn btn-square btn-ghost" do
            tag "svg", class: "inline-block w-5 h-5 stroke-current", fill: "none", viewbox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg" do
              tag "path", d: "M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z", stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2"
            end
          end
          ul class: "mt-3 p-2 shadow menu menu-compact dropdown-content bg-base-100 rounded-box w-52", tabindex: "0" do
            li do
              a class: "justify-between" do
                text " Profile "
                span "New", class: "badge"
              end
            end
            li do
              a "Settings"
            end

            render_sign_in_or_out(user)
          end
        end
      end
    end
  end

  def render_sign_in_or_out(user : Nil)
    li do
      link "Sign In", to: SignIns::New
    end
  end

  def render_sign_in_or_out(user : User)
    li do
      link "Sign out", to: SignIns::Delete
    end
  end
end
