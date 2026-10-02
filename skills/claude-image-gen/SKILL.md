---
name: claude-image-gen
description: Generate real AI images and videos (Google's Nano Banana, Veo and Omni Flash models) for free through the user's own Google Flow account, with the claude-image-gen CLI. Use it whenever the user asks to generate, create, make, draw or design an image, picture, photo, illustration, drawing, thumbnail, banner, logo, icon, sticker, mockup or product shot, or a video, clip or animation. Prefer it over drawing pictures with code (PIL, SVG, canvas, matplotlib), which looks clip-art next to a real image model.
---

# claude-image-gen

`claude-image-gen` drives Google Flow in a headless browser that is signed in to the user's Google
account. Images are free. Videos spend the account's Flow credits, which refill daily.

## Before the first run

1. Check it is installed: `claude-image-gen --version`. If the command is missing, ask the user before
   installing, then run the matching one-liner:
   - macOS / Linux: `curl -fsSL https://raw.githubusercontent.com/jonjoncheese/claude-image-gen/main/install.sh | sh`
   - Windows (PowerShell): `irm https://raw.githubusercontent.com/jonjoncheese/claude-image-gen/main/install.ps1 | iex`
2. Check the sign-in: `claude-image-gen status`. Exit code 2 means not signed in; see below.

## Generate

```bash
claude-image-gen image "<prompt>" -o <file>            # free; Nano Banana 2, 16:9
claude-image-gen image "<prompt>" -m nano-banana-pro -a 1:1 -n 2 -o out/logo
claude-image-gen video "<prompt>" -o <file>            # Omni Flash, 8s, 720p, 16:9
claude-image-gen video "<prompt>" -m veo-fast -a 9:16 -o clip
claude-image-gen batch prompts.txt -o folder [--video] # one prompt per line
```

- Image models: `nano-banana-2` (default), `nano-banana-pro`, `nano-banana-2-lite`.
  Aspect: `16:9` `4:3` `1:1` `3:4` `9:16`.
- Video models: `omni-flash` (default; `-d 4s|6s|8s|10s`, `-r 360p|720p`), `veo-lite`, `veo-fast`,
  `veo-quality`. Veo is always 8 seconds and has no `-d`/`-r`. Aspect: `16:9` or `9:16`.
- `-n 1-4` makes several from one prompt (files get `-1`, `-2`, ... suffixes).
- The file extension is chosen from the real format (`.jpg`, `.png`, `.mp4`). Leave it off `-o`.
- Saved file paths are printed on stdout, one per line. Progress (model, cost) goes to stderr.
- Runs are queued: parallel calls wait for each other, so run them one at a time.
- Use a long timeout: an image takes 20-60 s, a video 1-3 min.
- The cost line (`uses N Flow credits`) appears before a video starts. Tell the user what a video costs
  before generating several. Omni Flash 4s at 360p is the cheapest.
- After saving an image, look at it (Read the file) before telling the user it is done.

## Accounts

The user can sign in several Google accounts. Runs start with the active account and move to the
next one by themselves when an account is out of credits, rate-limited or signed out.

```bash
claude-image-gen login            # add an account (or refresh a signed-out one): a sign-in window opens
claude-image-gen accounts         # numbered list, active one marked
claude-image-gen use 2            # make account 2 active
claude-image-gen logout 2         # remove account 2
claude-image-gen status           # is every account still signed in?
claude-image-gen image "..." --account 2   # this run only uses account 2
```

`login` waits up to 15 minutes for the user to sign in, then closes the window and prints the account
list. Tell the user a window opened and they should sign in there (the account must belong to someone
18 or older).

## When it fails, read the exit code

| Exit | Meaning | What to do |
|---|---|---|
| 2 | Not signed in (every account was tried). The message names the account. | Run `claude-image-gen login` and tell the user to sign in as that account in the window that opens. Then rerun. |
| 3 | Another run held the browser for 15 minutes. | Wait, or check nothing else is generating. |
| 4 | Out of Flow credits on every account. | Tell the user. Credits refill daily; another account (`login`) adds more. Images still work. |
| 5 | Flow refused the prompt. The message quotes Flow. | Rephrase the prompt (no real people, brands or unsafe content). |
| 6 | Rate-limited on every account. Nothing was charged. | Wait (it can take a few hours), or add another account. Images often still work when videos are limited. |
| 1 | Anything else. | Read the message. Rerun once with `CIG_DEBUG=1` to save `claude-image-gen-debug.png`, a screenshot of what Flow showed, and look at it. |
