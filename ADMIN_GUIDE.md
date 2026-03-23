# BookSend Admin Guide

## First-Time Setup

1. Visit your BookSend URL. You'll be redirected to `/first_run`.
2. Enter your name, email, and password to create the admin account.
3. A demo publication ("Getting Started with BookSend") is created automatically.
4. You're signed in and taken to your dashboard.

---

## Dashboard

**URL:** `/` (requires sign-in)

Your home screen shows all publications you have access to. From here you can:

- Click a publication to open it
- Click the **+** card to create a new publication
- Click the **gear icon** (top right) to manage people and settings

---

## Managing Publications

### Create a Publication

1. From the dashboard, click the **+** card
2. Fill in title, subtitle, author
3. Optionally upload a cover image and pick a theme color
4. Set access controls (who can edit/read)
5. Click the arrow button to create

### Inside a Publication

**URL:** `/:id/:slug`

- **Add content:** Use the page type buttons at the top to add Pages (markdown articles), Sections (dividers), or Pictures
- **Reorder content:** Drag and drop items in the table of contents
- **Publish:** Toggle the lock/globe switch to make the publication publicly accessible
- **Edit settings:** Click the gear icon in the top nav

### Branding

**URL:** `/books/:id/branding/edit`

Customize how your newsletter emails look:

- **From Name** — the sender name shown in inboxes
- **Tagline** — shown below the header in emails
- **Accent Color** — header background color (with WCAG contrast check)
- **Font Family** — choose from email-safe fonts
- **Logo** — replaces the text header in emails
- **Header Image** — shown below the header
- **Footer Text** — copyright, company info, etc.

The right panel shows a live preview as you type.

### Email Preview

**URL:** `/books/:id/preview`

- **View preview:** See how your newsletter will look in email format
- **Send preview:** Click to send a `[PREVIEW]` email to your own address (rate limited to once per 60 seconds)

---

## Subscriber Management

### How Subscribers Sign Up

Each publication has a public subscribe page:

**URL:** `/s/:slug/subscribe`

1. Visitor enters their email address
2. System sends a confirmation email (double opt-in)
3. Subscriber clicks the confirmation link: `/s/:slug/confirm/:token`
4. If the token is valid and less than 72 hours old, they're confirmed
5. They'll now receive campaigns sent from this publication

**Share this URL** with your audience, embed it on your website, or link to it from social media.

### Unsubscribe

Every email includes an unsubscribe link:

- **One-click:** `GET /unsubscribe/:token` shows confirmation page
- **POST:** `POST /unsubscribe/:token` completes the unsubscribe (RFC 8058 compliant)
- Email headers include `List-Unsubscribe` and `List-Unsubscribe-Post` for email client support

### CSV Import

**URL:** `/books/:id/subscriber_imports/new`

1. From your publication, navigate to subscriber imports
2. Upload a CSV file with an email column
3. Subscribers are imported as confirmed (active) in background batches of 100
4. Duplicates are skipped automatically

---

## Issues & Campaigns

### Creating an Issue

**URL:** `/books/:id/issues`

1. Click **New Issue**
2. Enter a **subject line** (the email subject) and optional **preview text**
3. Pick articles from your publication's content library — click articles on the right to add them to the issue
4. Optionally set a **scheduled send time**
5. Click **Create Issue**

### Sending a Campaign

1. Open an issue from the issues list
2. Click **Send Now** (confirms with a dialog)
3. The system creates a campaign, generates delivery records for all active subscribers, and dispatches emails in batches of 100
4. Track results on the issue show page: sent count, opens, clicks, bounces

### Web Version

Every issue has a public web version at `/issues/:slug` that you can share.

---

## Advertisements

### For Creators: Managing Ad Slots

**URL:** `/books/:id/ad_slots`

Ad slots define where ads appear in your newsletter emails.

1. Click **New Ad Slot**
2. Configure:
   - **Name** — e.g., "Top Banner"
   - **Position** — top, middle, or bottom of the email
   - **Pricing Model** — flat rate, CPM, or CPC
   - **Price** — in cents (e.g., 5000 = $50.00)
   - **Availability dates** — when the slot is bookable
   - **Category Policy** — restrictions (e.g., "No gambling")
   - **Listed** — whether it appears on the public marketplace
3. Your slots appear on the **Ad Marketplace** (`/marketplace`) for advertisers to browse

### For Advertisers: Creating Ad Creatives

**URL:** `/ad_creatives`

1. Browse available slots on the **Marketplace** (`/marketplace`)
2. Click **New Creative** to create your ad:
   - **Headline** — max 80 characters, plain text only
   - **Body Text** — max 300 characters, plain text only (no HTML allowed)
   - **Destination URL** — must use HTTPS
   - **Call to Action** — button text (e.g., "Learn more")
   - **Advertiser Name** — your company name
   - **Image** — optional, max 1200x400px
3. Submit for review — the system runs automated checks (keyword blocklist, URL safety)
4. Track your creative's status on the creatives index page

### Ad Review (Platform Admin)

