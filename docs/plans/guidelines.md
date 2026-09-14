# ThanksVisa Design Guidelines

"Linear-style" visual system for daily-use B2B products

These guidelines govern product and application UI. They do not define public marketing or informational websites.

---

## 1. Core Philosophy

- Design for the 40th hour of use, not the first screenshot. Every choice should reduce fatigue, not add polish.
- Structure comes from **spacing, alignment, and hairlines** — not shadows or color.
- Color carries **meaning** (status, primary action), never decoration.
- Consistency beats novelty. The same element should always look and behave the same way everywhere.
- Density is a feature. Don't pad things out "to look clean" — clarity and density can coexist.
- Shared components and semantic design tokens are the default. Page-level implementations should not recreate established component behavior or raw visual values.

---

## 2. Color System

- This version defines the light theme only. A future dark theme should be designed from semantic tokens rather than created by mechanically inverting light-theme values.
- Use a neutral gray ramp as the foundation of the product palette, with enough steps to support page, panel, hover, border, and text roles.
- Background hierarchy uses semantic surface tokens and tint, not shadow:
  - `surface.page` for the application background
  - `surface.panel` for sections and persistent panels
  - `surface.hover` for interactive hover states
  - Each token uses the smallest contrast difference that preserves grouping and accessibility.
- **One primary color** for the single highest-priority action within each action context (for example, a page header, form footer, or dialog footer). Do not give multiple actions in the same group the primary treatment.
- Do not use secondary or tertiary brand colors for generic actions. Secondary and tertiary button variants use neutral outline, ghost, or text treatments rather than additional brand hues.
- Reserve saturated color exclusively for **status/semantic meaning**:
  - Success (green), Warning (amber), Error (red), Info (blue)
  - Used in badges, alerts, inline validation — never for generic UI chrome
- Semantic color palettes expose `main`, `onMain`, `subtle`, `onSubtle`, and `border` roles. Use `main` for the strongest semantic foreground or icon, and `subtle`/`onSubtle` for tinted surfaces.
- Use semantic border tokens with crisp neutral colors. Prefer a low-contrast `border.subtle` token for ordinary grouping and a stronger token only when the boundary must be unmistakable; do not use black at low opacity.
- Text color hierarchy: primary text near-black, secondary text mid-gray, and disabled text light-gray only when contrast and legibility remain sufficient. Do not reduce contrast solely for aesthetic reasons.
- Color must not be the only indicator of status, validation, selection, or error; pair it with text, icons, shape, or another non-color cue.

---

## 3. Elevation & Depth

- **Default state = flat.** No shadows on persistent page content (tables, panels, sidebars, cards).
- Grouping is done with:
  - 1px hairline borders, or
  - A subtle background tint shift, or
  - Whitespace/spacing alone
- Shadows are reserved *only* for elements that are genuinely floating above the page and temporary:
  - Dropdown menus
  - Modals / dialogs
  - Tooltips
  - Toasts/notifications
  - Command palettes
- All floating elements use one shared shadow/elevation token; components must not invent their own shadow values.
- When shadows are used, keep them soft and tight (small blur, low opacity, minimal Y-offset) — not the large soft "hovering card" shadow style.
- No gradients on backgrounds or buttons. Flat fills only.

---

## 4. Typography

- Use DM Sans as the typeface for product UI. A monospace typeface may be used only for code, identifiers, or other technical values.
- Use 14px as the default UI body size. Reserve 12px for supporting metadata and secondary labels; do not use smaller text for ordinary content.
- Limited weight range: regular + medium + semibold. Avoid light weights (poor legibility at small sizes) and avoid bold-everywhere.
- Use a tight, consistent type scale (12 / 14 / 16 / 20 / 24) and resist adding one-off sizes.
- Use semantic line-height tokens by text role: tighter for controls and dense data, and more relaxed for descriptions and multi-line content.

---

## 5. Layout, Spacing & Density

- Use a strict 4px-based spacing scale everywhere — no arbitrary padding, gap, or margin values.
- Use 4px and 8px as the standard corner radii. Larger radii require a specific component rationale.
- Favor **tables and lists over card grids** for data-heavy views — cards work for a handful of items, not for hundreds of rows.
- Keep table rows visually dense, but provide an accessible hit area for every interactive row and control across pointer, keyboard, and touch input. Do not add decorative padding solely for breathing room.
- Sidebar/nav: flat, minimal icons, and a subtle background tint plus text-weight change for the active item. Avoid strong pill treatments that compete with the page content.
- Avoid centering operational content in a boxed/card container in the middle of the page — let workspace content use available width. Forms, editors, and reading-focused details may use shared semantic maximum-width tokens.
- Use shared spacing and width tokens rather than page-local padding, gap, or width values.

