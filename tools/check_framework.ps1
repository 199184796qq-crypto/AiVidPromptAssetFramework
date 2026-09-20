param([string]$Root = (Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path -LiteralPath $Root).Path
$issues = 0
$warnings = 0
function Report($level, $message) {
    Write-Output "$level $message"
    if ($level -eq 'ERROR') { $script:issues++ }
    if ($level -eq 'WARN') { $script:warnings++ }
}
$pages = @('架构导航.md','core/workflow.md','integrations/models.md','integrations/README.md','evaluation/README.md')
foreach ($page in $pages) {
    $path = Join-Path $Root $page
    if (!(Test-Path -LiteralPath $path)) { Report ERROR "入口缺失：$page"; continue }
    $body = Get-Content -LiteralPath $path -Raw -Encoding utf8
    foreach ($match in [regex]::Matches($body, '\]\(([^)]+)\)')) {
        $target = $match.Groups[1].Value
        if ($target -match '^[a-z]+:|^#') { continue }
        $resolved = Join-Path (Split-Path $path -Parent) ($target.Split('#')[0])
        if (!(Test-Path -LiteralPath $resolved)) { Report ERROR "$page 链接缺失：$target" }
    }
}
try {
    $state = Get-Content -LiteralPath (Join-Path $Root '用户定制规则/当前活动规则.json') -Raw -Encoding utf8 | ConvertFrom-Json
    $log = Get-Content -LiteralPath (Join-Path $Root '用户定制规则/规则变更日志.md') -Raw -Encoding utf8
    $ids = @([regex]::Matches($log, '(?m)^#{1,3}\s*(R\d+)\b') | ForEach-Object { $_.Groups[1].Value })
    if ($ids -notcontains $state.activeThrough) { Report WARN "活动版本未找到独立日志标题：$($state.activeThrough)" }
    foreach ($group in ($ids | Group-Object | Where-Object Count -gt 1)) { Report WARN "重复版本标题：$($group.Name)" }
    foreach ($supplement in @($state.activeSupplements)) {
        if (!$supplement) { continue }
        $entry = $state.supplementEntries.$supplement
        if (!$entry -or !(Test-Path -LiteralPath (Join-Path $Root $entry))) { Report ERROR "活动补充入口缺失：$supplement" }
        if ($ids -notcontains $supplement) { Report ERROR "活动补充日志缺失：$supplement" }
    }
    $newer = @($ids | Where-Object { [int]$_.Substring(1) -gt [int]$state.activeThrough.Substring(1) -and $_ -notin @($state.activeSupplements) } | Sort-Object -Unique)
    if ($newer.Count) { Report WARN "日志含比活动指针更新的记录：$($newer -join ', ')；不自动激活" }
    Report PASS "活动指针读取成功：$($state.activeThrough)"
} catch { Report ERROR "版本读取失败：$($_.Exception.Message)" }
try {
    $manifest = Get-Content -LiteralPath (Join-Path $Root '辅助技能/原包校验清单.json') -Raw -Encoding utf8 | ConvertFrom-Json
    foreach ($item in $manifest.files) {
        $path = Join-Path $Root $item.path
        if (!(Test-Path -LiteralPath $path)) { Report ERROR "原包文件缺失：$($item.path)"; continue }
        if ((Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash -ne $item.sha256) { Report ERROR "原包内容变化：$($item.path)" }
    }
} catch { Report ERROR "原包校验读取失败：$($_.Exception.Message)" }
Write-Output "检查完成：ERROR=$issues WARN=$warnings；未修改文件"
if ($issues) { exit 1 }
