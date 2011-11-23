FancySpec describe: Conditions Condition with: {
  it: "signals a condition" with: 'signal! when: {
    class MyCondition : Condition {
      read_slot: 'val
      def initialize: @val
    }

    def my_method: x {
      with_restarts: {
        use_value: |v| { v }
      } do: {
        if: (x even?) then: {
          MyCondition new: x signal!
        } else: {
          x * 2
        }
      }
    }

    with_handlers: @{
      when: MyCondition do: |c| {
        c val even? is: true
        restart: 'use_value with: [c val + 1]
      }
    } do: {
      my_method: 1 . is: 2
      my_method: 2 . is: 3
    }
  }
}
