// script.js - Simple Calculator implementation (rewritten per specification)

(function() {
    // State variables & constants
    const displayEl = document.getElementById('display');
    const buttons = document.querySelectorAll('.btn');
    let currentInput = '';
    let previousValue = null; // number or null
    let operator = null; // '+', '-', '*', '/' or null
    let error = null; // error message string

    // Utility functions
    function updateDisplay() {
        if (error) {
            displayEl.value = error;
        } else if (currentInput !== '') {
            displayEl.value = currentInput;
        } else if (previousValue !== null) {
            displayEl.value = previousValue;
        } else {
            displayEl.value = '0';
        }
    }

    function resetCalculator() {
        currentInput = '';
        previousValue = null;
        operator = null;
        error = null;
        updateDisplay();
    }

    // Operation handling
    function handleDigit(digit) {
        if (error) return; // block input on error
        // Prevent multiple decimal points
        if (digit === '.' && currentInput.includes('.')) return;
        // Prevent leading zeros (except for decimal numbers)
        if (digit === '0' && currentInput === '0') return;
        if (digit !== '.' && currentInput === '0') {
            currentInput = digit; // replace leading zero
        } else {
            currentInput += digit;
        }
        updateDisplay();
    }

    function handleOperator(op) {
        if (error) return;
        // If there is a pending number, process it
        if (currentInput !== '') {
            const num = parseFloat(currentInput);
            if (previousValue === null) {
                previousValue = num;
            } else if (operator) {
                // Compute pending operation before switching operator
                computeResult();
            } else {
                previousValue = num;
            }
        }
        operator = op;
        currentInput = '';
        updateDisplay();
    }

    function computeResult() {
        if (!operator || currentInput === '' || previousValue === null) return;
        const currentNumber = parseFloat(currentInput);
        let result;
        switch (operator) {
            case '+':
                result = previousValue + currentNumber;
                break;
            case '-':
                result = previousValue - currentNumber;
                break;
            case '*':
                result = previousValue * currentNumber;
                break;
            case '/':
                if (currentNumber === 0) {
                    error = 'Cannot divide by zero';
                    updateDisplay();
                    return;
                }
                result = previousValue / currentNumber;
                break;
            default:
                return;
        }
        // Store result with limited precision to avoid floating‑point artifacts
        previousValue = parseFloat(result.toPrecision(12));
        currentInput = '';
    }

    function handleEquals() {
        if (error) return;
        computeResult();
        operator = null; // keep result as previousValue
        updateDisplay();
    }

    function handleClear() {
        resetCalculator();
    }

    // Event listeners
    function initCalculator() {
        // Click listeners for all buttons
        buttons.forEach(button => {
            button.addEventListener('click', e => {
                const val = button.dataset.value;
                if (!val) return;
                if (val >= '0' && val <= '9' || val === '.') {
                    handleDigit(val);
                } else if (['+', '-', '*', '/'].includes(val)) {
                    handleOperator(val);
                } else if (val === '=' || val.toLowerCase() === 'enter') {
                    handleEquals();
                } else if (val.toLowerCase() === 'c' || val.toLowerCase() === 'clear') {
                    handleClear();
                }
            });
        });

        // Keyboard support
        document.addEventListener('keydown', e => {
            const key = e.key;
            if (key >= '0' && key <= '9') {
                handleDigit(key);
            } else if (key === '.') {
                handleDigit(key);
            } else if (['+', '-', '*', '/'].includes(key)) {
                handleOperator(key);
            } else if (key === 'Enter' || key === '=') {
                e.preventDefault();
                handleEquals();
            } else if (key === 'Escape' || key.toLowerCase() === 'c') {
                e.preventDefault();
                handleClear();
            }
        });

        // Prevent form submission if calculator is inside a form
        document.addEventListener('submit', e => e.preventDefault());

        // Initial display
        updateDisplay();
    }

    // Initialize after DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initCalculator);
    } else {
        initCalculator();
    }

    // Optional export for testing environments
    if (typeof module !== 'undefined' && module.exports) {
        module.exports = { initCalculator };
    }
})();
