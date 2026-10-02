<h1 align="center">claude-image-gen</h1>

<p align="center">
  <strong>Free AI images and videos in Claude Code, from your own Google Flow account.</strong><br>
  Nano Banana for images. Veo and Omni Flash for video. Headless, one file, no API key.
</p>

<p align="center">
  Finally, AI image generation without the cost. Claude users, you can thank me by starring ⭐ or contributing to this repo.
</p>

<p align="center">
  <a href="https://github.com/jonjoncheese/claude-image-gen/stargazers"><img src="https://img.shields.io/github/stars/jonjoncheese/claude-image-gen?style=flat&color=yellow" alt="Stars"></a>
  <a href="#install"><img src="https://img.shields.io/badge/macOS%20%C2%B7%20Windows%20%C2%B7%20Linux-supported-blue?style=flat" alt="macOS, Windows, Linux"></a>
  <a href="#claude-code"><img src="https://img.shields.io/badge/Claude_Code-plugin-orange?style=flat" alt="Claude Code plugin"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=flat" alt="MIT"></a>
</p>

<p align="center">
  <a href="#see-it">See it</a> ·
  <a href="#install">Install</a> ·
  <a href="#use-it">Use it</a> ·
  <a href="#models-and-costs">Models</a> ·
  <a href="#signing-in">Signing in</a> ·
  <a href="#troubleshooting">Troubleshooting</a> ·
  <a href="#faq">FAQ</a>
</p>

---

## See it

You ask Claude for a picture. Claude runs one command. The file lands in your project.

```text
> make a watercolor fox reading under a mushroom for the blog header

● claude-image-gen image "a tiny watercolor fox reading a book under a mushroom" -o blog/header
  image | Nano Banana 2 | 16:9 | x1 | free
  /home/you/site/blog/header.jpg
```

<table>
<tr>
<td width="33%"><img src="docs/fox.jpg" alt="Watercolor fox reading under a mushroom"><br><sub><code>image "a tiny watercolor fox reading a book under a mushroom"</code></sub></td>
<td width="33%"><img src="docs/mug.jpg" alt="Blue ceramic mug on a wooden desk"><br><sub><code>image "a blue ceramic mug on a wooden desk, product photo" -m nano-banana-pro -a 1:1</code></sub></td>
<td width="33%"><img src="docs/lighthouse.gif" alt="Drone shot of a lighthouse at sunset"><br><sub><code>video "a lighthouse on a cliff at sunset, waves crashing, drone shot" -m veo-lite</code></sub></td>
</tr>
</table>

Each one came straight out of the command under it, unedited (the GIF is cut down from the 8-second MP4).

## Install

**1. Get the command.** Pick one:

```bash
# macOS (Homebrew; installs Node.js for you)
brew tap jonjoncheese/claude-image-gen https://github.com/jonjoncheese/claude-image-gen && brew trust jonjoncheese/claude-image-gen && brew install claude-image-gen

# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/jonjoncheese/claude-image-gen/main/install.sh | sh
```

```powershell
# Windows (PowerShell)
irm https://raw.githubusercontent.com/jonjoncheese/claude-image-gen/main/install.ps1 | iex
```

**2. Sign in.**

```bash
claude-image-gen login
```

A browser window opens on Google's sign-in page. Sign in, wait for Flow to load, and the window closes by itself. **The Google account has to belong to someone 18 or older.** That's Google's rule for Flow. Have more than one Google account? Run `login` again for each; see [Signing in](#signing-in).

**3. Make something.**

```bash
claude-image-gen image "a red barn under a blue sky, flat illustration"
```

<details>
<summary>Other ways to install, and what you need</summary>

