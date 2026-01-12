# SimpleCalc

**SimpleCalc** is a lightweight, responsive web calculator built with **HTML**, **CSS**, and **JavaScript**. It offers a clean, mobile‑friendly UI and supports the basic arithmetic operations you need for quick calculations.

---

## Tech Stack
- **HTML** – Structure of the calculator UI.
- **CSS** – Modern styling using CSS Grid, custom properties, and a responsive media query.
- **JavaScript** – A small `Calculator` class that handles input, operations, display logic, and error handling.

---

## Features
- **Basic arithmetic** – addition, subtraction, multiplication, division.
- **Decimal support** – one decimal point per number.
- **Clear (C) button** – resets the calculator to its initial state.
- **Equals (=) button** – computes the current expression.
- **Responsive design** – layout adapts at a 600 px breakpoint for mobile devices.
- **Keyboard shortcuts** – full operation via the keyboard (see *Usage*).
- **Error handling** – division‑by‑zero displays `Error` and clears the calculator.
- **No external dependencies** – pure client‑side implementation.

---

## Installation
1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/simplecalc.git
   cd simplecalc
   ```
2. **Open the application**
   - Open `index.html` in any modern browser (Chrome, Firefox, Edge, Safari, …).
   - *Optional*: For a smoother development experience you can serve the folder with a static server, e.g.
     ```bash
     npx serve .   # or `live-server`, `python -m http.server`, etc.
     ```

---

## Usage
### UI Layout
- **Display** – read‑only `<input id="display" class="calculator-display">` shows the current input or result.
- **Digits (0‑9) & decimal point** – buttons with class `digit` and a `data-value` attribute. Clicking appends the character to the current number.
- **Operators** – buttons with class `operator` and a `data-operator` attribute (`add`, `subtract`, `multiply`, `divide`). They set the pending operation and allow chaining.
- **Clear (C)** – button with `id="clear"` resets the calculator.
- **Equals (=)** – button with `id="equals"` triggers the computation.

### Keyboard Shortcuts
| Key | Action |
|-----|--------|
| `0`‑`9` | Enter the corresponding digit |
| `.` | Add a decimal point (only one per number) |
| `+` | Addition |
| `-` | Subtraction |
| `*` or `x` | Multiplication |
| `/` | Division |
| `Enter` or `=` | Compute the result |
| `Escape` or `c` | Clear the calculator |

The calculator listens for these keys globally, so you can work entirely without the mouse/touch.

---

## Responsive Design
A single media query targets screens **≤ 600 px**:
```css
@media (max-width: 600px) {
    /* reduces max‑width, shrinks font‑sizes and button padding */
}
```
The UI scales down, the display font becomes smaller, and button spacing adapts for comfortable tapping on phones and tablets.

---

## Error Handling
When a division by zero is attempted, the calculator displays the message `Error` and automatically resets the internal state, preventing further invalid operations until the user clears or starts a new calculation.

---

## Contributing
Contributions are welcome! Please follow these steps:
1. **Fork the repository**.
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes** and ensure the application still works in a browser.
4. **Commit** with a clear message.
5. **Push** to your fork and open a **Pull Request** against the `main` branch.
6. If you find a bug or have an idea, open an **Issue** describing the problem or suggestion.

Please keep the code style consistent with the existing files (indentation, naming, and comments).

---

## License
This project is released under the **MIT License** – see the `LICENSE` file for details. (Replace with your preferred license if different.)

---

## File Structure
```
/simplecalc
│   index.html      # Markup – defines the calculator layout and IDs/classes.
│   style.css       # Styles – CSS Grid layout, variables, and media query.
│   script.js       # Logic – `Calculator` class and DOM event wiring.
│   README.md       # Documentation (this file).
│   LICENSE         # License file (optional placeholder).
│   screenshot.png  # Optional screenshot for the README.
```

---

## Screenshot
![Calculator Screenshot](screenshot.png)
