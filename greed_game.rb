require './about_dice_project.rb'

class Game

	attr_reader :players
	
	def start
		@players = []
		puts("Let's play great Greed Game!")
		puts("Enter amount of players (more than 1)")
		players_amount = gets.chomp
		players_amount.to_i.times do
			puts("Enter player's name")
			@players.push(Player.new(gets.chomp))
		end
		print("Meet heroes! This is ")
		for player in @players
			print(" '#{player.name}'")
		end
		puts("\n\n")
	end

	def game
		final_round_begin = nil
		while not final_round_begin
			for player in players
				puts("/"*20)
				puts("Turn of #{player.name} begin")
				player.turn
				if player.total_score >= 3000
					final_round_begin = 1 
					break
				end
			end
		end
	end

	def final_round
		max_total_score = players[1].total_score
		winner_name = players[1].name
		for player in players
			next if player.total_score >= 3000
			puts("?"*20)
			puts("Last turn of #{player.name} begin")
			player.turn
			if player.total_score > max_total_score
				max_total_score = player.total_score 
				winner_name = player.name
			end
		end
		puts("#{winner_name} is winner!!!")
	end

end

class Player < DiceSet

	attr_reader :name
	attr_reader :total_score

	def initialize(initial_name)
		@name = initial_name
		@total_score = 0
    end

  	def turn		
		iterations_amount = 5
		will_roll = 0
		@score = 0

		while will_roll != nil
			roll(iterations_amount)
			print(@values)
			score1 = @score
			scoring_dice_amount = score(@values)
			if @score == score1
				@score = 0
				break
			end
			iterations_amount -= scoring_dice_amount
			puts("\nYour score: #{@score}")
			puts("\nWill you roll again?")
			puts("0 - No, 1 - Yes")
			a = gets.chomp
			will_roll = nil if a == '0'
			puts("*"*15)
		end
		if @total_score >= 300
			@total_score += @score
		else
			if @score >= 300
				@total_score += @score
				puts("You are In the Game!")
			end
		end 
		puts("\nYour total score: ", @total_score)
	end

	def score(dice)
		scoring_dice_amount = 0
	  	(1..6).each do |i|
   			amount = dice.select{|item| item == i}.length
   			if i == 1
     			@score += amount-3 < 0 ? amount*100 : 1000 + (amount-3)*100
      			scoring_dice_amount += amount
      			next
    		end
    		if i == 5
				@score += amount-3 < 0 ? amount*50 : i*100 + (amount-3)*50
				scoring_dice_amount += amount
      			next
    		end
			@score += i*100 if amount == 3
			scoring_dice_amount += amount if amount == 3
		end
		scoring_dice_amount = 0 if scoring_dice_amount == 5
		scoring_dice_amount
	end
end

game = Game.new
game.start
game.game
game.final_round