You need **Node.js 22+** (the installers set it up through Homebrew or winget if it's missing) and any **Chromium-based browser**: Chrome, Edge, Brave or Chromium. Every Windows PC already has Edge.

With npm:

```bash
npm install -g github:jonjoncheese/claude-image-gen
```

Or skip installing: the whole tool is [one file](claude-image-gen.js). Download it and run `node claude-image-gen.js`.

Uninstall: `brew uninstall claude-image-gen`, or delete `~/.local/share/claude-image-gen` and `~/.local/bin/claude-image-gen` (macOS/Linux) or `%LOCALAPPDATA%\claude-image-gen` (Windows). Your accounts live in `~/.claude-image-gen`; delete that too.

</details>

### Claude Code

Add the plugin and Claude learns every command, model and error code on its own:

```bash
claude plugin marketplace add jonjoncheese/claude-image-gen && claude plugin install flow-image-gen@flow-image-gen
```

Using another agent (Codex, Cursor, Gemini CLI, ...)? It works anywhere a model can run a terminal command. Point the agent at [skills/claude-image-gen/SKILL.md](skills/claude-image-gen/SKILL.md).

## Use it

```bash
claude-image-gen image "<prompt>"                        # one image, saved in the current folder
claude-image-gen image "<prompt>" -o art/cover            # choose the file name (the extension is added for you)
claude-image-gen image "<prompt>" -a 9:16 -n 4            # four portrait images from one prompt
claude-image-gen image "<prompt>" -m nano-banana-pro      # a different model
claude-image-gen video "<prompt>"                         # an 8-second 720p video with Omni Flash
claude-image-gen video "<prompt>" -d 4s -r 360p           # the cheapest video
claude-image-gen video "<prompt>" -m veo-fast -a 9:16     # a vertical Veo clip
claude-image-gen batch prompts.txt -o images              # one image per line of prompts.txt
claude-image-gen batch prompts.txt -o clips --video       # one video per line
claude-image-gen accounts                                 # your Google accounts; see Signing in
```

| Option | Values |
|---|---|
| `-o, --out` | Output file, or folder for `batch` |
| `-m, --model` | See [models](#models-and-costs) |
| `-a, --aspect` | Images: `16:9` (default) `4:3` `1:1` `3:4` `9:16`. Videos: `16:9` (default) `9:16` |
| `-n, --count` | `1` to `4` from one prompt (files get `-1`, `-2`, ... on the end) |
| `-d, --duration` | Omni Flash only: `4s` `6s` `8s` (default) `10s` |
| `-r, --resolution` | Omni Flash only: `360p` `720p` (default) |
| `--show` | Show the browser window instead of running headless |
| `--account` | Use only this account (its number from `accounts`, or its email) |
| `--browser` | `chrome` `edge` `brave` `chromium` (default: the one the account signed in with) |

**Batch files** have one prompt per line. Blank lines and lines starting with `#` are skipped. Run the same batch again and it skips everything already saved, so a run that stopped halfway picks up where it left off. It stops early after 3 failures in a row.

Saved file paths go to stdout, one per line, and progress goes to stderr, so scripts can use the output directly: `open "$(claude-image-gen image 'a cat')"`.

## Models and costs

| Kind | `-m` | Flow's name | Cost | Notes |
|---|---|---|---|---|
| Image | `nano-banana-2` (default) | Nano Banana 2 | free | |
| Image | `nano-banana-pro` | Nano Banana Pro | free | Best quality and text rendering |
| Image | `nano-banana-2-lite` | Nano Banana 2 Lite | free | Fastest |
| Video | `omni-flash` (default) | Omni 1.1 Flash | 4 to 15 credits | The only model where you choose the length (4/6/8/10s) and resolution (360p/720p). 4s at 360p is the cheapest. |
| Video | `veo-lite` | Veo 3.1 - Lite | 10 to 12 credits | Always 8s at 720p |
| Video | `veo-fast` | Veo 3.1 - Fast | 20 credits | Always 8s at 720p |
| Video | `veo-quality` | Veo 3.1 - Quality | 100 credits | Always 8s at 720p |

These were the prices at the time of writing. Google changes them, so the tool reads the live price from Flow and prints it (`uses 7 Flow credits`) before every video. Videos come with sound.

The model flags match Flow's menu by pattern, so when Google ships Veo 3.2 the same `veo-fast` flag picks it up. You can also pass Flow's exact label: `-m "Veo 3.1 - Fast"`.

## Signing in

```bash
claude-image-gen login        # sign in once; run it again to add more Google accounts
claude-image-gen accounts     # see them
```

```text
Accounts (runs start with the active one and switch to the next when one is out of credits,
rate-limited or signed out):
  1. you@gmail.com  (active)
  2. you.second@gmail.com
```

**More accounts, more generations.** Every `login` adds one Google account. Runs use the active account, and when it's out of credits, rate-limited or signed out, they move on to the next one by themselves. Nothing to configure.

| Command | What it does |
|---|---|
| `claude-image-gen login` | Add an account. Sign in to one you already added to refresh it. |
| `claude-image-gen accounts` | List accounts and show which one is active. |
| `claude-image-gen use 2` | Make account 2 the one runs start with (a number or an email). |
| `claude-image-gen logout 2` | Remove account 2. With no number, removes the active one. |
| `claude-image-gen status` | Check that every account is still signed in. |
| `--account 2` | Use only account 2 for this one command. |

- **Google signs accounts out now and then.** The tool never fails silently: it says `NOT SIGNED IN: Google signed you@gmail.com out of Flow. Run "claude-image-gen login" and sign in as you@gmail.com` and exits with code `2`. With the Claude Code plugin, Claude runs `login` for you and asks you to sign in in the window that opens.
- **Each account must belong to someone 18 or older**, and Flow has to be offered in your country. If it isn't, the tool says so.
- **The tool never sees your password.** You type it into Google's own page. Each account gets its own private browser profile in `~/.claude-image-gen/accounts`, kept apart from your normal browser.

## What happens on your screen

Nothing. Everything except `login` runs in a **headless** browser, with no window and no tab. It uses **one** tab and closes the browser as soon as the command finishes, so nothing keeps running in the background. If two commands start at once (agents love doing that), the second waits its turn instead of fighting over the browser.

## Exit codes

Agents can branch on these.

| Code | Meaning |
|---|---|
| `0` | Saved. The paths are on stdout. |
| `1` | Something else went wrong. The message says what. |
| `2` | Not signed in. Run `claude-image-gen login`. |
| `3` | Another run held the browser for 15 minutes. |
| `4` | Out of Flow credits on every account. They refill daily; images still work. |
| `5` | Flow refused the prompt. The message quotes Flow. |
| `6` | Rate-limited on every account. Nothing was charged; wait and retry. |

Codes `2`, `4` and `6` only happen once every account has been tried.

## Troubleshooting

| You see | Do this |
|---|---|
| `NOT SIGNED IN` | `claude-image-gen login` |
| `RATE LIMITED: ... unusual activity` | Google's limit on many generations in a short time. Nothing was charged. Wait (it can take a few hours), or add another account with `login`. |
| `OUT OF CREDITS` | Wait for the daily refill, pick a cheaper video setting, or add another account. Images still work. |
| `Flow refused or failed: "..."` | Usually a content policy hit. Rephrase the prompt (no real people, logos or unsafe content). |
| `No Chromium-based browser found` | Install Chrome, Edge or Brave, or set `BROWSER_PATH` to one. |
| Google says the browser "may not be secure" while you sign in | Update the browser, or sign in with another one: `claude-image-gen login --browser edge`. |
| Anything else | Run the command again with `CIG_DEBUG=1`. It saves `claude-image-gen-debug.png`, a screenshot of what Flow showed. Attach it to an [issue](https://github.com/jonjoncheese/claude-image-gen/issues). |

<details>
<summary>Settings (environment variables)</summary>

| Variable | Default | What it does |
|---|---|---|
| `CIG_HOME` | `~/.claude-image-gen` | Where accounts and settings live |
| `CIG_TIMEOUT` | `240` images, `600` videos | Seconds to wait for one generation |
| `BROWSER_PATH` | auto | Use this browser executable |
| `CIG_DEBUG` | off | Save a screenshot when something fails |

</details>

## FAQ

**Is it really free?** The tool is, and it needs no API key. In Flow, images cost no credits on every model today. Videos spend Flow credits, which refill daily; paid Google AI plans get more of them.

**Does it remove watermarks?** No. For safety reasons we don't remove watermarks (we don't want to get into any trouble..). If you need that, check out [GeminiWatermarkTool](https://github.com/allenk/GeminiWatermarkTool), which is the tool we used. Google also embeds SynthID, an invisible watermark, in what Flow makes.

**Can it use Firefox or Safari?** No. It talks to the browser through the Chrome DevTools Protocol, which only Chromium-based browsers speak (Chrome, Edge, Brave, Chromium, Arc, Vivaldi). For one that isn't auto-detected, set `BROWSER_PATH`.

**Why not Playwright or Puppeteer?** Either would add a large download and a dependency tree. This is one file of plain Node.js that drives the browser you already have.

**Does it work on a server with no screen?** Yes, once it's signed in. `login` needs a window one time (remote desktop works); every other command runs headless.

**What about reference images and image-to-video?** Not yet. That's next on the list. PRs welcome.

## How it works

Flow has no public API, so the tool drives Flow's website the way you would. It starts your browser headless with a private profile, opens a Flow project it made for itself, picks the model and settings in Flow's settings menu, types the prompt and presses Create. Then it waits for the new tile and downloads it through Flow's own **Download > Original size**, so you get the full-quality file, not the preview. It talks to the browser over the Chrome DevTools Protocol using Node's built-in `fetch` and `WebSocket`, so there's nothing to install from npm.

Flow's page changes often. When it does, the tool stops with a clear message instead of saving the wrong thing: it checks the file type of every download and refuses anything that isn't the image or video it asked for.

## Contributing

Issues and pull requests are welcome. Flow's website changes without notice, so the most useful bug report is the command you ran, the error, and the `claude-image-gen-debug.png` that `CIG_DEBUG=1` saves. The whole tool is [one file](claude-image-gen.js) with no dependencies; `node --check claude-image-gen.js` is the build.

## Disclaimer

An independent project, not affiliated with, endorsed by or supported by Google or Anthropic. It automates the Flow website with your own account, so follow [Google's terms](https://policies.google.com/terms) and use it at your own risk.

## License

[MIT](LICENSE)
