FancySpec describe: DynamicKeyHash with: {
  it: "has the correct keys & values defined" when: {
    dkh = DynamicKeyHash new
    dkh tap: @{
      name: "Chris"
      age: 25
      country: "Germany"
      nested: { yo: "off" }
    }

    hash = dkh hash
    Set[hash keys] is: $ Set[['name, 'age, 'country, 'nested]]
    hash['name] is: "Chris"
    hash['age] is: 25
    hash['country] is: "Germany"
    hash['nested] is_a?: Block . is: true
  }

  it: "returns a deeply nested hash correctly" when: {
    dkh = DynamicKeyHash new: true
    dkh tap: @{
      foo: @{
        bar: @{
          baz: "yo"
        }
      }
    }

    dkh hash is: <[
      'foo => <[
        'bar => <[
          'baz => "yo"
        ]>
      ]>
    ]>
  }
}
