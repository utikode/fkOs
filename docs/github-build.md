# Using GitHub Actions for fkOs Build

Since local WSL is slow, you can build fkOs on GitHub's free runners.

## Steps:

1. Create a new repository on GitHub (e.g., `fkOs`)
2. Push this folder to GitHub:
   ```
   git init
   git add .
   git commit -m "Initial fkOs skeleton"
   git remote add origin https://github.com/YOUR_USERNAME/fkOs.git
   git push -u origin main
   ```
3. Go to GitHub → Actions → "Build fkOs Kernel" → Run workflow
4. Download the `fkOs-kernel` artifact when done
5. The kernel (bzImage) will be available for ISO creation

## Next: ISO Build
Once kernel is built, create a separate workflow for ISO generation using the kernel artifact.
