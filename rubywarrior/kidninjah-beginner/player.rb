
class Player
  MAX_HEALTH = 20

  def initialize
    @previous_health = MAX_HEALTH
    @direction = :backward
    @captives = 1
  end

  def play_turn warrior
    square = warrior.feel @direction
    under_attack = warrior.health < @previous_health
    too_weak_to_fight = warrior.health < MAX_HEALTH / 2

    case
      when under_attack
        if too_weak_to_fight
          back_away warrior
        elsif square.enemy?
          warrior.attack! @direction
        elsif square.empty?
          warrior.walk! @direction
        end

      when warrior.health < MAX_HEALTH
        warrior.rest!

      when square.enemy?
        warrior.attack! @direction

      when square.captive?
        warrior.rescue! @direction
        @captives -= 1

      when square.wall?
        reverse_direction warrior

      when square.stairs?
        if @captives > 0
          reverse_direction warrior
        else
          warrior.walk! @direction
        end

      else
        warrior.walk! @direction

    end

    @previous_health = warrior.health
  end


private
  def back_away warrior
    warrior.walk! @direction == :forward ? :backward : :forward
  end

  # def call_it face
  #   flip = rand > 0.5 ? :heads : :tails
  #   flip == face
  # end

  def reverse_direction warrior
    @direction = @direction == :forward ? :backward : :forward
    warrior.walk! @direction
  end
end
