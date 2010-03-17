def create_counter: number {
  closure = {
    number = (number + 1)
  };
  closure
};

closure = (self create_counter: 100);
20 times: {
    Console println: $ closure call
}
