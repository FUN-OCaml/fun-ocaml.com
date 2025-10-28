# Media Assets

This directory contains media assets used on the Fun OCaml 2025 website.

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

## Image Optimization

All web-facing images have been optimized for performance:

**Avatars Optimization (Oct 2025)**
- Resized from 1080x1080+ to 512x512px
- Quality: 85%
- Total size reduction: ~2.1MB (66% reduction)
- Display size: 192x192px (w-48 in Tailwind)

**Event Logos Optimization (Oct 2025)**
- Resized to appropriate dimensions for display
- Quality: 85%
- Maintained aspect ratios

## Using Original Assets

If you need to re-optimize or use the original high-resolution images:

1. Source files are in `*-original/` directories
2. Use ImageMagick or similar tools for optimization:
   ```bash
   convert input.jpg -resize 512x512^ -gravity center -extent 512x512 -quality 85 output.jpg
   ```
3. Place optimized images in the corresponding production directory

## Adding New Media

When adding new media assets:

1. Place original high-resolution files in `*-original/` directories
2. Create optimized versions for the production directories
3. Follow the sizing guidelines:
   - Avatars: 512x512px
   - Logos: Size appropriately for max display dimension (~600px max)
   - Event images: Based on layout requirements

## Contact

For questions about media assets, contact the organizing team.
