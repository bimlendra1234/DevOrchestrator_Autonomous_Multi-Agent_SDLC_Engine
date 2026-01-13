// DOM Elements - Initialize safely
let projectForm, promptTextarea, recursionLimitInput, outputPanel, outputContent;
let statusBadge, miniSpinner, examplesGrid, filesPanel, fileTree;
let fileViewer, fileContent, currentFile, successActions, projectModal;
let projectFrame, projectInfo;

// API Configuration
const API_BASE = '/api';
const WS_URL = `${window.location.protocol === 'https:' ? 'wss:' : 'ws:'}//${window.location.host}/ws/generate`;

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    // Get DOM elements
    projectForm = document.getElementById('projectForm');
    promptTextarea = document.getElementById('prompt');
    recursionLimitInput = document.getElementById('recursionLimit');
    outputPanel = document.getElementById('outputPanel');
    outputContent = document.getElementById('outputContent');
    statusBadge = document.getElementById('statusBadge');
    miniSpinner = document.getElementById('miniSpinner');
    examplesGrid = document.getElementById('examplesGrid');
    filesPanel = document.getElementById('filesPanel');
    fileTree = document.getElementById('fileTree');
    fileViewer = document.getElementById('fileViewer');
    fileContent = document.getElementById('fileContent');
    currentFile = document.getElementById('currentFile');
    successActions = document.getElementById('successActions');
    projectModal = document.getElementById('projectModal');
    projectFrame = document.getElementById('projectFrame');
    projectInfo = document.getElementById('projectInfo');
    
    // Setup listeners and load examples
    setupEventListeners();
    loadExamples();
});

function setupEventListeners() {
    projectForm.addEventListener('submit', handleProjectSubmit);
}

async function handleProjectSubmit(e) {
    e.preventDefault();
    
    const prompt = promptTextarea.value.trim();
    const recursionLimit = parseInt(recursionLimitInput.value) || 100;
    
    if (!prompt) {
        showOutput('Please enter a project description', 'error');
        return;
    }
    
    try {
        await generateProject(prompt, recursionLimit);
    } catch (error) {
        showOutput(`Error: ${error.message}`, 'error');
    }
}

async function generateProject(prompt, recursionLimit) {
    showLoading(true);
    updateStatus('generating', 'Generating...');
    clearOutput();
    
    try {
        // Use WebSocket for real-time updates
        const ws = new WebSocket(WS_URL);
        let completionTimeout;
        
        ws.onopen = () => {
            showOutput('🚀 Starting project generation...', 'info');
            ws.send(JSON.stringify({
                prompt: prompt,
                recursion_limit: recursionLimit
            }));
        };
        
        ws.onmessage = (event) => {
            const data = JSON.parse(event.data);
            
            switch (data.type) {
                case 'progress':
                    showOutput(`📍 ${data.message}`, 'info');
                    break;
                case 'complete':
                    showOutput(`✅ ${data.message}`, 'success');
                    updateStatus('success', 'Success');
                    loadGeneratedFiles();  // Load files after generation
                    showSuccessActions();  // Show View Project button
                    
                    // Hide spinner and close WebSocket
                    showLoading(false);
                    ws.close();
                    
                    // Show success message
                    showOutput('🎉 Project is ready! View files below.', 'success');
                    break;
                case 'error':
                    showOutput(`❌ ${data.message}`, 'error');
                    updateStatus('error', 'Error');
                    showLoading(false);
                    ws.close();
                    break;
            }
        };
        
        ws.onerror = (error) => {
            showOutput(`Connection error: ${error}`, 'error');
            updateStatus('error', 'Error');
            showLoading(false);
            ws.close();
        };
        
        ws.onclose = () => {
            showLoading(false);
        };
        
    } catch (error) {
        showLoading(false);
        showOutput(`Error: ${error.message}`, 'error');
        updateStatus('error', 'Error');
    }
}

function showOutput(message, type = 'info') {
    const messageEl = document.createElement('div');
    messageEl.className = `output-message ${type}`;
    messageEl.textContent = message;
    outputContent.appendChild(messageEl);
    outputContent.scrollTop = outputContent.scrollHeight;
}

function clearOutput() {
    outputContent.innerHTML = '<div class="empty-state"><i class="fas fa-inbox"></i><p>Generation output...</p></div>';
    statusBadge.textContent = 'Generating...';
    statusBadge.className = 'badge badge-warning';
    filesPanel.classList.add('hidden');
    hideSuccessActions();  // Hide View Project button
}

function updateStatus(status, text) {
    statusBadge.textContent = text;
    statusBadge.className = `badge badge-${status === 'success' ? 'success' : status === 'error' ? 'error' : 'default'}`;
}

function showLoading(show) {
    if (!miniSpinner) return;
    
    if (show) {
        // Show the mini spinner
        miniSpinner.classList.remove('hidden');
    } else {
        // Hide the mini spinner
        miniSpinner.classList.add('hidden');
    }
}

function useExample(examplePrompt) {
    promptTextarea.value = examplePrompt;
    promptTextarea.focus();
}

