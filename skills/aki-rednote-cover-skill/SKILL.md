---
name: aki-rednote-cover-skill
description: Create or iterate minimalist 3:4 Xiaohongshu knowledge and tool-note covers using the fixed personal IP system “城下秋草”. Apply when designing a specific note cover, cover prompt, or cover variation; do not use for general posters, banners, or unrelated branding.
---

# aki-rednote-cover-skill

## Session convention

This conversation is the dedicated cover-generation session for the user. Treat the rules below as the current visual system and continue refining them here when the user explicitly proposes an iteration. A new cover request should inherit the established system unless the user clearly asks to change it. Do not silently create a second visual direction.

## Fixed visual system

- Canvas: 3:4 vertical format. Design for the thumbnail first, then check the full-size composition.
- Base: pure grass green as the dominant background; black is the primary text color.
- IP mark: always retain the personal IP text “城下秋草” as a small, consistent identifier.
- Composition: keep the font family, type scale, alignment, margins, and placement stable across covers. If any of these have not yet been explicitly fixed, choose one restrained specification for the current series and reuse it in later covers unless the user approves a change.
- Anchor: reserve a minimal small grass motif in the lower-right corner as a recurring visual anchor. It should support recognition, not become an illustration.

## Content rules

1. One cover communicates one core topic. Extract the shortest accurate title from the note and remove secondary claims, subtitles, and decorative copy.
2. Keep the information hierarchy to: IP mark → large title → optional extremely short scope hint. The title must remain readable at thumbnail size.
3. For concrete tools or workflows, a very light contextual cue is allowed—such as terminal symbols, a MacBook outline, or one device element—but it must never compete with the title or turn the cover into a product collage.
4. Avoid banner-like layouts, dense decoration, gradients or ornamental clutter, multiple logos, fake UI screenshots, and marketing slogans such as “必看”, “保姆级”, or exaggerated promises.
5. Do not add tools, features, results, or claims that are absent from the note merely to make the cover look richer.

## Generation workflow

When the user provides a specific note:

- Identify the single subject and reduce it to a compact title suitable for a thumbnail.
- Preserve the fixed visual system and decide whether a single restrained scene cue is genuinely useful.
- Generate the cover or a production-ready image prompt with explicit 3:4 layout, text hierarchy, colors, placement, and negative constraints.
- Inspect the result at thumbnail scale: title legibility, hierarchy, empty space, IP recognition, grass-anchor visibility, and absence of competing marks.
- If text rendering is unreliable, prefer a clean composition with reserved text areas and report that text may need to be typeset afterward; never compensate with extra decoration.

If the core topic is missing, ask only for the note topic or a one-line title. Do not ask the user to restate the fixed style system.

## Iteration protocol

When revising a cover, change only the requested variable where possible. Keep the background, IP mark, typography system, layout, and lower-right grass anchor unchanged unless the user explicitly requests a system-level revision. Record any accepted change as part of the new working baseline for this dedicated session.

## Output expectations

For an image request, return the generated cover and briefly state the chosen core title. For a prompt-only request, provide one concise prompt that can be used to generate the cover, followed by a short negative prompt if useful. Do not provide several competing styles unless the user asks for alternatives.
