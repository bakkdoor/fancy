class KVO {
  """
  Key-Value Observing Mixin class.
  Include this Class into any class to add support for Key-Value Observing.
  Inspired by Objective-C's KVO, but using @Block@s, as it fits nicer
  with Fancy's semantics.

  Example:
        class Person {
          include: KVO
          read_write_slots: ('name, 'age, 'city)
        }

        tom = Person new tap: @{
          name: \"Tom Cruise\"
          age: 55
          city: \"Hollywood\"
        }

        tom observe: 'name with: |new old| {
          new println
        }
        tom name: \"Tommy Cruise\"              # will cause \"Tommy Cruise\" to be printed
        tom age: 56                           # No observer Blocks defined, so nothing will happen
  """

  class ClassMethods {
    def define_slot_writer: slotname {
      slotname = slotname to_sym
      define_method: "#{slotname}:" with: |new_val| {
        old_val = get_slot: slotname
        set_slot: slotname value: new_val
        match new_val {
          case old_val -> nil # do nothing if no change
          case _ ->
            __kvo_slot_change__: slotname new: new_val old: old_val
        }
      }
    }

    def define_slot_reader: slotname {
      slotname = slotname to_sym
      define_method: slotname with: {
        val = get_slot: slotname
        if: (val is_a?: Fancy Enumerable) then: {
          unless: (val get_slot: '__kvo_wrappers_defined?__) do: {
            __kvo_wrap_collection_methods__: val slotname: slotname
          }
        }
        val
      }
    }
  }

  def KVO included: class {
    class extend: ClassMethods
  }

  def observe: slotname with: block {
    """
    @slotname Name of slot to be observed with @block.
    @block @Block@ to be called with old and new value of @slotname in @self.

    Registers a new observer @Block@ for @slotname in @self.
    """

    __kvo_add_observer__: block for: slotname to: __kvo_slot_observers__
  }

  def observe_insertion: slotname with: block {
    """
    @slotname Name of collection slot to be observed with @block.
    @block @Block@ to be called with value inserted in collection named @slotname in @self.

    Registers a new insertion observer @Block@ for collection named @slotname in @self.
    """

    __kvo_add_observer__: block for: slotname to: __kvo_insertion_observers__
  }

  def observe_removal: slotname with: block {
    """
    @slotname Name of collection slot to be observed with @block.
    @block @Block@ to be called with value removed from collection named @slotname in @self.

    Registers a new removal observer @Block@ for collection named @slotname in @self.
    """

    __kvo_add_observer__: block for: slotname to: __kvo_removal_observers__
  }

  # PRIVATE METHODS
  # OMG this looks FUGLY but this shall never be seen anyway

  def __kvo_slot_observers__ {
    { @__kvo_slot_observers__ = <[]> } unless: @__kvo_slot_observers__
    @__kvo_slot_observers__
  }

  private: '__kvo_slot_observers__

  def __kvo_insertion_observers__ {
    { @__kvo_insertion_observers__ = <[]> } unless: @__kvo_insertion_observers__
    @__kvo_insertion_observers__
  }
  private: '__kvo_insertion_observers__

  def __kvo_removal_observers__ {
    { @__kvo_removal_observers__ = <[]> } unless: @__kvo_removal_observers__
    @__kvo_removal_observers__
  }
  private: '__kvo_removal_observers__

  def __kvo_add_observer__: block for: slotname to: observer_list {
    slotname = slotname to_sym
    if: (observer_list[slotname]) then: |set| {
      set << block
    } else: {
      observer_list[slotname]: $ Set new: [block]
    }
  }
  private: '__kvo_add_observer__:for:to:

  def __kvo_slot_change__: slotname new: new_val old: old_val {
    if: (__kvo_slot_observers__[slotname]) then: |set| {
      set each: |b| { b call: [new_val, old_val] }
    }
  }
  private: '__kvo_slot_change__:new:old:

  def __kvo_insertion__: value for_slot: slotname {
    if: (__kvo_insertion_observers__[slotname]) then: |set| {
      set each: |b| { b call: [value] }
    }
  }

  def __kvo_removal__: value for_slot: slotname {
    if: (__kvo_removal_observers__[slotname]) then: |set| {
      set each: |b| { b call: [value] }
    }
  }

  def __kvo_wrap_collection_methods__: collection slotname: slotname {
    object = self
    collection metaclass tap: |c| {
      try {
        c alias_method: '__insert__: for: '<<
        c define_method: '<< with: |val| {
          __insert__: val
          object __kvo_insertion__: val for_slot: slotname
        }
      } catch {}

      try {
        c alias_method: '__remove__: for: 'remove:
        c define_method: 'remove: with: |val| {
          __remove__: val
          object __kvo_removal__: val for_slot: slotname
        }
      } catch {}

      try {
        c alias_method: '__remove_at__: for: 'remove_at:
        c define_method: 'remove_at: with: |index| {
          obj = __remove_at__: index
          object __kvo_removal__: obj for_slot: slotname
        }
      } catch {}
    }
    collection set_slot: '__kvo_wrappers_defined?__ value: true
  }
  private: '__kvo_wrap_collection_methods__:slotname:
}