async function loadGeneratedFiles() {
    try {
        const response = await fetch(`${API_BASE}/generated-files`);
        const data = await response.json();
        
        if (data.files && data.files.length > 0) {
            // Show files panel
            filesPanel.classList.remove('hidden');
            
            // Load file tree
            loadFileTree();
            
            // Show first file
            if (data.files.length > 0) {
                viewFile(data.files[0].path);
            }
        } else {
            filesPanel.classList.add('hidden');
        }
    } catch (error) {
        console.error('Error loading files:', error);
    }
}

async function loadFileTree() {
    try {
        const response = await fetch(`${API_BASE}/file-tree`);
        const data = await response.json();
        
        if (data.tree) {
            renderFileTree(data.tree, '');
        }
    } catch (error) {
        console.error('Error loading file tree:', error);
    }
}

function renderFileTree(tree, prefix) {
    const container = fileTree;
    container.innerHTML = '';
    
    function renderItem(obj, currentPrefix = '') {
        const ul = document.createElement('ul');
        ul.className = 'file-tree-list';
        
        for (const [name, value] of Object.entries(obj)) {
            const li = document.createElement('li');
            
            if (value.type === 'file') {
                li.innerHTML = `<i class="fas fa-file"></i> <span class="file-item" onclick="viewFile('${currentPrefix}${name}')">${name}</span>`;
            } else {
                li.innerHTML = `<i class="fas fa-folder"></i> <strong>${name}</strong>`;
                li.appendChild(renderItem(value, currentPrefix + name + '/'));
            }
            ul.appendChild(li);
        }
        return ul;
    }
    
    container.appendChild(renderItem(tree));
}

async function viewFile(filePath) {
    try {
        const response = await fetch(`${API_BASE}/file-content/${filePath}`);
        const data = await response.json();
        
        if (data.status === 'success') {
            currentFile.textContent = data.path;
            fileContent.textContent = data.content;
            
            // Syntax highlighting (basic)
            highlightSyntax();
        }
    } catch (error) {
        console.error('Error loading file:', error);
        fileContent.textContent = 'Error loading file';
    }
}

function highlightSyntax() {
    // Basic syntax highlighting
    const ext = currentFile.textContent.split('.').pop().toLowerCase();
    fileContent.classList.remove('language-python', 'language-javascript', 'language-html', 'language-css');
    
    if (['py'].includes(ext)) {
        fileContent.classList.add('language-python');
    } else if (['js'].includes(ext)) {
        fileContent.classList.add('language-javascript');
    } else if (['html'].includes(ext)) {
        fileContent.classList.add('language-html');
    } else if (['css'].includes(ext)) {
        fileContent.classList.add('language-css');
    }
}

function toggleFileTree() {
    fileTree.classList.toggle('hidden');
}

function closeFileViewer() {
    filesPanel.classList.add('hidden');
}

async function loadExamples() {
    try {
        const response = await fetch(`${API_BASE}/examples`);
        const data = await response.json();
        
        if (data.examples && data.examples.length > 0) {
            examplesGrid.innerHTML = data.examples.map(example => `
                <div class="example-card" onclick="useExample('${example.prompt.replace(/'/g, "\\'")}')">
                    <div class="example-image">
                        <span>${getEmojiForExample(example.title)}</span>
                    </div>
                    <div class="example-content">
                        <h3>${example.title}</h3>
                        <p>${example.description}</p>
                        <button type="button" class="btn btn-primary" onclick="event.stopPropagation(); useExample('${example.prompt.replace(/'/g, "\\'")}'); scrollToGenerator();">
                            <i class="fas fa-arrow-right"></i> Try It
                        </button>
                    </div>
                </div>
            `).join('');
        }
    } catch (error) {
        console.error('Error loading examples:', error);
    }
}

function getEmojiForExample(title) {
    const emojiMap = {
        'Todo': '📝',
        'Calculator': '🧮',
        'Weather': '⛅',
        'Chat': '💬',
        'Snake': '🐍',
        'Game': '🎮'
    };
    
    for (const [key, emoji] of Object.entries(emojiMap)) {
        if (title.includes(key)) return emoji;
    }
    return '✨';
}

function scrollToGenerator() {
    document.getElementById('generator').scrollIntoView({ behavior: 'smooth' });
}

function learnMore() {
    document.getElementById('features').scrollIntoView({ behavior: 'smooth' });
}

// Copy to clipboard utility
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
        alert('Copied to clipboard!');
    });
}

// View generated project in modal
async function viewGeneratedProject() {
    try {
        // Open the project viewer in a new window/tab for better experience
        window.open('/project-viewer', 'project-preview', 'width=1200,height=800,resizable=yes,scrollbars=yes');
    } catch (error) {
        console.error('Error opening project:', error);
        showOutput(`Error: Could not open project preview - ${error.message}`, 'error');
    }
}

// Show success actions button
function showSuccessActions() {
    if (successActions) {
        successActions.classList.remove('hidden');
    }
}

// Hide success actions button
function hideSuccessActions() {
    if (successActions) {
        successActions.classList.add('hidden');
    }
}

// Add some visual feedback for form interactions
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('input, textarea').forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.style.borderColor = 'var(--primary-color)';
        });
        
        input.addEventListener('blur', function() {
            this.parentElement.style.borderColor = 'var(--border-color)';
        });
    });
});

console.log('DevOrchestrator UI loaded successfully!');
