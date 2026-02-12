# Pull Request

Create a Pull Request from `feature/*` branch to `dev` for repository $1.

## Instructions

**CRITICAL**: All claims in the PR description MUST be based on actual code implementation, NOT on ADRs, Feature descriptions, or other documentation. Read the code to verify what was actually implemented before making any statement about functionality, architecture, or behavior.

Before creating the PR, you MUST:

1. **Identify Work Items**: Extract all WI IDs from commit messages

2. **Fetch Azure DevOps context**: For each unique Feature ID found:

   - Get Feature title and description
   - Get related User Stories and Tasks
   - Understand the scope of the feature

3. **Analyze all commits**:

   - Run `git log --oneline dev..HEAD` to see all commits
   - Run `git diff dev...HEAD --stat` to see files changed
   - Understand the full scope of changes

4. **Read modified files** to understand the implementation

5. **Create the PR** with:

   - Title: `[<Feature ID>] <Feature Title>`
   - Body following template:

     ```
     ## Summary
     <3-5 bullet points describing main changes>

     ## Work Items
     - Feature XXX: <title>
       - US: XXX.1 - <title>
       - US: XXX.2 - <title>

     ## Notes for the reviewer
     <Important points to check>
     ```

## Arguments

- $1: Repository name (e.g., `api`, `webapp`)
