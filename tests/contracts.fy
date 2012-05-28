FancySpec describe: Class Contracts with: {
  it: "fails inclusion" when: {
    {
      class A {
        include: Fancy Enumerable
      }
    } raises: Class Contracts InterfaceMethodNotImplementedError
  }

  it: "doesn't fail inclusion" when: {
    {
      class A {
        def each: block { }
        include: Fancy Enumerable
      }
    } does_not raise: Class Contracts InterfaceMethodNotImplementedError

    {
      class B {
        provides_interface: 'each:
        include: Fancy Enumerable
      }
    } does_not raise: Class Contracts InterfaceMethodNotImplementedError
  }

  it: "returns the amount of not implemented interface methods" with: 'missing_methods_for_interface: when: {
    class Interface {
      expects_interface_on_inclusion: ['hello, 'world]
    }
    {
      class C {
        include: Interface
      }
    } raises: Class Contracts InterfaceMethodNotImplementedError with: |e| {
      e methods is: ['hello, 'world]
      e interface is: Interface
      e including_class is: C
    }

    {
      class D {
        def hello
        include: Interface
      }
    } raises: Class Contracts InterfaceMethodNotImplementedError with: |e| {
      e methods is: ['world]
      e interface is: Interface
      e including_class is: D
    }
  }
}