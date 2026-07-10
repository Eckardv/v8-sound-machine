# V8 Sound Machine — Brand Kit

Single source of truth for the visual identity of v8sm.co.za (website, self-hosted) and V8 Office (`/app`, the CRM PWA). Every value below is extracted from the shipped code — when improving the site, match these tokens instead of inventing new ones. Last synced with the code: July 2026.

---

## 1. Brand essence

- **Who:** Event sound, lighting & entertainment company — Wellington, Western Cape, serving a 200 km radius.
- **Personality:** Chrome and horsepower meets stage light. Confident, warm, professional — a premium machine with a human operator.
- **Tagline:** *Power Your Event.*
- **The metaphor that drives every visual choice:** a V8 engine on a lit stage. Chrome (metal, precision), neon magenta/purple/blue (stage lighting), film grain (haze in the beam), EQ bars and grille slats (the machine's instruments).

## 2. Logo

| Asset | Use | Notes |
|---|---|---|
| `logo.webp` (1024px, ~357 KB) | All on-page `<img>` (site nav, hero) | True alpha channel — glow fades to transparent |
| `app/logo.webp` (512px) | App header, lock screen | Same treatment, smaller |
| `logo.png` (1024px, RGBA) | Favicon, `apple-touch-icon`, `og:image`, PWA manifest, printed invoices | Kept as PNG for scraper/print compatibility |
| `logo-original.png` | Backup of the pre-transparency original (solid black square) | Never ship; source of truth if the cutout must be regenerated |

Rules:
- The emblem sits directly on dark surfaces — never re-add a background plate on the website.
- On white (print documents), place it on the black rounded chip (`background:#0a0a0a; border-radius:10px; padding:6px`) as the invoices do.
- Never use `mix-blend-mode` tricks on the logo; the alpha channel is real.
- Windows note: logo files have arrived read-only before — clear the attribute before overwriting.

## 3. Color

### Brand palette (dark theme — the primary identity)

| Token | Hex | Role |
|---|---|---|
| `--red` | `#ff2da4` | Brand magenta (primary accent; var named "red" for historical reasons — do not rename casually, it's used everywhere) |
| `--red-dark` | `#b3126f` | Magenta shade (avatar gradients) |
| `--purple` | `#8b3dff` | Mid gradient stop, secondary accent |
| `--blue` | `#27a6ff` | End gradient stop, focus rings, info accents |
| `--grad` | `linear-gradient(120deg,#ff2da4,#8b3dff 55%,#27a6ff)` | THE brand gradient — eyebrows, active states, EQ bars, grille |
| `--black` | `#0a0a0a` | Page background |
| `--dark` | `#131313` | Alternating section background (`#pricing`, `#gallery`, `#faq`) |
| `--card` | `#1a1a1a` | Card surface |
| `--card2` | `#202020` | Inputs, nested surfaces |
| `--text` | `#eaeaea` | Body text |
| `--muted` | `#9a9a9a` | Secondary text, placeholders (never lighter than this on dark) |
| `--line` | `#2a2a2a` | Borders, dividers |
| `--chrome-1/2/3` | `#f5f5f5` / `#b8bcc2` / `#6e747c` | Chrome-text gradient stops |

Functional colors: star amber `#ffb400`, success green `#2ecc71` (app), danger `#ff7070` on `#330d0d` (app). (WhatsApp green `#25d366` retired from the website July 2026 — contact is email-first now; the app may still use it internally.)

### Light mode overrides

`body.light` remaps: `--black:#f4f4f6 --dark:#eaecef --card:#ffffff --card2:#f1f2f5 --text:#1c1c22 --muted:#5c5e66 --line:#d9dbe1`, chrome stops invert to dark grays. **The nav and hero deliberately stay dark in light mode** — the brand's stage never turns its lights on. Accents (`--red/--purple/--blue`) are identical in both themes.

### Usage rules

- Color strategy is **committed dark + one gradient**: the magenta→purple→blue gradient is the only saturated voice. Never introduce a new hue.
- Accents highlight; they never carry body text. Text on dark is `--text`/`--muted` only.
- Contrast floor: 4.5:1 body text, 3:1 large text — both themes independently.
- Gradients always run `120deg` (buttons/eyebrow contexts) or `135deg` (small square icons/fabs).

## 4. Typography

| Role | Face | Weights | Treatment |
|---|---|---|---|
| Display (h1–h4) | **Oswald** | 500 / 600 / 700 | `uppercase`, `letter-spacing:.04em`, `line-height:1.15`, `text-wrap:balance` |
| Body | **Space Grotesk** | 400 / 500 / 600 / 700 | `letter-spacing:-.005em`, `line-height:1.6`, `text-wrap:pretty` on prose |

Google Fonts URL (single request):
`https://fonts.googleapis.com/css2?family=Oswald:wght@500;600;700&family=Space+Grotesk:wght@400;500;600;700&display=swap`

Scale in use: hero h1 `clamp(1.5rem,4.5vw,2.5rem)` · section titles `clamp(1.7rem,4.5vw,2.6rem)` · card h3 `~1.05rem` · body `.9–.95rem` · captions/eyebrows `.78–.8rem`.

**Chrome text** — the signature type treatment. One key word per section title gets:
```css
.chrome-text{background:linear-gradient(180deg,var(--chrome-1) 0%,var(--chrome-2) 45%,var(--chrome-3) 55%,var(--chrome-1) 100%);-webkit-background-clip:text;background-clip:text;color:transparent}
```
Use on at most one word/number per heading ("Our **Services**", stat numbers). This is committed brand identity — keep it, don't spread it to body text.

## 5. Signature elements (what makes it look like V8)

1. **Section cadence** — every section opens: magenta eyebrow (`.section-tag`, 700, `.25em` tracking, uppercase) → Oswald title with one chrome word → **grille divider** → muted sub-line. The grille is a 64×4px gradient bar masked into slats (`repeating-linear-gradient` mask, 8px bar / 6px gap) — an engine grille, not a generic underline.
2. **Lit-stage hero** — two-light composition (magenta spotlight from above, purple footlight from below) + vignette + a fine fader-grid (46px vertical lines) masked to dissolve around the emblem. Not decorative blobs — a stage.
3. **Film grain** — full-site SVG turbulence overlay, `opacity:.05`, `mix-blend-mode:overlay` (light mode: `.04`/`multiply`), fixed, `z-index:150`. The "expensive" texture. Never remove; never increase past 6%.
4. **EQ bars** — 7 animated gradient bars under the hero CTAs (`@keyframes eq`, 1s alternate, staggered .12s).
5. **Card stage-light** — a 240px radial magenta→purple glow tracks the pointer over service/pricing cards (CSS vars `--mx/--my` set via `pointermove`; fine-pointer + motion-safe only).
6. **Chrome glint** — a skewed white sheen sweeps the primary CTA on hover (`.6s cubic-bezier(.22,1,.36,1)`).
7. **Edge-lit cards** — `inset 0 1px 0 rgba(255,255,255,.045)` top highlight + `0 18px 40px -30px rgba(0,0,0,.9)` floor shadow on every card surface.
8. **Premium layer (July 2026)** — WebGL volumetric beam shader on the hero (`#stage`, screen-blended so the CSS hero is the fallback), opt-in Web-Audio synth loop driving the EQ bars + shader (`AudioMachine`), preloader curtain (session-once), chrome-stroke marquee, gallery `<dialog>` lightbox, GSAP/ScrollTrigger section choreography + Lenis smooth scroll (all skipped under reduced motion or if CDNs fail — content stays visible).

## 6. Motion

| Pattern | Value |
|---|---|
| Micro-interactions (hovers, presses) | `.15s`; press feedback `transform:scale(.96–.97)` |
| State transitions (underline, spotlight fade) | `.3–.4s` |
| Scroll reveal | `.7s cubic-bezier(.16,1,.3,1)` from `translateY(16px) scale(.995)`, 70 ms sibling stagger (max 6) |
| Easing | Always ease-out expo-family curves (`cubic-bezier(.16,1,.3,1)` / `(.22,1,.36,1)`). Never bounce/elastic/linear. |
| Nav | Condenses 66px→56px past 24px scroll; gradient underline draws in `scaleX` from left; scroll-spy highlights current section (IntersectionObserver, mid-viewport band) |
| Reduced motion | Every animation has a `prefers-reduced-motion:reduce` kill switch — new animations must be added to that block |

## 7. Iconography

- **System:** inline SVG, 24px viewBox, Lucide-style outline — `stroke:currentColor; stroke-width:1.75; stroke-linecap/join:round; fill:none` (class `.icon`). Brand glyphs (Facebook, TikTok, YouTube, bolt) are filled via `.icon-fill`.
- **Sizes:** buttons 18px · contact chips 20px · socials 20px · fabs 26px · service badges 24px inside a 48px gradient-tinted rounded square.
- **Never use emoji as UI icons** on the website. (The app still uses emoji for event-type markers 💍🎉💼 — known debt, acceptable there.)
- Icon accompanies text or carries an `aria-label`.

## 8. Layout & spacing

- Container: `min(1140px, 92%)`; sections `padding:72px 0`; card radius `--radius:14px`; buttons/inputs radius 8px; chips/pills 20px.
- Section backgrounds alternate `--black` / `--dark` for rhythm.
- Breakpoints in use: **900px** (nav→burger), **860px** (2-col grids→1), **700px** (stats 4→2). Grids are `auto-fit,minmax()` where possible.
- Z-index scale: content 0–10 · grain 150 · mobile menu 190 · nav 200 · fabs 300 · toast 400 (app lock screen 500). Leaflet map contained with `z-index:0`.
- Touch targets ≥44px (compact nav toggles ≥40px).

## 9. Components (canonical versions)

- **Primary CTA** `.btn-red`: gradient `120deg #ff2da4→#8b3dff`, white text, glow shadow `0 4px 18px rgba(255,45,164,.35)`, glint on hover.
- **Secondary** `.btn-ghost`: transparent, `1px` chrome border, brightens on hover.
- **Cards** `.svc/.plan/.testi/.panel`: `--card` bg, `--line` border, radius 14, edge-light, hover lift `-4px` + magenta border (services).
- **Featured plan**: magenta border + `0 0 44px rgba(255,45,164,.22)` glow + floating "Most popular" badge (never clip it — no `overflow:hidden` on `.plan`).
- **Forms**: labels uppercase `.8rem` muted; inputs `--card2` bg, focus = magenta border + 2px blue `:focus-visible` ring; placeholders `--muted`.
- **Toast**: bottom-center slide-up, 3.5s auto-dismiss.
- **Coverage map**: Leaflet/OSM, circle `color:#ff2da4, weight:2, fill:#8b3dff @ 12%`, 200 km radius on Wellington `[-33.6392, 19.0112]`.
- **Print documents** (quotes/invoices): white paper, `#ff2da4` heading + 3px rule, logo on black chip, Segoe UI/Arial stack, ref formats `EQ-YYYY-XXXXX` (site quotes), `QYYYY-NNN` / `INVYYYY-NNN` (app).

## 10. Voice & copy

- **Register:** confident, warm, plain-spoken. Short sentences, em-dashes for rhythm. Sentence case everywhere except Oswald display headings (uppercase by CSS, not by writing).
- **South African grounding:** prices in rand (`R3,950`), local references (load-shedding, Winelands, procurement invoicing), bilingual EN/AF toggle (`I18N` map — add `data-i18n` keys for any new user-facing string in translated sections).
- **Recurring themes:** transparency ("no surprises"), inclusion of setup/pack-down, email-first contact (mailto: flows with pre-filled subject/body — the business phones clients back, clients don't message in), 24-hour reply promise, 50% deposit secures the date.
- Buttons say exactly what happens: "Email This Quote to Us", "Save Quote as PDF".

## 11. Non-negotiables when making changes

1. Don't add new hues, fonts, or a third radius size — extend with existing tokens.
2. Nav + hero stay dark in both themes.
3. Every new animation: ease-out curve, ≤.7s, added to the reduced-motion block.
4. Every new interactive element: hover + focus-visible + active states, ≥44px touch target.
5. Test both themes and 375px mobile before shipping; no horizontal scroll.
6. `deploy/` mirrors root (one intentional Supabase-comment diff), then rebuild `deploy.zip` — the live site only updates when the zip is re-uploaded to Netlify. Bump `app/sw.js` cache name when app assets change.
7. The chrome-text treatment and Oswald/Space Grotesk pairing are committed identity — improvements build on them, not around them.
