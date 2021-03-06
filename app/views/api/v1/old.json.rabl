
# node(:collection) do
#   { 
#     :version => "1.0",
#     :href    => api_v1_games_path,
#     :items   => @games.map do |game|
#       {
#         :href => api_v1_game_path(@game),

#         :data => game.attributes.map do |key, value|
#           {
#             :name   => key,
#             :value  => value,
#             :prompt => key.titlecase
#           }
#         end,

#         :links => game.players.map do |player|
#           {
#             :href   => api_v1_game_player_path(@game, player),
#             :rel    => "player",
#             :render => "get"
#           }
#         end.push(game.updatable_players.map do |player|
#           {
#             :href => api_v1_game_player_path(@game, player),
#             :rel  => "player",
#             :render => "edit"
#           } if game.setup_player_phase?
#         end).flatten
#       }
#     end
#   }
# end
# json.collection do
#   json.version 1
#   json.href api_v1_games_path

#   json.items @games do
#     json.href api_v1_game_path(@game)

#     json.data @game.attributes do |value|
#       json.name  value[0]
#       json.value value[1]
#       json.prompt value[0].humanize
#     end

#     json.links do 
#       if @game.setup_player_phase?
#         json.players @game.updatable_players do |player|
#           json.rel "edit"
#           json.name "player"
#           json.href "/api/v1/players/#{player.id}"
#           json.prompt "Name player"
#         end
#       end

#       if @game.setup_ship_phase?
#         json.ships @game.updatable_ships do |ship|
#           json.rel "edit"
#           json.name "ship"
#           json.href "/api/v1/ships/#{ship.id}"
#           json.prompt "Set ship"
#         end
#       end

#       if @game.play_phase?
#         json.squares @game.updatable_squares do |square|
#           json.rel "edit"
#           json.name "square"
#           json.href "/api/v1/squares/#{square.id}"
#           json.prompt "Guess square"
#         end
#       end
#     end
#   end
# end

# json.partial! 'api/v1/links', game: @game
