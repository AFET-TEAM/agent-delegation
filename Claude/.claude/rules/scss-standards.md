---
paths:
  - "**/*.scss"
  - "**/*.module.scss"
  - "**/*.css"
---

# SCSS & Style Standards

## BEM Methodology

All style naming must follow BEM (Block-Element-Modifier) with nested SCSS:

- `a-` prefix for atoms
- `m-` prefix for molecules
- `o-` prefix for organisms

```scss
.a-customerSearch {
  &__input { }
  &--disabled { }
}

.m-searchForm {
  &__field { }
  &--compact { }
}
```

## Units

- Use `rem` instead of `px` for responsive design.
- Use the project's `rem()` function for conversion.
- The `rem()` function is auto-imported by Webpack — do NOT manually import SCSS abstracts.
- No percentage-based margins (except for `position: absolute` cases).

## Colors & Fonts

- Colors and fonts from shared style files — never hardcoded hex values.
- Use design token variables from `_color.scss` and `fonts.scss`.
- In Ant Design context, use `theme.useToken()` for colors.

## Anti-Patterns (Forbidden)

- No `!important` — if unavoidable, document the reason.
- No inline styles — if unavoidable, document the reason.
- No empty SCSS classes.
- No `isMobile` boolean for responsive design — use CSS media queries.
- No unnecessary `classNames()` for single static classes.
- No hardcoded colors — use design tokens.

## classNames Usage

- Use `@extend` for combining utility classes in SCSS.
- Do NOT use `classNames()` for static single classes — use direct class references.
