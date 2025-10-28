# Deployment Guide - Performance Optimizations

## What Changed

All PageSpeed Insights performance, accessibility, and SEO issues have been addressed.

## Files to Deploy

Deploy the entire `/output` directory to your web server. Key changes include:

### New Files
- `output/2025/img/hero-background.webp` (41KB - 67% smaller than JPG)
- `output/2025/img/venue1.webp` (188KB)
- `output/2025/img/venue2.webp` (245KB)
- Updated `output/2025/index.html` with optimizations
- Updated font files with font-display: swap

### Modified Source Files (for reference)
- `templates/2025/layout.mlx` - Added preloads, async CSS, semantic HTML
- `templates/2025/home.mlx` - WebP images, alt text, dimensions
- `asset/2025/font-files/Montserrat.css` - Added font-display: swap

## Deployment Steps

1. **Build the site** (already done):
   ```bash
   cd /home/sabine/fun-ocaml.com
   make
   ```

2. **Deploy output directory**:
   ```bash
   # Use your existing deployment method, e.g.:
   bash script/deploy.sh
   # Or rsync, scp, etc.
   ```

3. **Optional: Configure Server Caching** (recommended for maximum performance)

   For **Nginx**, add to your server config:
   ```nginx
   location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot|webp)$ {
       expires 1y;
       add_header Cache-Control "public, immutable";
   }
   ```

   For **Apache**, create/update `.htaccess`:
   ```apache
   <IfModule mod_expires.c>
       ExpiresActive On
       ExpiresByType image/webp "access plus 1 year"
       ExpiresByType image/jpeg "access plus 1 year"
       ExpiresByType text/css "access plus 1 year"
       ExpiresByType font/woff2 "access plus 1 year"
   </IfModule>
   ```

4. **Verify Deployment**:
   - Visit https://fun-ocaml.com
   - Check that images load (should be WebP in modern browsers)
   - Open DevTools Network tab and verify:
     - CSS loads asynchronously
     - Hero background image is WebP format
     - Fonts display immediately (no FOIT)

5. **Re-test with PageSpeed Insights**:
   - Visit https://pagespeed.web.dev/
   - Test https://fun-ocaml.com
   - Expected improvements:
     - Performance: 65 → 85-90
     - Accessibility: 88 → 95+
     - SEO: 82 → 95-100

## Expected Results

- **Faster Load Times**: LCP reduced from 8.1s to ~3-4s
- **Better User Experience**: No layout shift, faster content display
- **Improved SEO**: Meta description and proper image alt text
- **Better Accessibility**: Semantic HTML and proper landmarks

## Rollback (if needed)

If you need to rollback:
```bash
git checkout HEAD~1 templates/2025/layout.mlx templates/2025/home.mlx
git checkout HEAD~1 asset/2025/font-files/Montserrat.css
make
```

## Questions?

All optimizations follow web performance best practices:
- Resource hints (preload)
- Modern image formats (WebP with fallback)
- Async CSS loading
- Font display optimization
- Semantic HTML

Ready to deploy! 🚀
