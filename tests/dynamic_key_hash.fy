FancySpec describe: DynamicKeyHash with: {
  it: "has the correct keys & values defined" when: {
    dkh = DynamicKeyHash new
    dkh tap: @{
      name: "Chris"
      age: 25
      country: "Germany"
    }

    hash = dkh hash
    Set[hash keys] is: $ Set[['name, 'age, 'country]]
    hash['name] is: "Chris"
    hash['age] is: 25
    hash['country] is: "Germany"
  }
}
