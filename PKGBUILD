# shellcheck disable=SC2148
# Maintainer: Bradford Adams <bradfordaldenadams@gmail.com.com>
pkgname=aur-blacklist-scanner-git
pkgver=r3.3c4f68a # This auto-updates when built
pkgrel=1
pkgdesc="Automated tool to scan installed AUR packages against the latest threat lists"
arch=('any')
url="https://github.com/Bradford1040/aur-blacklist-scanner"
license=('GPL3')
depends=('bash' 'curl' 'libnotify')
optdepends=('fish: for the CachyOS/KDE optimized script'
    'konsole: for the KDE desktop launcher')
source=("git+https://github.com/Bradford1040/aur-blacklist-scanner.git")
sha256sums=('SKIP')

pkgver() {
    cd "$srcdir/${pkgname%-git}"
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
    cd "$srcdir/${pkgname%-git}"

    # Install scripts
    install -Dm755 aur-scan-kde.fish "$pkgdir/usr/bin/aur-scan-kde"
    install -Dm755 aur-scan-universal.sh "$pkgdir/usr/bin/aur-scan-universal"

    # Install desktop shortcuts
    install -Dm644 aur-scan-kde.desktop "$pkgdir/usr/share/applications/aur-scan-kde.desktop"
    install -Dm644 aur-scan-universal.desktop "$pkgdir/usr/share/applications/aur-scan-universal.desktop"

    # Install systemd user timer & service
    install -Dm644 aur-scanner.service "$pkgdir/usr/lib/systemd/user/aur-scanner.service"
    install -Dm644 aur-scanner.timer "$pkgdir/usr/lib/systemd/user/aur-scanner.timer"

    # Install custom avatar icon
    install -Dm644 avatar.png "$pkgdir/usr/share/pixmaps/aur-blacklist-scanner.png"
}
