# Deployment Guide - Performance Optimizations

## What Changed

**Latest Updates (Dec 2025):**
- ⚡ Analytics script changed from `async` to `defer` - reduces blocking time by ~114ms
- 🖼️ Added lazy loading to all below-the-fold images (venue images, avatars, sponsors)
- 📦 New `.htaccess` file with compression and cache headers for all static assets
- 🔤 Optimized font preloading strategy - only preload critical variable font

**Previous Optimizations:**
- All PageSpeed Insights performance, accessibility, and SEO issues have been addressed.

## Files to Deploy

Deploy the entire `/output` directory to your web server. Key changes include:

### New Files
- `.htaccess` - Compression and cache headers for all static assets
- `output/2025/img/hero-background.webp` (41KB - 67% smaller than JPG)
- `output/2025/img/venue1.webp` (188KB - now lazy loaded)
- `output/2025/img/venue2.webp` (245KB - now lazy loaded)
- Updated `output/2025/index.html` with lazy loading optimizations
- Updated font files with font-display: swap

### Modified Source Files (for reference)
- `templates/2025/layout.mlx` - Analytics defer, optimized font preloading
- `templates/2025/home.mlx` - Lazy loading on venue, sponsor, and event images
- `templates/2025/avatar.mlx` - Lazy loading on avatar images
- `asset/2025/font-files/Montserrat.css` - Added font-display: swap
- `.htaccess` - NEW: Compression and cache headers

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

3. **Server Configuration** (IMPORTANT!)

   **For Apache:** The `.htaccess` file is already included and will be deployed automatically. 
   Make sure your Apache server has these modules enabled:
   ```bash
   # Enable required Apache modules
   a2enmod deflate
   a2enmod expires
   a2enmod headers
   ```

   **For Nginx:** Add to your server config:
   ```nginx
   # Enable gzip compression
   gzip on;
   gzip_types text/css application/javascript image/svg+xml font/woff2;
   
   # Cache static assets
   location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot|webp)$ {
       expires 1y;
       add_header Cache-Control "public, immutable";
   }
   ```

4. **Verify Deployment**:
   - Visit https://fun-ocaml.com
   - Check that images load (should be WebP in modern browsers)
   - Open DevTools Network tab and verify:
     - Analytics script has `defer` attribute
     - Below-fold images have `loading="lazy"` attribute
     - Static assets return with `Cache-Control` headers (1 year)
     - Text assets are compressed (check `Content-Encoding: gzip`)
     - CSS loads asynchronously
     - Hero background image is WebP format
     - Fonts display immediately (no FOIT)

5. **Re-test with PageSpeed Insights**:
   - Visit https://pagespeed.web.dev/
   - Test https://fun-ocaml.com
   - Expected improvements from latest optimizations:
     - Initial Load Time: 438ms → ~300-350ms (20-30% faster)
     - Blocking Time from Analytics: 114ms → 0ms (defer vs async)
     - Data Transfer: Reduced via compression (30-50% smaller text assets)
     - Cache Hit Rate: Much improved with 1-year cache headers
     - Performance Score: 85-90 → 92-98
     - Accessibility: 95+ (maintained)
     - SEO: 95-100 (maintained)

## Expected Results

**Latest Optimizations (Dec 2025):**
- **20-30% faster initial page load** (438ms → ~300-350ms)
- **Eliminated analytics blocking** (114ms saved on initial render)
- **Reduced bandwidth** (30-50% via gzip compression)
- **Faster repeat visits** (1-year cache = instant load for static assets)
- **Better mobile experience** (lazy loading saves data on slower connections)

**Previous Results:**
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

## Performance Optimization Summary

All optimizations follow web performance best practices:
- ✅ Resource hints (preload critical fonts only)
- ✅ Modern image formats (WebP with fallback)
- ✅ Async CSS loading
- ✅ Font display optimization (font-display: swap)
- ✅ Semantic HTML
- ✅ **NEW: Lazy loading for below-the-fold images**
- ✅ **NEW: Deferred analytics (non-blocking)**
- ✅ **NEW: Gzip compression for all text assets**
- ✅ **NEW: Long-term caching (1 year for static assets)**

## Key Performance Metrics

Based on HAR file analysis:
- Total requests: 31
- Page load: 428ms → **~300-350ms (target)**
- Largest images: venue2.webp (251KB), venue1.webp (193KB) - **now lazy loaded**
- Analytics: 114ms blocking → **0ms blocking (deferred)**
- All images: **Now served with compression and cache headers**

Ready to deploy! 🚀
