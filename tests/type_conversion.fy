FancySpec describe: "Type Conversions" with: {
  it: "converts values correctly as specified" when: {
    "foo" ==> Symbol is: 'foo
    'foo ==> String is: "foo"
    11.11 ==> String is: "11.11"

    class UnknownClass {
      to: Array with: { to_a << "test" }
    }

    u = UnknownClass new
    u ==> Array is: [u, "test"]
  }

  it: "raises an exception if no conversion defined" when: {
    class UnknownClass

    ('foo, "foo", 42.00) each: |obj| {
      { obj ==> UnknownClass } raises: TypeConversionMissingError
    }
  }

  it: "raises an exception if conversion marked as invalid" when: {
    { 11.11 ==> Symbol } raises: InvalidTypeConversionError

    class UnknownClass {
      invalid_conversions: (String, Symbol)
    }

    { UnknownClass new ==> String } raises: InvalidTypeConversionError
    { UnknownClass new ==> Fixnum } raises: TypeConversionMissingError
  }
}
