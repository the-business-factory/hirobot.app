class Health::Index < BrowserAction
  include Auth::AllowGuests

  get "/health" do
    head :ok
  end
end
