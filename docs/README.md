# Edge-AI-APP Documentation Site

This directory contains the static documentation and project site for Edge-AI-APP, hosted on GitHub Pages.

## Overview

The documentation site provides comprehensive information about the Edge-AI-APP project, including:

- **Landing Page** (`index.html`): Project overview, architecture, and features
- **Windows Setup Guide** (`setup.html`): Step-by-step PowerShell instructions for installation
- **Releases & Downloads** (`releases.html`): Latest releases and binary downloads
- **Repository Structure** (`structure.html`): Project organization and technology stack

## Technical Stack

- **Static HTML/CSS/JavaScript**: No build tools or server-side processing required
- **GitHub Pages**: Hosted directly from this repository
- **GitHub API Integration**: Dynamic content loading for releases and workflow status
- **Responsive Design**: Mobile-first approach with Tailwind-inspired styling
- **Blueprint Aesthetic**: Technical, mathematical design with grid backgrounds and geometric shapes

## Design Philosophy

The site uses a clean, technical aesthetic inspired by mathematical blueprints:

- **Background**: White with fine grid pattern
- **Colors**: Black headlines with pastel cyan and soft pink accents
- **Typography**: Bold, massive sans-serif headlines contrasted with delicate monospaced labels
- **Shapes**: Wireframe-style geometric diagrams for visual interest

## File Structure

```
docs/
├── index.html              # Landing page
├── setup.html              # Windows setup guide
├── releases.html           # Releases and downloads
├── structure.html          # Repository structure explorer
├── robots.txt              # Search engine directives
├── sitemap.xml             # XML sitemap for SEO
├── .nojekyll               # Disable Jekyll processing
├── assets/
│   ├── css/
│   │   └── styles.css      # Main stylesheet
│   └── js/
│       └── main.js         # JavaScript functionality
└── README.md               # This file
```

## Features

### Dynamic Content

The site loads dynamic content from GitHub APIs:

- **Releases**: Fetches latest releases from GitHub
- **Workflow Status**: Displays CI/CD pipeline status
- **Repository Stats**: Shows stars, forks, and issues count

### Copy-to-Clipboard

PowerShell command snippets include copy-to-clipboard functionality for easy setup.

### Responsive Design

The site is fully responsive and works on:

- Desktop browsers (Chrome, Firefox, Safari, Edge)
- Tablets and mobile devices
- Windows PowerShell (for setup instructions)

## Deployment

The site is automatically deployed to GitHub Pages when changes are pushed to the `main` branch via the `deploy-docs.yml` GitHub Actions workflow.

### Manual Deployment

To manually test the site locally:

1. Open `docs/index.html` in a web browser
2. Or use a local web server:
   ```bash
   cd docs
   python -m http.server 8000
   # Visit http://localhost:8000
   ```

## Customization

### Colors

Edit the CSS variables in `assets/css/styles.css`:

```css
:root {
  --primary-black: #000000;
  --accent-cyan: #00d9ff;
  --accent-pink: #ff69b4;
  /* ... more colors ... */
}
```

### Content

Edit the HTML files directly:

- `index.html` - Landing page content
- `setup.html` - Setup guide content
- `releases.html` - Releases page content
- `structure.html` - Repository structure content

### Styling

Modify `assets/css/styles.css` to change:

- Layout and spacing
- Typography and fonts
- Colors and gradients
- Animations and transitions

## GitHub Pages Configuration

The site is configured to use GitHub Pages with:

- **Source**: `docs/` directory on `main` branch
- **URL**: `https://alexandrepedrosaai.github.io/Edge-AI-APP/`
- **Custom Domain**: Not configured (can be added in repository settings)

## SEO

The site includes SEO optimization:

- `robots.txt` - Search engine directives
- `sitemap.xml` - XML sitemap for crawlers
- Meta tags - Open Graph and Twitter Card support
- Semantic HTML - Proper heading hierarchy and structure

## Performance

The site is optimized for performance:

- No external dependencies (except GitHub API)
- Minimal CSS and JavaScript
- Responsive images and assets
- Fast page load times
- Caching-friendly structure

## Accessibility

The site follows WCAG 2.1 AA accessibility guidelines:

- Semantic HTML structure
- Proper heading hierarchy
- Color contrast compliance
- Keyboard navigation support
- ARIA labels where needed

## Browser Support

- Chrome/Edge 90+
- Firefox 88+
- Safari 14+
- Mobile browsers (iOS Safari, Chrome Mobile)

## Contributing

To contribute to the documentation site:

1. Fork the repository
2. Create a feature branch
3. Make your changes to the HTML, CSS, or JavaScript
4. Test locally in a web browser
5. Submit a pull request

## License

The documentation site is part of the Edge-AI-APP project and follows the same license.

## Support

For issues or suggestions about the documentation site:

1. Open an issue on GitHub
2. Join the community discussions
3. Contact the project maintainers

---

**Last Updated**: April 11, 2026
**Maintained By**: Alexandre Pedrosa
