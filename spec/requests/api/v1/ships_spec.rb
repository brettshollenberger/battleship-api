require 'spec_helper'

describe "Ships API :" do
  describe "Show Action :" do
    before(:each) do
      @game   = FactoryGirl.create(:game)
      @board  = @game.boards.first
      @player = @board.player
      @ship   = @board.ships.first

      get api_v1_board_ship_url(@board, @ship)
    end

    it "is a successful request" do
      expect(response).to be_success
    end

    it "returns the ship's self link" do
      expect(json["links"][0]["href"]).to eq(api_v1_board_ship_url(@board, @ship))
      expect(json["links"][0]["rel"]).to eq("self")
    end

    it "returns the ship's id" do
      expect(json["id"]).to eq(@ship.id)
    end

    it "returns the ship's kind" do
      expect(json["kind"]).to eq(@ship.kind)
    end

    it "returns the ship's state" do
      expect(json["state"]).to eq(@ship.state)
    end

    it "returns the ship's length" do
      expect(json["length"]).to eq(@ship.length)
    end

    it "returns the ship's board" do
      expect(json["board"]["links"][0]["href"]).to eq(api_v1_board_url(@board))
      expect(json["board"]["links"][0]["rel"]).to eq("self")
    end

    it "returns the ship's player" do
      expect(json["player"]["links"][0]["href"]).to eq(api_v1_game_player_url(@game, @player))
      expect(json["player"]["links"][0]["rel"]).to eq("self")
    end

    it "returns the ship's game" do
      expect(json["game"]["links"][0]["href"]).to eq(api_v1_game_url(@game))
      expect(json["game"]["links"][0]["rel"]).to eq("self")
    end
  end

  describe "Update Action :" do
    def update_ship_json
      { :format => :json, :ship => { :squares => [@sq1.to_json, @sq2.to_json] } }
    end

    describe "In ship setting mode" do
      describe "When it is the Player's Turn" do
        describe "Successfully Setting :" do
          describe "Any ship but the final ship :" do
            before(:each) do
              @game  = FactoryGirl.create(:game, phase: "setup_ships")
              @p1    = @game.players.first
              @p2    = @game.players.last
              @p1.name = "Brett"
              @p2.name = "Tag"
              @p1.save && @p2.save
              @board = @game.boards.first
              @sq1   = @board.squares[0]
              @sq2   = @board.squares[1]
              @ship  = @board.ships.last

              put api_v1_board_ship_url(@board, @ship), update_ship_json
            end

            it "is a successful request" do
              expect(response).to be_success
            end

            it "returns a 200" do
              expect(response.status).to eq(200)
            end

            it "is set" do
              expect(json["state"]).to eq("set")
            end

            it "returns the ship's squares" do
              expect(json["squares"][0]["id"]).to eq(@sq1.id)
              expect(json["squares"][1]["id"]).to eq(@sq2.id)
            end

            it "responds with the remaining set ships actions" do
              expect(json["actions"][0]["prompt"]).to eq("Set ship for Player 1")
              expect(json["actions"][1]["prompt"]).to eq("Set ship for Player 1")
              expect(json["actions"][2]["prompt"]).to eq("Set ship for Player 1")
              expect(json["actions"][3]["prompt"]).to eq("Set ship for Player 1")
              expect(json["actions"][4]).to eq(nil)
            end
          end

          describe "The final ship for a player :" do
            before(:each) do
              @game    = FactoryGirl.create(:game, phase: "setup_ships")
              @p1      = @game.players.first
              @p2      = @game.players.last
              @p1.name = "Brett"
              @p2.name = "Tag"
              @p1.save && @p2.save

              @board = @game.boards.first
              @ship  = @board.ships[4]
              @ship2 = @board.ships[3]
              @ship3 = @board.ships[2]
              @ship4 = @board.ships[1]
              @ship5 = @board.ships[0]
              @sq1   = @board.squares[0]
              @sq2   = @board.squares[1]
              @sq3   = @board.squares[2]
              @sq4   = @board.squares[3]
              @sq5   = @board.squares[4]
              @sq6   = @board.squares[5]
              @sq7   = @board.squares[6]
              @sq8   = @board.squares[7]
              @sq9   = @board.squares[10]
              @sq10  = @board.squares[11]
              @sq11  = @board.squares[12]
              @sq12  = @board.squares[13]
              @sq13  = @board.squares[14]
              @sq14  = @board.squares[15]
              @sq15  = @board.squares[16]
              @sq16  = @board.squares[17]
              @sq17  = @board.squares[18]

              @ship2.set([@sq3, @sq4, @sq5])
              @ship3.set([@sq6, @sq7, @sq8])
              @ship4.set([@sq9, @sq10, @sq11, @sq12])
              @ship5.set([@sq13, @sq14, @sq15, @sq16, @sq17])

              put api_v1_board_ship_url(@board, @ship), update_ship_json
            end

            it "responds with the lock board action" do
              expect(json["actions"][0]["href"]).to eq(api_v1_board_url(@board))
              expect(json["actions"][0]["prompt"]).to eq("Lock board")
            end
          end
        end
        
        describe "Unsuccessfully setting :" do
          describe "Setting to too many squares :" do
            def too_many_squares_json
              { :format => :json, :ship => { :squares => [@sq1.to_json, @sq2.to_json,
                                                          @sq3.to_json] } }
            end

            before(:each) do
              @game  = FactoryGirl.create(:game, phase: "setup_ships")
              @p1    = @game.players.first
              @p2    = @game.players.last
              @p1.name = "Brett"
              @p2.name = "Tag"
              @p1.save && @p2.save
              @board = @game.boards.first
              @sq1   = @board.squares[0]
              @sq2   = @board.squares[1]
              @sq3   = @board.squares[2]
              @ship  = @board.ships.last

              put api_v1_board_ship_url(@board, @ship), too_many_squares_json
            end

            it "is not a successful request" do
              expect(response).to_not be_success
            end

            it "returns a forbidden error" do
              expect(response.status).to eq(403)
            end

            it "returns the error message" do
              expect(json["errors"]["squares"]).to include("can only be assigned to two squares")
            end
          end

          describe "Setting previously taken squares :" do
            before(:each) do
              @game  = FactoryGirl.create(:game, phase: "setup_ships")
              @p1    = @game.players.first
              @p2    = @game.players.last
              @p1.name = "Brett"
              @p2.name = "Tag"
              @p1.save && @p2.save

              @board = @game.boards.first
              @sq1   = @board.squares[0]
              @sq2   = @board.squares[1]
              @sq1.state = "taken"
              @sq2.state = "taken"
              @sq1.save && @sq2.save

              @ship  = @board.ships.last

              put api_v1_board_ship_url(@board, @ship), update_ship_json
            end

            it "is not a successful request" do
              expect(response).to_not be_success
            end

            it "returns a forbidden error" do
              expect(response.status).to eq(403)
            end

            it "returns the errors hash" do
              expect(json["errors"]["squares"]).to include("square #{@sq1.id} is already taken")
            end
          end

          describe "Setting ships out of turn :" do
            before(:each) do
              @game  = FactoryGirl.create(:game, phase: "setup_ships")
              @p1    = @game.players.first
              @p2    = @game.players.last
              @p1.name = "Brett"
              @p2.name = "Tag"
              @p1.save && @p2.save

              @board = @game.boards.first
              @sq1   = @board.squares[0]
              @sq2   = @board.squares[1]
              @sq1.save && @sq2.save

              @ship  = @board.ships.last
              @game.toggle_turn

              put api_v1_board_ship_url(@board, @ship), update_ship_json
            end

            it "is not a successful request" do
              expect(response).to_not be_success
            end

            it "returns a forbidden error" do
              expect(response.status).to eq(403)
            end

            it "returns the errors hash" do
              expect(json["errors"]["squares"]).to include("cannot be set out of turn")
            end
          end
        end
      end
    end
  end
end
