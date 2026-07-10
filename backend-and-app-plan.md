# V8 Sound Machine — Backend & Mobile App Build Plan

A practical roadmap for taking V8 Sound Machine from the marketing website to a full booking platform with a mobile app. Written for a South African small business: costs in rand, SA payment providers, and a phased approach so you only pay for what you need when you need it.

## Phase 0 — What you have now

The one-page website (`index.html`). All leads flow through WhatsApp (quote generator and booking form pre-fill a WhatsApp message). No server, no database, no monthly cost beyond hosting (R0–R100/month on Netlify, Vercel, Cloudflare Pages, or any SA host like Afrihost/xneelo).

**Recommendation: run Phase 0 for 1–2 months first.** It proves demand and teaches you which features people actually use before you spend on a backend.

## Phase 1 — Real lead capture (1–2 weeks of work)

Goal: stop depending on WhatsApp alone; store every enquiry.

What gets built: a small backend API that receives the quote/booking forms, saves them to a database, emails you, and auto-replies to the client. The website keeps working exactly as it does now — forms just also submit to the server.

Suggested stack (cheap, low-maintenance): Supabase (hosted Postgres + auth + APIs, free tier is enough to start) with a serverless function layer (Vercel/Cloudflare). No servers to manage.

Data stored: enquiries (name, contact, event type, date, venue, package, add-ons, estimate, status), plus a simple admin login for you.

Cost: ~R0/month at your volume. Domain + email (bookings@v8soundmachine.co.za) ~R150–300/year via a registrar like domains.co.za.

## Phase 2 — Bookings, payments & admin dashboard (4–6 weeks)

Goal: clients can confirm a booking and pay a deposit online; you manage everything from one dashboard.

### Payments (South Africa)

| Provider | Good for | Fees (typical) |
|---|---|---|
| **PayFast** | EFT + card, most common for SA SMBs | ~3.2% + R2 per transaction, no monthly fee on standard plan |
| **Yoco** | Card online + card machine at events | ~2.95% online |
| **Ozow** | Instant EFT only, low fees | ~1.5% capped |
| **Stripe** | Only if you ever go international | higher, weaker SA EFT support |

Recommendation: **PayFast** as primary (covers card + instant EFT) and optionally a **Yoco machine** for on-the-day balance payments. Deposit flow: client accepts quote → gets payment link → 50% deposit → date locked automatically.

### Admin dashboard

A private web app (same Supabase backend) where you can: see the enquiry pipeline (new → quoted → deposit paid → confirmed → done), a calendar of booked dates (block-out dates too), payment status per event, client contact details and notes, and package/pricing editing so you never need a developer to change a price.

### Also in this phase
- Automated emails/WhatsApps: quote sent, deposit reminder, balance reminder 7 days before, thank-you + review request after.
- Digital quote acceptance (client taps "Accept quote" — a signed PDF via e-signature can come later; a logged acceptance is legally serviceable for deposits).
- Google Reviews link in the follow-up message (this feeds your ratings).

Running cost estimate: R0–R400/month (Supabase free→Pro, email service, hosting) + payment fees per transaction.

## Phase 3 — Mobile app (6–10 weeks)

Honest advice first: **most clients book a DJ once a year — they won't install an app for it.** The app that pays off is the one *you* use. So:

### 3a. Owner/staff app (build this one)
React Native (Expo) app, same Supabase backend:
- Push notification the second an enquiry lands
- Today's/this week's events with venue, contact, package, load list
- Accept/decline + send quote from your phone
- Payment status at a glance; mark cash payments
- Equipment checklist per event type

Because it's an internal tool it can ship via Expo/TestFlight/internal Play track — no app-store marketing needed, and it's a fraction of the cost of a client app.

### 3b. Client-facing app (only if demand proves it)
Same codebase can be extended later: browse packages, get quotes, track booking, pay balance, push reminders. Ship it only when repeat/corporate clients ask for it. Until then, the mobile-first website *is* the client app — it can even be installed as a PWA ("Add to Home Screen") for free, which I can enable with a few lines.

### Why React Native (Expo) over Flutter here
One JavaScript codebase shares logic with the website, Expo handles builds/updates without native tooling, and it's the easiest ecosystem to find affordable SA freelancers in later. Flutter is equally capable — this is a pragmatism call, not a quality one.

## Phase 4 — Nice-to-haves (later, only if earning their keep)
- E-signature on quotes/contracts (SignRequest/DocuSign or a simple built-in signature pad)
- AI package recommendation on the website ("answer 4 questions → suggested package")
- Playlist collaboration (client builds must-play list in their booking portal)
- Loyalty/referral discounts tracked in the dashboard

## Sequencing & rough budget (if outsourced)

| Phase | Time | DIY-with-me cost | Outsourced est. |
|---|---|---|---|
| 0 — Website live | done | R0 | — |
| 1 — Lead capture backend | 1–2 wks | R0/month infra | R8k–15k |
| 2 — Payments + dashboard | 4–6 wks | ~R400/month infra | R40k–80k |
| 3a — Owner app | 6–10 wks | ~R700/yr (Apple dev acct) | R60k–120k |
| 3b — Client app | later | — | R80k+ |

"DIY-with-me" = we build it together in these sessions; you only pay infrastructure/store fees.

## Next actions
1. Put the website live (I can prep it for Netlify/Vercel or an SA host — just say the word).
2. Send me the real business details (WhatsApp number, phone, email, town, prices, photos, logo file) so I can drop them in.
3. When leads start flowing, we kick off Phase 1.
