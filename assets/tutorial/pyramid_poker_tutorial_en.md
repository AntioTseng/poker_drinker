# Pyramid Poker — Tutorial

## Objective
Pick a **pyramid (table) card** as the reference, then guess whether the next card drawn from the **deck** will be:
- **Higher**, or
- **Lower**.

## How to Play (Step by Step)
1. In the pyramid, **tap a card** to select it. This selected card becomes the reference for your next guess.
2. Press **Higher** or **Lower** to make your guess.
3. The game draws the next card from the deck:
   - If you’re correct: the round succeeds and **no penalty** is applied.
   - If you’re wrong: the round fails and a **penalty** is calculated.
   - If it’s a tie (same rank): a special case applies and the penalty is usually higher.
4. A result dialog appears. Press **Cover selected card** to place the drawn card onto the selected pyramid card, then continue.

## What is a “Tie”
A **tie** happens when the drawn card’s rank is **exactly the same** as the selected pyramid card’s rank.

## Penalty (Key Rules)
The penalty is based on:
- **Layer multiplier**: depends on which layer the selected card is in (configured in Settings).
- **Card count**: how many times that position has been covered (more covers → higher count).
- **Initial unit**: your base unit value from Settings.
- **Tie multiplier**: applied only when a tie occurs.

### Normal wrong guess
Penalty ≈ layer multiplier × card count × initial unit

### Tie
Penalty ≈ layer multiplier × card count × initial unit × tie multiplier

> Note: The exact values shown in the result dialog are the source of truth.

## Tips
- Picking a mid-rank reference card often reduces risk.
- If ties feel too punishing, adjust the tie multiplier or initial unit.
- Re-covering the same position increases card count, so consider spreading your selections.
