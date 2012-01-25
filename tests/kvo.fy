require: "lib/kvo"

class Person {
  include: KVO
  read_write_slots: ('name, 'age, 'city, 'friends)
}

FancySpec describe: KVO with: {
  before_each: {
    @p = Person new tap: @{
      name: "Tom"
      age: 42
      city: "Berlin"
      friends: []
    }
  }

  it: "observes slot changes as expected" when: {
    name_changed = false
    new_name = nil
    old_name = nil
    @p observe: 'name with: |new old| {
      new_name = new
      old_name = old
      name_changed = true
    }

    city_changed = false
    new_city = nil
    old_city = nil
    @p observe: 'city with: |new old| {
      new_city = new
      old_city = old
      city_changed = true
    }

    @p name: "Hello"
    name_changed is: true
    new_name is: "Hello"
    old_name is: "Tom"
    @p name is: new_name

    @p age: 24
    @p age is: 24

    @p city: "Hamburg"
    city_changed is: true
    new_city is: "Hamburg"
    old_city is: "Berlin"
    @p city is: new_city
  }

  it: "observes insertions to collections correctly" when: {
    friend_added = false
    new_friend = nil
    @p observe_insertion: 'friends with: |f| {
      friend_added = true
      new_friend = f
    }

    @p friends << "Jack"
    friend_added is: true
    new_friend is: "Jack"
    @p friends first is: "Jack"

    @p friends << "Jimmy"
    new_friend is: "Jimmy"
    @p friends second is: "Jimmy"
  }

  it: "observes removals from collections correctly" when: {
    @p friends << "Jack"
    @p friends << "Jimmy"

#    @p friends is: ["Jack", "Jimmy"]

    friend_removed = false
    removed_friend = nil
    @p observe_removal: 'friends with: |f| {
      friend_removed = true
      removed_friend = f
    }

    @p friends remove: "Jack"
    friend_removed is: true
    removed_friend is: "Jack"
    @p friends remove: "Jimmy"
    removed_friend is: "Jimmy"

    @p friends << "Jack"
    @p friends << "Jimmy"
    @p friends remove_at: 0
    removed_friend is: "Jack"
    @p friends first is: "Jimmy"

    @p friends << "Jack"
    @p friends << "Tom"
    @p friends remove_at: (0,1)
    @p friends is: ["Tom"]
  }
}
