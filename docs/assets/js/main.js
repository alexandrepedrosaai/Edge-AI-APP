// Main JavaScript for Edge-AI-APP Documentation Site

// Set active navigation link based on current page
function setActiveNav() {
  const currentPage = window.location.pathname.split('/').pop() || 'index.html';
  const navLinks = document.querySelectorAll('nav a');
  
  navLinks.forEach(link => {
    const href = link.getAttribute('href');
    if (href === currentPage || (currentPage === '' && href === 'index.html')) {
      link.classList.add('active');
    } else {
      link.classList.remove('active');
    }
  });
}

// Copy to clipboard functionality
function setupCopyButtons() {
  const copyButtons = document.querySelectorAll('.copy-btn');
  
  copyButtons.forEach(btn => {
    btn.addEventListener('click', function() {
      const snippet = this.parentElement.querySelector('code');
      const text = snippet.innerText;
      
      navigator.clipboard.writeText(text).then(() => {
        const originalText = this.innerText;
        this.innerText = 'Copied!';
        this.classList.add('copied');
        
        setTimeout(() => {
          this.innerText = originalText;
          this.classList.remove('copied');
        }, 2000);
      }).catch(err => {
        console.error('Failed to copy:', err);
        alert('Failed to copy to clipboard');
      });
    });
  });
}

// Fetch GitHub releases
async function fetchReleases() {
  const releasesContainer = document.getElementById('releases-container');
  if (!releasesContainer) return;
  
  try {
    releasesContainer.innerHTML = '<div class="spinner"></div> Loading releases...';
    
    const response = await fetch('https://api.github.com/repos/alexandrepedrosaai/Edge-AI-APP/releases');
    if (!response.ok) throw new Error('Failed to fetch releases');
    
    const releases = await response.json();
    
    if (releases.length === 0) {
      releasesContainer.innerHTML = '<p>No releases found yet.</p>';
      return;
    }
    
    releasesContainer.innerHTML = '';
    
    releases.forEach(release => {
      const releaseCard = createReleaseCard(release);
      releasesContainer.appendChild(releaseCard);
    });
  } catch (error) {
    console.error('Error fetching releases:', error);
    releasesContainer.innerHTML = '<p>Failed to load releases. Please try again later.</p>';
  }
}

// Create release card element
function createReleaseCard(release) {
  const card = document.createElement('div');
  card.className = 'release-card fade-in';
  
  const releaseDate = new Date(release.published_at).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  });
  
  const badge = release.prerelease ? 'Pre-release' : (release.draft ? 'Draft' : 'Latest');
  const badgeClass = release.prerelease ? 'badge-pink' : (release.draft ? 'badge' : 'badge-dark');
  
  let downloadsHTML = '';
  if (release.assets && release.assets.length > 0) {
    downloadsHTML = '<div class="release-downloads">';
    release.assets.forEach(asset => {
      const size = (asset.size / (1024 * 1024)).toFixed(2);
      downloadsHTML += `
        <a href="${asset.browser_download_url}" class="download-link" download>
          📥 ${asset.name} (${size}MB)
        </a>
      `;
    });
    downloadsHTML += '</div>';
  }
  
  card.innerHTML = `
    <div class="release-header">
      <div>
        <div class="release-version">${release.tag_name}</div>
        <div class="release-date">${releaseDate}</div>
      </div>
      <span class="release-badge ${badgeClass}">${badge}</span>
    </div>
    <p>${release.body || 'No description provided.'}</p>
    ${downloadsHTML}
  `;
  
  return card;
}

// Fetch GitHub Actions workflow status
async function fetchWorkflowStatus() {
  const statusContainer = document.getElementById('workflow-status');
  if (!statusContainer) return;
  
  try {
    const response = await fetch('https://api.github.com/repos/alexandrepedrosaai/Edge-AI-APP/actions/runs?per_page=10');
    if (!response.ok) throw new Error('Failed to fetch workflow status');
    
    const data = await response.json();
    const runs = data.workflow_runs || [];
    
    if (runs.length === 0) {
      statusContainer.innerHTML = '<p>No workflow runs found.</p>';
      return;
    }
    
    let statusHTML = '<div class="grid grid-3">';
    
    runs.slice(0, 6).forEach(run => {
      const status = run.status === 'completed' ? run.conclusion : run.status;
      const statusIcon = status === 'success' ? '✓' : (status === 'failure' ? '✗' : '⟳');
      const statusColor = status === 'success' ? 'var(--accent-cyan)' : (status === 'failure' ? 'var(--accent-pink)' : 'var(--text-light)');
      
      const runDate = new Date(run.created_at).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
      });
      
      statusHTML += `
        <div class="card">
          <div style="color: ${statusColor}; font-size: 1.5rem; margin-bottom: 0.5rem;">${statusIcon}</div>
          <div class="card-title">${run.name}</div>
          <div class="card-description">${runDate}</div>
          <div class="card-description" style="font-size: 0.85rem; margin-top: 0.5rem;">
            <a href="${run.html_url}" target="_blank">View Run →</a>
          </div>
        </div>
      `;
    });
    
    statusHTML += '</div>';
    statusContainer.innerHTML = statusHTML;
  } catch (error) {
    console.error('Error fetching workflow status:', error);
    statusContainer.innerHTML = '<p>Failed to load workflow status.</p>';
  }
}

// Fetch repository information
async function fetchRepoInfo() {
  const repoContainer = document.getElementById('repo-info');
  if (!repoContainer) return;
  
  try {
    const response = await fetch('https://api.github.com/repos/alexandrepedrosaai/Edge-AI-APP');
    if (!response.ok) throw new Error('Failed to fetch repo info');
    
    const repo = await response.json();
    
    const stats = `
      <div class="grid grid-4">
        <div class="card">
          <div class="card-title">⭐ Stars</div>
          <div style="font-size: 2rem; font-weight: 700; color: var(--accent-cyan);">${repo.stargazers_count}</div>
        </div>
        <div class="card">
          <div class="card-title">🍴 Forks</div>
          <div style="font-size: 2rem; font-weight: 700; color: var(--accent-pink);">${repo.forks_count}</div>
        </div>
        <div class="card">
          <div class="card-title">👁️ Watchers</div>
          <div style="font-size: 2rem; font-weight: 700; color: var(--accent-cyan);">${repo.watchers_count}</div>
        </div>
        <div class="card">
          <div class="card-title">📝 Issues</div>
          <div style="font-size: 2rem; font-weight: 700; color: var(--accent-pink);">${repo.open_issues_count}</div>
        </div>
      </div>
    `;
    
    repoContainer.innerHTML = stats;
  } catch (error) {
    console.error('Error fetching repo info:', error);
  }
}

// Smooth scroll to section
function smoothScroll(target) {
  const element = document.querySelector(target);
  if (element) {
    element.scrollIntoView({ behavior: 'smooth' });
  }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
  setActiveNav();
  setupCopyButtons();
  fetchReleases();
  fetchWorkflowStatus();
  fetchRepoInfo();
});

// Reload releases every 5 minutes
setInterval(fetchReleases, 5 * 60 * 1000);
setInterval(fetchWorkflowStatus, 5 * 60 * 1000);
