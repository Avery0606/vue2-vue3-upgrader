#!/usr/bin/env pwsh
# Vue3 Migration Helper Script
# Usage: ./scripts/migrate.ps1 <project-path>

param(
    [string]$ProjectPath = ".",
    [switch]$DryRun,
    [switch]$Help
)

if ($Help -or $args.Contains("--help")) {
    Write-Host "Vue3 Migration Helper"
    Write-Host ""
    Write-Host "Usage: ./scripts/migrate.ps1 <project-path> [options]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  --dry-run     Show changes without applying"
    Write-Host "  --help        Show this help message"
    Write-Host "  --phase N     Run specific phase (1-5)"
    Write-Host ""
    Write-Host "Phases:"
    Write-Host "  1. vue-codemod transformation"
    Write-Host "  2. FIXME fixes"
    Write-Host "  3. Checklist modifications"
    Write-Host "  4. Build and error fix"
    Write-Host "  5. Verification"
    exit 0
}

Write-Host "Vue3 Migration Helper" -ForegroundColor Cyan
Write-Host "Project: $ProjectPath" -ForegroundColor Cyan

# Check for vue-codemod
$codemodAvailable = $false
try {
    $null = Get-Command npx -ErrorAction Stop
    $codemodAvailable = $true
} catch {
    Write-Host "Warning: npx not found. Install with: npm install -g @vue-codemod/cli" -ForegroundColor Yellow
}

if ($codemodAvailable) {
    Write-Host ""
    Write-Host "Ready to migrate. Run these commands:"
    Write-Host ""
    Write-Host "  # Phase 1: vue-codemod"
    Write-Host "  npx @vue-codemod/cli $ProjectPath --transform=vue3 --dry" -ForegroundColor Green
    Write-Host ""
    Write-Host "  # Phase 2: Find FIXME comments"
    Write-Host "  rg '// FIXME:' --type vue --type js" -ForegroundColor Green
    Write-Host ""
    Write-Host "  # Phase 3: Run checklist checks"
    Write-Host "  # See references/checklist.md" -ForegroundColor Green
    Write-Host ""
    Write-Host "  # Phase 4: Build"
    Write-Host "  npm run build" -ForegroundColor Green
    Write-Host ""
    Write-Host "  # Phase 5: Test"
    Write-Host "  npm test" -ForegroundColor Green
}

# Search patterns for Phase 3
Write-Host ""
Write-Host "=== Quick Search Patterns ===" -ForegroundColor Cyan

$patterns = @(
    @{ Name = "Vue Global API"; Pattern = "Vue\.(component|directive|mixin|use|prototype|extend)" },
    @{ Name = "v-model"; Pattern = "v-model" },
    @{ Name = "Lifecycle"; Pattern = "beforeDestroy|destroyed" },
    @{ Name = "Events API"; Pattern = "\$on|\$off|\$once" },
    @{ Name = "Filters"; Pattern = "filters:" },
    @{ Name = "Scoped Slots"; Pattern = "\$scopedSlots" },
    @{ Name = "Native modifier"; Pattern = "\.native" },
    @{ Name = "Data option"; Pattern = "^data:\s*\{" },
    @{ Name = "Watch array"; Pattern = "watch:\s*\{.*\{" },
    @{ Name = "Directives"; Pattern = "bind:|inserted:|update:|unbind:" },
    @{ Name = "Functional"; Pattern = "functional:\s*true" },
    @{ Name = "Async"; Pattern = "component:\s*=>" }
)

foreach ($p in $patterns) {
    Write-Host $p.Name.PadRight(20) -ForegroundColor Yellow -NoNewline
    Write-Host "  rg '$($p.Pattern)' --type vue"
}

Write-Host ""
Write-Host "Migration helper ready." -ForegroundColor Green
