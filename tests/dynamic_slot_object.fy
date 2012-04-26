FancySpec describe: DynamicSlotObject with: {
  it: "has the correct slots defined" when: {
    dso = DynamicSlotObject new
    dso tap: @{
      name: "Chris"
      age: 25
      country: "Germany"
    }

    dso object tap: @{
      slots is: ['name, 'age, 'country]
      class is: Object

      # getters
      name is: "Chris"
      age is: 25
      country is: "Germany"

      # setters
      name: "Jack"
      name is: "Jack"
      age: 26
      age is: 26
      country: "USA"
      country is: "USA"
    }
  }
}
