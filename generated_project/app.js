// app.js - Simple Calculator core logic
// This script ties the HTML elements to pure arithmetic functions.

// Wrap everything to ensure DOM elements are available
document.addEventListener('DOMContentLoaded', () => {
  // DOM References
  const num1 = document.getElementById('num1');
  const num2 = document.getElementById('num2');
  const addBtn = document.getElementById('addBtn');
  const subBtn = document.getElementById('subBtn');
  const mulBtn = document.getElementById('mulBtn');
  const divBtn = document.getElementById('divBtn');
  const resultValue = document.getElementById('resultValue');
  const error = document.getElementById('error');

  // Utility Functions
  function parseInput(value) {
    return parseFloat(value);
  }

  function displayResult(value) {
    resultValue.textContent = value;
    error.textContent = '';
  }

  function displayError(message) {
    error.textContent = message;
    resultValue.textContent = '';
  }

  // Operation Functions
  function add(a, b) {
    return a + b;
  }

  function subtract(a, b) {
    return a - b;
  }

  function multiply(a, b) {
    return a * b;
  }

  function divide(a, b) {
    if (b === 0) {
      throw new Error('Division by zero');
    }
    return a / b;
  }

  // Event Handlers
  function handleOperation(operationFn) {
    const a = parseInput(num1.value);
    const b = parseInput(num2.value);

    if (Number.isNaN(a) || Number.isNaN(b)) {
      displayError('Please enter valid numbers');
      return;
    }

    try {
      const result = operationFn(a, b);
      displayResult(result);
    } catch (err) {
      displayError(err.message);
    }
  }

  // Attach listeners
  if (addBtn) addBtn.addEventListener('click', () => handleOperation(add));
  if (subBtn) subBtn.addEventListener('click', () => handleOperation(subtract));
  if (mulBtn) mulBtn.addEventListener('click', () => handleOperation(multiply));
  if (divBtn) divBtn.addEventListener('click', () => handleOperation(divide));

  // Expose functions for testing (optional)
  window.SimpleCalculator = {
    parseInput,
    add,
    subtract,
    multiply,
    divide,
  };
});
