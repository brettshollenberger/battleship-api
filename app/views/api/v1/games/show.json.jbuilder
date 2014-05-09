json.id   @game.id
json.turn @game.turn

json.partial! 'api/v1/links', game: @game
