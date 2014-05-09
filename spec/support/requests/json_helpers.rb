module Requests
  module JsonHelpers
    def user
      @user ||= FactoryGirl.create(:user, id: 1)
    end

    def login(user)
      login_as user, scope: :user
    end

    def json
      @json ||= JSON.parse(response.body)
    end

    def players_links
      json["links"]["players"]
    end

    def edit_link_for(resource)
      {"rel"    => "edit",
       "name"   => "player",
       "href"   => "/api/v1/players/#{resource.id}",
       "prompt" => "Name player"}
    end
  end
end
