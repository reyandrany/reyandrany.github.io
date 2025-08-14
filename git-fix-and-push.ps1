# Pastikan script dijalankan dari folder repo
Write-Host "Folder saat ini: $(Get-Location)"

# 1. Cek & ubah remote ke SSH kalau masih HTTPS
$remoteUrl = git remote get-url origin
if ($remoteUrl -match "^https://github.com/(.+?)/(.+?)(\.git)?$") {
    $user = $matches[1]
    $repo = $matches[2]
    $sshUrl = "git@github.com:$user/$repo.git"

    Write-Host "Mengubah remote dari HTTPS ke SSH..."
    git remote set-url origin $sshUrl
    Write-Host "Remote berhasil diubah ke SSH: $sshUrl"
}
elseif ($remoteUrl -match "^git@github.com:(.+?)/(.+?)\.git$") {
    Write-Host "Remote sudah SSH: $remoteUrl"
}
else {
    Write-Host "Remote URL tidak dikenali: $remoteUrl"
}

# 2. Tes koneksi SSH
Write-Host "Menguji koneksi SSH ke GitHub..."
ssh -T git@github.com

# 3. Sinkronkan HEAD
Write-Host "Menarik perubahan terbaru (rebase)..."
git pull --rebase

# 4. Tambah semua perubahan
Write-Host "Menambahkan semua perubahan..."
git add .

# 5. Commit
$commitMessage = Read-Host "Masukkan pesan commit"
if (-not $commitMessage) { $commitMessage = "Update otomatis" }
git commit -m "$commitMessage"

# 6. Push
Write-Host "Mengirim perubahan ke origin/main..."
git push origin main

Write-Host "Selesai!"
