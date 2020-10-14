#!/usr/bin/env ruby

class MarsRobot < StandardError
   
    def initialize(input)
        @commands = input.split("-")
        raise StandardError, 'Invalid number of arguments' if @commands.length < 1
        
        @x = 0
        @y = 0
        
        upper_right_coords = @commands.delete_at(0).split(' ')
        raise StandardError, 'Invalid upper-right coordinates' if upper_right_coords.length != 2
        
        @size_x = upper_right_coords.first.to_i
        @size_y = upper_right_coords.last.to_i
    end

    
    def deploy

        output = ''
        
        @commands.each_slice(2) do |rover_coords, instructions|
            if rover_coords.split(' ').length == 3
                self.run(rover_coords.split(' '))
                output << self.process(instructions) + "\n"
            end
        end
        
        puts output
    end

    private

    def run(rover_coords)
        @x = rover_coords[0].to_i
        @y = rover_coords[1].to_i
        @direction = rover_coords[2]
    end

    def turn_left(step = 1)
        change_direction('-', step)
      end
    
      def turn_right(step = 1)
        change_direction('+', step)
      end
    
      def move_forward
        case @direction
        when 'N'
          @y += 1
        when 'S'
          @y -= 1
        when 'E'
          @x += 1
        when 'W'
          @x -= 1
        end
    
        raise StandardError, 'No space for rover to move' if @x > @size_x || @y > @size_y
    
        [@y, @x]
      end

      def process(commands)
        commands.each_char do |character|
          case character
          when 'L' then turn_left
          when 'R' then turn_right
          when 'M' then move_forward
          end
        end
    
        [@x, @y, @direction].join(' ')
      end

     def change_direction(operator, step)
        directions = ["N", "E", "S", "W"]
        rotation = directions.index(@direction).method(operator).call(step) % 4
        @direction = directions.rotate(rotation).first
     end
end

MarsRobot.new(ARGV.join('-')).deploy