---

## 6. Components

**Buttons**
- Primary: solid fill, primary color, no shadow.
- Secondary: outline or ghost (transparent bg, border or just text), neutral gray.
- Destructive: red text or outline by default. When a filled treatment is needed, use a low-saturation destructive surface with appropriately contrasting text rather than a saturated dark-red fill.
- No shadow on any button state, including hover — use a slight background darken instead.

**Cards (when used)**
- Prefer transparent or outlined cards with a thin 1px border, no shadow, and a 4px or 8px radius. Use a filled card only when a distinct surface grouping is needed; larger radii require a specific component rationale.
- Used for dashboards/summary widgets, not as the default container for lists of data.

**Tables**
- Use hairline row dividers without zebra striping. Use spacing, hover, and focus states to maintain row tracking.
- Use sticky headers for every scrollable table unless they harm the layout or available reading space.
- Secondary inline actions may appear on row hover or focus, but must remain operable through keyboard navigation and touch. Essential actions must never be hover-only.

**Forms/Inputs**
- Flat fields with a border, subtle background tint on focus, and a thin focus ring using the dedicated focus token — not a glow/shadow.
- Labels above fields, consistent field heights across the whole product.
- Use shared control-size tokens for inputs, buttons, and icon buttons rather than page-specific heights. The initial compact sizes are 40px inputs and 32px buttons/icon buttons across form factors; touch layouts may enlarge hit areas without changing the visual tokens.

**Badges/Tags**
- Neutral badges may identify categories or attributes and use a subtle neutral fill. Status badges use a small, low-saturation background tint of the status color with matching darker text — not a solid bright fill.

---

## 7. Iconography & Imagery

- Use the Flutter Material Symbols/Icons set throughout the product UI. Outlined and rounded styles may vary by component context, but each context must use one consistent style and weight; never mix icon sets.
- Use shared icon-size tokens: 16px small, 20px medium, and 24px large. Do not set icon sizes per page.
- Icons in working product UI are functional, not illustrative. Avoid decorative illustrations in live data screens; illustrations may support empty, onboarding, or explanatory states.
- Icon color follows text color rules (neutral gray, colored only to convey status).
- Icon-only controls must provide an accessible label and tooltip where the platform supports tooltips.

---

## 8. Motion

- Use semantic motion tokens by interaction type. Hover and state changes should feel immediate, while larger transitions may use slightly longer durations when they improve orientation.
- No bouncy/springy easing on core UI (modals, panels) — reserve playful motion for rare delight moments only, not daily-use chrome.
- Respect the user's reduced-motion preference by shortening or removing non-essential motion.
- Use skeleton loaders when the loaded layout is predictable and preserving its structure helps comprehension. Use progress indicators for short, indeterminate, or action-specific operations.

---

## 9. States & Feedback

- Every interactive element needs clear, consistent hover / active / focus / disabled states — defined once, reused everywhere.
- Empty states, loading states, and error states should be designed with the same restraint as the "happy path" — no more decorative than the rest of the product.
- Keyboard navigation and visible focus rings are non-negotiable. Focus must remain visible against every supported surface and must not depend on color alone.
- Meet WCAG 2.2 AA for contrast and keyboard-accessible interaction, including the semantic and non-color cues required to understand state.

---

## 10. Shared Implementation Rules

- Prefer the shared design-system component when one exists; do not recreate buttons, inputs, cards, dialogs, badges, or layout primitives locally.
- Define raw colors, typography values, spacing values, radii, borders, and elevation in the foundations or theme. Consuming screens should use semantic tokens.
- Keep exact token values in the design-system code; this document defines semantic roles, relationships, and usage rules.
- Consumers must not import raw `ThanksColors`, `ThanksSpacing`, or `ThanksTypography`. Standard values come from `Theme.of(context)`; custom semantic values come from `ThanksTheme.of(context)`.
- A component's default states and visual behavior should be defined once and reused across pages and applications.
- Local overrides should be reserved for genuine product requirements, not for correcting inconsistent page-level styling.

---

## 11. Quick Gut-Check Before Shipping a Screen

- [ ] Could I remove a shadow here and lose nothing?
- [ ] Is color only present where it means something (status/primary action)?
- [ ] Are borders/spacing doing the grouping work instead of boxes?
- [ ] Would this still feel calm after staring at it for 6 hours?
- [ ] Is any decorative element failing to improve comprehension, orientation, confidence, or product identity?

If the answer to the last one is "yes," remove it or document its purpose.