// calculator.js - Pure calculation module
// This module provides basic arithmetic operations and utilities for
// evaluating simple tokenized expressions without operator precedence.

/**
 * Adds two numbers.
 * @param {number} a
 * @param {number} b
 * @returns {number}
 */
export function add(a, b) {
  return a + b;
}

/**
 * Subtracts second number from the first.
 * @param {number} a
 * @param {number} b
 * @returns {number}
 */
export function subtract(a, b) {
  return a - b;
}

/**
 * Multiplies two numbers.
 * @param {number} a
 * @param {number} b
 * @returns {number}
 */
export function multiply(a, b) {
  return a * b;
}

/**
 * Divides the first number by the second.
 * Throws an Error when division by zero is attempted.
 * @param {number} a
 * @param {number} b
 * @returns {number}
 * @throws {Error} When b === 0
 */
export function divide(a, b) {
  if (b === 0) {
    throw new Error('Division by zero');
  }
  return a / b;
}

/**
 * Checks whether a token sequence is a valid left‑to‑right arithmetic expression.
 * Valid sequence rules:
 *   • The array length must be odd (number, operator, number, ...)
 *   • Elements at even indices (0,2,4,…) must be numbers (finite values)
 *   • Elements at odd indices must be one of the supported operator strings
 *     '+', '-', '*', '/'.
 * @param {Array<number|string>} tokens
 * @returns {boolean}
 */
export function isValidSequence(tokens) {
  if (!Array.isArray(tokens) || tokens.length === 0) {
    return false;
  }
  // Length must be odd: number operator number ... number
  if (tokens.length % 2 === 0) {
    return false;
  }
  const operators = new Set(['+', '-', '*', '/']);
  for (let i = 0; i < tokens.length; i++) {
    if (i % 2 === 0) {
      // Expect a number
      const val = tokens[i];
      if (typeof val !== 'number' || !Number.isFinite(val)) {
        return false;
      }
    } else {
      // Expect an operator string
      const op = tokens[i];
      if (typeof op !== 'string' || !operators.has(op)) {
        return false;
      }
    }
  }
  return true;
}

/**
 * Evaluates a tokenized arithmetic expression left‑to‑right without precedence.
 * Example: [2, '+', 3, '*', 4] => ((2 + 3) * 4) = 20
 *
 * The function assumes the token sequence is valid. If it is not, an Error is
 * thrown.
 *
 * @param {Array<number|string>} tokens
 * @returns {number}
 * @throws {Error} If the token sequence is invalid or a division by zero occurs.
 */
export function evaluateExpression(tokens) {
  if (!isValidSequence(tokens)) {
    throw new Error('Invalid token sequence');
  }
  // Start with the first number
  let result = tokens[0];
  for (let i = 1; i < tokens.length; i += 2) {
    const operator = tokens[i];
    const operand = tokens[i + 1];
    switch (operator) {
      case '+':
        result = add(result, operand);
        break;
      case '-':
        result = subtract(result, operand);
        break;
      case '*':
        result = multiply(result, operand);
        break;
      case '/':
        result = divide(result, operand);
        break;
      default:
        // This should never happen due to validation, but keep safety.
        throw new Error(`Unsupported operator: ${operator}`);
    }
  }
  return result;
}
