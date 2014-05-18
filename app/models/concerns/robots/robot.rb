module Robots
  module Robot
    def set_robot_attributes
      write_attribute(:name, name)
    end

    def set_ships
      set
    end

  private
    def method_missing(method, *args, &block)
      if (method.to_s.slice(0..2) == "set" && method.to_s.slice(-3..-1) == "for")
        return Robots::Settable::SetterProxy.new({owner: board_for(*args)}).set
      end
    end
  end
end
