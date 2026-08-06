# Media Assets

This directory contains media assets used on the Fun OCaml 2027 website.

## Directory Structure

### `avatars/`
Optimized avatar images for speakers, organizers, and participants. These images are:
- Resized to 512x512px (optimal for web display at 192px)
- Compressed with 85% quality
- Ready for production use

### `avatars-original/`
Original, unoptimized avatar images as provided by contributors. These are:
- High-resolution source files (typically 1080x1080px or larger)
- Preserved for archival purposes and future re-optimization
- NOT used directly on the website

### `sponsors/`
Sponsor and partner logos. Mostly vector (SVG) files, already optimized.

### `recommended-events/`
Optimized logos for recommended events.

### `recommended-events-original/`
Original, unoptimized event logos for archival purposes.

### `slides/`
PDF and presentation files from talks and workshops.

## Adding New Media

When adding new media assets:

1. Place original high-resolution files in `*-original/` directories
2. Create optimized versions for the production directories
3. Follow the sizing guidelines:
   - Avatars: 512x512px
   - Logos: Size appropriately for max display dimension (~600px max)
   - Event images: Based on layout requirements
