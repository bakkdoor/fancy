class Symbol
  def call(*args)
    if args.empty?
      send(":call")
    else
      send("call:", *args)
    end
  end
end
