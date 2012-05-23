FancySpec describe: DynamicValueArray with: {
  it: "has the correct values defined" when: {
    dva = DynamicValueArray new
    dva tap: @{
      name: "Chris"
      age: 25
      country: "Germany"
      another_symbol
      and_another_one
    } . array is: [['name, "Chris"], ['age, 25], ['country, "Germany"], 'another_symbol, 'and_another_one]
  }
}
