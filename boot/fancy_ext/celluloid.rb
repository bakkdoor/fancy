require("rubygems")
require("celluloid")

module Celluloid
  alias_method ":abort", :abort
  alias_method ":terminate", :terminate
  alias_method "signal:value:", :signal
  alias_method "wait:", :wait
  alias_method ":current_actor", :current_actor
  alias_method ":tasks", :tasks
  alias_method ":links", :links
  alias_method "link:", :link
  alias_method "unlink:", :unlink
  alias_method "notify_link:", :notify_link
  alias_method "notify_unlink:", :notify_unlink
  alias_method "linked_to?:", :linked_to?
  alias_method "sleep:", :sleep

  module ClassMethods
    define_method(":new") do
      proxy = Celluloid::Actor.new(allocate).proxy
      proxy.send(:__send__, ":initialize")
      proxy
    end

    define_method(":new_link") do
      current_actor = Celluloid.current_actor
      raise NotActorError, "can't link outside actor context" unless current_actor

      proxy = Actor.new(allocate).proxy
      current_actor.link proxy
      proxy.send(:__send__, ":initialize")
      proxy
    end


    define_method("new:") do |arg|
      proxy = Celluloid::Actor.new(allocate).proxy
      proxy.send(:__send__, "initialize:", arg)
      proxy
    end

    define_method("new_link:") do |arg|
      current_actor = Celluloid.current_actor
      raise NotActorError, "can't link outside actor context" unless current_actor

      proxy = Celluloid::Actor.new(allocate).proxy
      current_actor.link proxy
      proxy.send(:__send__, "initialize:", arg)
      proxy
    end

    define_method("define_constructor_class_method:") do |method_name|
      self.metaclass.send(:define_method, "new:#{method_name}") do |*args|
        proxy = Celluloid::Actor.new(allocate).proxy
        proxy.send(:__send__, "initialize:#{method_name}", *args)
        proxy
      end

      self.metaclass.send(:define_method, "new_link:#{method_name}") do |*args|
        current_actor = Celluloid.current_actor
        raise NotActorError, "can't link outside actor context" unless current_actor

        proxy = Actor.new(allocate).proxy
        current_actor.link proxy
        proxy.send(:__send__, "initialize:#{method_name}", *args)
        proxy
      end
    end

    define_method("supervise:") do |args|
      supervise(*args)
    end

    define_method("supervise:do:") do |args, block|
      supervise(*args, &block)
    end

    define_method("supervise_as:") do |name|
      supervise_as(name)
    end

    define_method("supervise_as:with:") do |name, args|
      supervise_as(name, *args)
    end

    define_method("supervise_as:with:do:") do |name, args, block|
      supervise_as(name, *args, &block)
    end
  end
end
