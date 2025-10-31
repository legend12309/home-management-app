#!/bin/bash

echo "============================================================"
echo "Uploading Gharsethu to GitHub"
echo "============================================================"
echo ""

# Check if Git is installed
if ! command -v git &> /dev/null
then
    echo "ERROR: Git is not installed!"
    echo ""
    echo "Please install Git from: https://git-scm.com/downloads"
    echo "OR use GitHub Desktop: https://desktop.github.com/"
    echo ""
    echo "See UPLOAD_TO_GITHUB.md for detailed instructions"
    exit 1
fi

echo "Git is installed!"
echo ""

# Initialize Git repository
echo "[1/6] Initializing Git repository..."
git init
echo ""

# Add all files
echo "[2/6] Adding all files to Git..."
git add .
echo ""

# Create initial commit
echo "[3/6] Creating initial commit..."
git commit -m "Initial commit: Complete Gharsethu full-stack home management app

- Flutter frontend with 6 feature modules
- Node.js backend API
- Firebase integration
- Complete authentication flow
- Family management system
- Groceries, Meals, Chores, Budget, Festivals
- Beautiful Material Design 3 UI
- Production-ready architecture"
echo ""

# Set default branch to main
echo "[4/6] Setting main branch..."
git branch -M main
echo ""

# Add remote repository
echo "[5/6] Adding GitHub remote..."
git remote add origin https://github.com/legend12309/home-management-app.git
echo ""

# Push to GitHub
echo "[6/6] Pushing to GitHub..."
echo ""
echo "NOTE: You may be prompted for your GitHub credentials"
echo ""
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "============================================================"
    echo "SUCCESS! Your code is now on GitHub!"
    echo "============================================================"
    echo ""
    echo "Visit: https://github.com/legend12309/home-management-app"
    echo ""
else
    echo ""
    echo "============================================================"
    echo "PUSH FAILED"
    echo "============================================================"
    echo ""
    echo "Common reasons:"
    echo "1. Authentication failed - Use Personal Access Token"
    echo "2. Repository not empty - Pull first with: git pull --allow-unrelated-histories"
    echo "3. Network issue - Check your internet connection"
    echo ""
    echo "See UPLOAD_TO_GITHUB.md for troubleshooting"
fi

