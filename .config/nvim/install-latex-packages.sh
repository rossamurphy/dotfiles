#!/usr/bin/env bash

# Install essential LaTeX packages for ML/AI research
# Run this with: sudo bash install-latex-packages.sh

echo "Installing LaTeX packages for ML/AI research..."
echo "==============================================="

# Core math packages
echo "Installing core math packages..."
sudo tlmgr install \
    physics \
    amsmath \
    amssymb \
    amsthm \
    mathtools \
    bm \
    bbm-macros \
    dsfont \
    mathrsfs \
    cases

# Algorithm packages
echo "Installing algorithm packages..."
sudo tlmgr install \
    algorithm2e \
    algorithms \
    algorithmicx

# Graphics and figures
echo "Installing graphics packages..."
sudo tlmgr install \
    tikz \
    pgfplots \
    xcolor \
    graphicx

# Tables and formatting
echo "Installing table packages..."
sudo tlmgr install \
    booktabs \
    multirow \
    array \
    tabularx

# Units and SI
echo "Installing units package..."
sudo tlmgr install siunitx

# Code listings
echo "Installing code listing packages..."
sudo tlmgr install listings

# Captions and subcaptions
echo "Installing caption packages..."
sudo tlmgr install \
    caption \
    subcaption

# Bibliography
echo "Installing bibliography packages..."
sudo tlmgr install \
    natbib \
    biblatex \
    biber

# Cross-references and hyperlinks
echo "Installing hyperref packages..."
sudo tlmgr install \
    hyperref \
    cleveref \
    url

# Lists and enumerations
echo "Installing enumeration packages..."
sudo tlmgr install enumitem

# Additional useful packages
echo "Installing additional packages..."
sudo tlmgr install \
    geometry \
    fancyhdr \
    setspace \
    lipsum \
    xspace \
    ifthen \
    etoolbox

# Machine Learning specific
echo "Installing ML-specific packages..."
sudo tlmgr install \
    neuralnetwork \
    tikz-network

echo ""
echo "================================"
echo "Installation Complete!"
echo "================================"
echo ""
echo "Installed packages include:"
echo "- Math: physics, amsmath, mathtools, bm, dsfont"
echo "- Algorithms: algorithm2e, algorithms, algorithmicx"
echo "- Graphics: tikz, pgfplots"
echo "- Tables: booktabs, multirow"
echo "- Code: listings"
echo "- Bibliography: natbib, biblatex"
echo "- And many more..."
echo ""