**URL:** `/admin/ad_creatives`

Platform admins see a review queue of pending ad creatives. For each creative you can:

- View the full preview with automated check results
- **Approve** — makes it available for placement
- **Reject** — with a required reason shown to the advertiser

### How Ads Appear in Emails

Approved ads are rendered as branded cards in newsletter emails with:
- "Sponsored" label
- Headline and body text (sanitized, no HTML)
- Optional image
- CTA button linking through click tracking (`/c/:token`)

Click tracking blocks private IPs and records IP address/user agent.

---

## AI Article Generation

### Adding Sources

**URL:** `/books/:id/article_sources`

1. Click **Add Source**
2. Enter a **name** and **source URL** (any web page)
3. Set **fetch frequency** (daily or weekly)
4. The system fetches content via Jina Reader and generates articles using AI

### Reviewing Generated Articles

**URL:** `/books/:id/generated_articles`

Generated articles appear in a review queue:

- **Publish** — creates a Page in your publication with the generated content + mandatory attribution
- **Reject** — discards the article

Every generated article includes a non-removable attribution block citing the source.

### Plan Limits

| Plan  | AI Articles/Month |
|-------|-------------------|
| Seed  | 0 (not available) |
| Grow  | 10                |
| Scale | 50                |

---

## Sending Domains

**URL:** `/account/sending_domains`

Send emails from your own domain instead of the default.

1. Click **Add Domain** and enter your domain (e.g., `mail.yourdomain.com`)
2. The system generates DNS records (SPF, DKIM, etc.) via Resend
3. Add the displayed DNS records to your domain provider
4. Click **Verify Now** — the system also checks automatically every 15 minutes for up to 72 hours
5. Once verified, campaigns from your account use your custom domain

**DMARC:** A DMARC guidance section is shown on the domain page with a recommended record.

---

## Billing

**URL:** `/billing` (admin only)

View your current plan and upgrade:

| Feature           | Seed    | Grow     | Scale     |
|-------------------|---------|----------|-----------|
| Publications      | 3       | 10       | 50        |
| Subscribers       | 500     | 5,000    | 50,000    |
| AI Articles/mo    | 0       | 10       | 50        |
| Custom Domain     | No      | Yes      | Yes       |

- Click **Upgrade** to start a Stripe Checkout session
- Click **Manage Billing** to access the Stripe Customer Portal

---

## Team Management

**URL:** `/users`

### Inviting Team Members

A shareable join link is shown at the top of the users page (e.g., `/join/XXXX-XXXX-XXXX`). Share it via:
- Copy to clipboard
- QR code
- Native share dialog

New users create an account with name, email, and password using this link.

### Managing Roles

- **Member** — can access and edit publications they're granted access to
- **Administrator** — full access to all publications, can manage users and account settings

Admins can change user roles and deactivate users from the users page.

---

## Platform Admin Panel

**URL:** `/admin` (requires `platform_admin: true` on user)

To make a user a platform admin, run in the Rails console:
```ruby
User.find_by(email_address: "you@example.com").update!(platform_admin: true)
```

### Admin Features

- **Dashboard** (`/admin`) — platform-wide metrics: total accounts, users, subscribers, campaigns
- **Accounts** (`/admin/accounts`) — search accounts, view details, impersonate users (audit-logged)
- **Campaigns** (`/admin/campaigns`) — monitor all campaigns across the platform
- **Ad Review** (`/admin/ad_creatives`) — approve or reject submitted ad creatives

### Impersonation

Click **Impersonate** on any account to sign in as that account's first active user. Every impersonation is recorded in the audit log with your user ID, the target account, and your IP address.

---

## URL Reference

| Feature              | URL Pattern                          | Access       |
|----------------------|--------------------------------------|-------------|
| Dashboard            | `/`                                  | Signed in   |
| Publications index   | `/publications`                      | Public*     |
| Publication detail   | `/:id/:slug`                         | Public*     |
| Subscribe            | `/s/:handle/subscribe`               | Public      |
| Confirm subscription | `/s/:handle/confirm/:token`          | Public      |
| Unsubscribe          | `/unsubscribe/:token`                | Public      |
| Issue web version    | `/issues/:slug`                      | Public      |
| Branding             | `/books/:id/branding/edit`           | Editor      |
| Issues               | `/books/:id/issues`                  | Editor      |
| Ad Slots             | `/books/:id/ad_slots`                | Editor      |
| AI Sources           | `/books/:id/article_sources`         | Editor      |
| Generated Articles   | `/books/:id/generated_articles`      | Editor      |
| Subscriber Import    | `/books/:id/subscriber_imports/new`  | Editor      |
| Marketplace          | `/marketplace`                       | Public      |
| My Ad Creatives      | `/ad_creatives`                      | Signed in   |
| Sending Domains      | `/account/sending_domains`           | Admin       |
| Billing              | `/billing`                           | Admin       |
| Users / Settings     | `/users`                             | Signed in   |
| Platform Admin       | `/admin`                             | Platform admin |

*Public when publication is published; otherwise requires sign-in.
