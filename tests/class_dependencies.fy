FancySpec describe: "Class dependencies" with: {
  it: "manages class dependencies correctly" when: {
    class CityFoo {
      def initialize: @name
      def name {
        "CityFoo: #{@name}"
      }
    }

    class CityBar {
      def initialize: @name
      def name {
        "CityBar: #{@name}"
      }
    }

    class Person {
      class_dependencies: ['Array, 'City]
      read_write_slots: ('name, 'age, 'city, 'friends)
      def initialize: block {
        block call: [self]
      }

      def city {
        City new: @city
      }

      def friends {
        { @friends = Array new } unless: @friends
        @friends
      }
    }

    Person setup_class_dependencies: @{
      Array: Array
      City:  CityFoo
    }

    p = Person new: @{ city: "hello" }
    p city name is: "CityFoo: hello"

    Person setup_class_dependencies: @{
      Array: Array
      City:  CityBar
    }

    Person Array is: Array
    Person City is: CityBar

    p city name is: "CityBar: hello"

    p friends tap: @{
      is: []
      class is: Array
    }

    Person setup_class_dependencies: @{ Array: Hash }

    Person new friends tap: @{
      is: <[]>
      class is: Hash
    }

    Person Array is: Hash
    Person City is: CityBar
  }

  it: "overrides setup_class_dependencies: successfully" when: {
    class MyList {
      class_dependencies: ['Array, 'Mixin]

      def self setup_class_dependencies: dependency_mappings {
        super setup_class_dependencies: dependency_mappings
        include: Mixin
      }

      def initialize: @size {
        @list = Array new: @size with: { @size random }
      }

      def each: block {
        @list each: block
      }
    }

    MyList ancestors includes?: Fancy Enumerable . is: false
    MyList setup_class_dependencies: @{ Array: Array; Mixin: Fancy Enumerable }
    MyList ancestors includes?: Fancy Enumerable . is: true

    l = MyList new: 10
    l size is: 10
    range = (0..l size)
    l each: |x| {
      range includes?: x . is: true
    }
  }
}