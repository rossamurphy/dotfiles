# LuaSnip Snippets

This directory contains filetype-specific code snippets powered by LuaSnip.

## How Snippets Work

Snippets are shortcuts that expand into larger code blocks. They are **filetype-specific**, meaning snippets in `tex.lua` only work in `.tex` files, `python.lua` only in `.py` files, etc.

### Basic Usage

1. Type a snippet **trigger** (e.g., `iinf`)
2. Completion menu appears showing the snippet
3. Press **Tab** to navigate/select the snippet in the menu (optional if already selected)
4. Press **Space** to expand/confirm the snippet
5. Press **Tab** to jump to the next placeholder
6. Press **Shift+Tab** to jump back to the previous placeholder

### Example

In a `.tex` file:
```
Type: iinf
Completion menu shows "iinf" snippet
Press Space: expands to \int_{-\infty}^{\infty} |<cursor> dx
Press Tab: cursor moves to the 'x' in dx
Press Shift+Tab: cursor moves back to previous placeholder
```

## Keybindings

- **Tab** - Navigate completion menu / Jump to next placeholder (when in snippet)
- **Shift+Tab** - Navigate completion menu backwards / Jump to previous placeholder (when in snippet)
- **Space** - Expand/confirm selected snippet or completion

**How Tab works (priority order):**
1. **If completion menu is visible** → navigates through menu items (highest priority)
2. **If you're in an active snippet** → jumps to next placeholder
3. **Otherwise** → normal Tab behavior

This priority ensures that when you're typing a new snippet trigger and the menu appears, Tab will navigate the menu instead of jumping back to old snippet placeholders.

**Note:** Snippet triggers and jumping only work in their respective file types (e.g., LaTeX snippets only in `.tex` files).

## Special Behavior in `.tex` Files

LaTeX files have enhanced completion settings that make snippet usage more convenient:

### Instant Completion Menu
- The completion menu appears **immediately** as you type (no delay)
- This makes it easy to see available snippets without waiting

### No Auto-Selection
- Items in the completion menu are **not automatically selected**
- This prevents accidental expansions when typing normal words
- You must explicitly press **Tab** to select an item before pressing **Space** to expand

### Example Workflows

**Typing a snippet:**
```
Type: frac
Menu appears immediately showing "frac" snippet
Press Tab: selects "frac" in menu
Press Space: expands to \frac{}{}
Press Tab: jumps to first placeholder
```

**Typing a normal word:**
```
Type: fra
Menu appears showing "frac" snippet
Press Space: types "fra " (space) - does NOT expand snippet
Continue typing normally
```

**The key difference:** In `.tex` files, Space only expands if you've **explicitly selected** an item with Tab first. In other file types, completion behavior may vary.

## Available LaTeX Snippets (`tex.lua`)

### Math Environments

| Trigger | Expands To |
|---------|------------|
| `beg` | `\begin{...} ... \end{...}` |
| `eq` | `\begin{equation} ... \end{equation}` |
| `align` | `\begin{align} ... \end{align}` |

### Fractions

| Trigger | Expands To |
|---------|------------|
| `frac` | `\frac{}{}` |
| `//` | `\frac{}{}` |

### Integrals

| Trigger | Expands To |
|---------|------------|
| `int` | `\int_{a}^{b} f(x) dx` |
| `iinf` | `\int_{-\infty}^{\infty} f(x) dx` |

### Sums and Products

| Trigger | Expands To |
|---------|------------|
| `sum` | `\sum_{i=1}^{n}` |
| `prod` | `\prod_{i=1}^{n}` |
| `lim` | `\lim_{x \to \infty}` |

### Matrices

| Trigger | Expands To |
|---------|------------|
| `bmat` | `\begin{bmatrix} ... \end{bmatrix}` |
| `pmat` | `\begin{pmatrix} ... \end{pmatrix}` |
| `mat` | `\begin{matrix} ... \end{matrix}` |

### Vectors and Norms

| Trigger | Expands To |
|---------|------------|
| `vec` | `\vec{}` |
| `norm` | `\|\|` |
| `abs` | `\| \|` |

### Derivatives

| Trigger | Expands To |
|---------|------------|
| `dd` | `\frac{d}{dx}` |
| `pd` | `\frac{\partial}{\partial x}` |
| `grad` | `\nabla` |

### Probability and Expectation (ML/AI)

| Trigger | Expands To |
|---------|------------|
| `EE` | `\mathbb{E}[]` |
| `PP` | `\mathbb{P}()` |
| `prob` | `P()` |

### Common Sets

| Trigger | Expands To |
|---------|------------|
| `RR` | `\mathbb{R}` |
| `NN` | `\mathbb{N}` |
| `ZZ` | `\mathbb{Z}` |
| `QQ` | `\mathbb{Q}` |

### Subscripts and Superscripts

| Trigger | Expands To |
|---------|------------|
| `__` | `_{}` |
| `^^` | `^{}` |

### Greek Letters

| Trigger | Expands To |
|---------|------------|
| `alpha` | `\alpha` |
| `beta` | `\beta` |
| `gamma` | `\gamma` |
| `delta` | `\delta` |
| `epsilon` | `\epsilon` |
| `theta` | `\theta` |
| `lambda` | `\lambda` |
| `mu` | `\mu` |
| `sigma` | `\sigma` |
| `phi` | `\phi` |
| `omega` | `\omega` |

### Optimization (ML/AI)

| Trigger | Expands To |
|---------|------------|
| `argmax` | `\argmax_{}` |
| `argmin` | `\argmin_{}` |

### Miscellaneous

| Trigger | Expands To |
|---------|------------|
| `text` | `\text{}` |
| `cases` | `\begin{cases} ... \end{cases}` |

## Adding New Snippets

### For LaTeX (`.tex` files)

Edit `tex.lua` and add new snippets using this pattern:

```lua
s("trigger", {
    t("text to insert"),
    i(1),  -- First placeholder (tab stop)
    t("more text"),
    i(2),  -- Second placeholder
    i(0),  -- Final cursor position
}),
```

### For Other Languages

Create a new file named `<filetype>.lua` (e.g., `python.lua`, `markdown.lua`) and follow the same pattern.

**Example: `python.lua`**

```lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s("def", {
        t("def "),
        i(1, "function_name"),
        t("("),
        i(2),
        t({"):", "\t"}),
        i(3, "pass"),
        i(0),
    }),
}
```

### For All File Types

Create `all.lua` for snippets that work everywhere.

## File Structure

```
~/.config/nvim/luasnippets/
├── README.md       # This file
├── tex.lua         # LaTeX snippets (only in .tex files)
├── python.lua      # Python snippets (only in .py files)
├── markdown.lua    # Markdown snippets (only in .md files)
└── all.lua         # Global snippets (works in all files)
```

## Troubleshooting

### Snippets not working?

1. Make sure you're in the correct file type (`:set filetype?`)
2. Restart Neovim after adding new snippets
3. Check for syntax errors in your snippet file

### Tab not expanding?

- Make sure you're in a `.tex` file for LaTeX snippets
- Check that the snippet trigger is correct (case-sensitive)
- Ensure there's no conflicting Tab mapping

## Resources

- [LuaSnip Documentation](https://github.com/L3MON4D3/LuaSnip)
- [LuaSnip Snippet Syntax](https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md)
