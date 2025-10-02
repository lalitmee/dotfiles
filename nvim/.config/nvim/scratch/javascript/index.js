const a = 1;
const b = 2;
const c = 3;

console.log(a + b + c);

// function for adding any number of numbers
function add(...numbers) {
  return numbers.reduce((acc, curr) => acc + curr, 0);
}
